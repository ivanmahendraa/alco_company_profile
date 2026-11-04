# ALCO Company Profile

A Flutter Android practicum project presenting company and business information
for PT. Alcotraindo Batam. The app uses local data and does not connect to a
backend, online database, or authentication service.

## Features

- Splash screen and local demo login.
- Dashboard, company profile, and business information screens.
- News and activity list with title-and-summary search.
- News details opened by stable item ID.
- In-memory bookmarks shared between the news list and detail screen.
- Local news images for the first three activities.

The first three news entries are activities provided and confirmed by the
project owner. Later entries are explicitly marked as fictional examples.

## Requirements

- Flutter SDK with Dart `^3.13.5`.
- Android SDK and an Android emulator or connected Android device.

Check the installed Flutter and Dart versions with:

```sh
flutter --version
```

## Run the app

From the project directory:

```sh
flutter pub get
flutter run
```

## Demo login

The login flow is a local practicum simulation only. It is not production
authentication, does not contact a backend or online service, and does not
store submitted passwords.

- Kartu ID: `123040014`
- Password: `Password`

## Validation

Run static analysis and the test suite with:

```sh
flutter analyze
flutter test
```

## Data and privacy

Company and news content, including the news images, are bundled as local
project assets. Search and bookmark state are held in memory; bookmarks are not
saved across app restarts. Do not use the demo login flow to handle real
credentials.
