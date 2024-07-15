# `vault`

A new Flutter project.

This is very similar to the [Locker app](https://www.wantlocker.com/) with some notable aesthetic and implementation differences.

Vault has been built with Flutter for cross-platform support.
It is powered by a single SQLite database.
All data required for the app is stored locally.
Images and other media are downloaded and stored locally as well.
All app functionality is available offline.
The SQLite database file and all media files are synced between Apple devices using iCloud.
Users can access this SQLite database directly for advanced queries if desired.
It is trivial to export your data: You can simply copy the app data folder to wherever you desire.

Unlike Locker, Vault allows users to specify prices for items saved.
I will also be adding support for custom item properties soon.
The goal is to be fully extensible for any category of item that a user might want to save.

I use this project on my iPhone and my MacBook.
I save items from Instagram posts and web pages from my iPhone.
I then view those items on my MacBook and evaluate which purchases to make.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
