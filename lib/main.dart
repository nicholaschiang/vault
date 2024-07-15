import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'dog.dart';

void main() {
  // Avoid errors caused by flutter upgrade.
  // Importing 'package:flutter/widgets.dart' is required.
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Database> futureDatabase;

  @override
  void initState() {
    super.initState();
    futureDatabase = setupDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Vault',
      home: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.plus),
              label: 'Add',
            ),
          ],
        ),
        tabBuilder: (BuildContext context, int index) {
          return index == 0 ? const HomePage() : const AddPage();
        },
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabView(
      builder: (BuildContext context) {
        return const CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(middle: Text('Home')),
          child: Center(
            child: Text('TODO: Show dog information here.'),
          ),
        );
      },
    );
  }
}

class AddPage extends StatelessWidget {
  const AddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabView(
      builder: (BuildContext context) {
        return const CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(middle: Text('Add')),
          child: Center(
            child: Text('TODO: Create dog form here.'),
          ),
        );
      },
    );
  }
}

Future<Database> setupDatabase() async {
  // Open the database and store the reference.
  final database = openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'doggie_database.db'),
    // When the database is first created, create a table to store dogs.
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      return db.execute(
        'CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)',
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );

  return database;
}

// Define a function that inserts dogs into the database
Future<void> insertDog(Future<Database> database, Dog dog) async {
  // Get a reference to the database.
  final db = await database;

  // Insert the Dog into the correct table. You might also specify the
  // `conflictAlgorithm` to use in case the same dog is inserted twice.
  //
  // In this case, replace any previous data.
  await db.insert(
    'dogs',
    dog.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

// A method that retrieves all the dogs from the dogs table.
Future<List<Dog>> dogs(Future<Database> database) async {
  // Get a reference to the database.
  final db = await database;

  // Query the table for all the dogs.
  final List<Map<String, Object?>> dogMaps = await db.query('dogs');

  // Convert the list of each dog's fields into a list of `Dog` objects.
  return [
    for (final {
          'id': id as int,
          'name': name as String,
          'age': age as int,
        } in dogMaps)
      Dog(id: id, name: name, age: age),
  ];
}

Future<void> updateDog(Future<Database> database, Dog dog) async {
  // Get a reference to the database.
  final db = await database;

  // Update the given Dog.
  await db.update(
    'dogs',
    dog.toMap(),
    // Ensure that the Dog has a matching id.
    where: 'id = ?',
    // Pass the Dog's id as a whereArg to prevent SQL injection.
    whereArgs: [dog.id],
  );
}

Future<void> deleteDog(Future<Database> database, int id) async {
  // Get a reference to the database.
  final db = await database;

  // Remove the Dog from the database.
  await db.delete(
    'dogs',
    // Use a `where` clause to delete a specific dog.
    where: 'id = ?',
    // Pass the Dog's id as a whereArg to prevent SQL injection.
    whereArgs: [id],
  );
}

void useDatabase() async {
  // Open the database and store the reference.
  var database = setupDatabase();

  // Create a Dog and add it to the dogs table
  var fido = Dog(
    id: 0,
    name: 'Fido',
    age: 35,
  );

  await insertDog(database, fido);

  // Now, use the method above to retrieve all the dogs.
  print(await dogs(database)); // Prints a list that include Fido.

  // Update Fido's age and save it to the database.
  fido = Dog(
    id: fido.id,
    name: fido.name,
    age: fido.age + 7,
  );
  await updateDog(database, fido);

  // Print the updated results.
  print(await dogs(database)); // Prints Fido with age 42.

  // Delete Fido from the database.
  await deleteDog(database, fido.id);

  // Print the list of dogs (empty).
  print(await dogs(database));
}
