# Rotary Parking

Rotary Parking is a Flutter mobile application for discovering parking locations on a Google Map, viewing live slot availability, and making a simulated parking reservation. The app also includes Firebase email/password authentication and profile management.

> **Project status:** This is a graduation-project prototype. Reservations and countdowns are stored in app memory, and the **Pay Now** button does not process a real payment. See [Current limitations](#current-limitations) before using this app in production.

<img width="1603" height="902" alt="gp" src="https://github.com/user-attachments/assets/caac71bf-9d06-449c-b236-b02f7ff0f39b" />

## Features

- Google Map displaying parking locations around Helwan, Egypt.
- Custom parking markers with an info window, free-slot count, and a link to the reservation screen.
- Current-location permission and map location controls.
- Email/password account registration, login, password reset, profile viewing, and sign out through Firebase Authentication.
- Four locally managed parking slots, selectable reservation duration, estimated price, booking confirmation, and a countdown display.
- BLoC state management for map and parking flows.

## Tech stack

- Flutter and Dart
- `flutter_bloc` / `bloc`
- Firebase Core and Firebase Authentication
- Google Maps Flutter, Geolocator, and Flutter Polyline Points
- Lottie animations

## Requirements

- Flutter SDK compatible with the Dart constraint in [`pubspec.yaml`](pubspec.yaml) (`>=3.4.3 <4.0.0`).
- Android Studio or another Android SDK installation for Android builds.
- A Firebase project with **Email/Password** authentication enabled.
- A Google Maps Platform API key with the APIs used by your configuration enabled.

## Getting started

1. Clone the repository and enter its directory:

   ```bash
   git clone https://github.com/TalaatMohamed2911/Graduation-Project-Rotary-Parking-App-.git
   cd Graduation-Project-Rotary-Parking-App-
   ```

2. Install dependencies:

   ```bash
   flutter pub get
   ```

3. Configure Firebase for your own Firebase project:

   - Register the app using the Android application ID in `android/app/build.gradle`.
   - Replace `android/app/google-services.json` with the configuration file for your Firebase Android app.
   - Update the `FirebaseOptions` passed to `Firebase.initializeApp` in `lib/main.dart` with the matching project values.
   - In Firebase Console, enable **Authentication → Sign-in method → Email/Password**.

4. Configure Google Maps:

   - Create a Google Maps Platform API key and enable the Maps SDK for Android and Routes API as required by the map and route features.
   - Set the key in the Android Maps metadata in `android/app/src/main/AndroidManifest.xml` and in `googleMapsApiKey` in `lib/consts.dart`.
   - Restrict the key to the required APIs and your app's package/signing certificate. For iOS, configure a platform-specific key and the required Google Maps iOS setup before building for that platform.

5. Start the app on an emulator or connected device:

   ```bash
   flutter run
   ```

The map requests location permission at runtime. Allow location access and enable device location services to use location features. Parking markers and the map can still load if location access is unavailable.

## How to use the app

1. Launch the app. After the splash screen, the parking map is displayed.
2. Tap a parking marker to open its information window. The free-slot count is fetched from the configured slots service.
3. Tap **Book** in the info window to open the parking-slot list.
4. Choose an available slot, enter your name and vehicle number, and select a duration. The displayed amount updates with the selected duration.
5. Tap **Pay Now** to create a local prototype booking and view its confirmation.
6. Return to the slot list to see the slot marked occupied while its countdown is active.
7. Use the account icon on the map to register or log in, or open your profile when signed in.

## Project structure

| Path | Purpose |
| --- | --- |
| `lib/main.dart` | Firebase initialization, app entry point, and routes |
| `lib/bloc/` | Map and parking BLoCs, events, and states |
| `lib/screens/` | Splash, map, reservation, and booking screens |
| `lib/auth/` | Login, sign-up, and profile screens |
| `lib/components/` | Reusable widgets, including parking-slot UI |
| `lib/consts.dart` | Parking-marker coordinates, images, and Routes API key setting |
| `lib/utils/slotsnumber.dart` | Client for the remote free-slot availability service |
| `assets/` | Map marker images and Lottie animations |

## Development checks

Run static analysis and tests:

```bash
flutter analyze
flutter test
```

Build a debug APK:

```bash
flutter build apk --debug
```

## Current limitations

- Booking state is held in memory by `ParkingBloc`. It is not saved to a database and is lost when the app process is restarted.
- **Pay Now** is a prototype action only; no payment gateway or transaction is connected.
- The free-slot count is retrieved from an external service in `lib/utils/slotsnumber.dart`. Availability depends on that service being reachable and returning the expected response.
- Map routes can be requested by the map BLoC, but a route-selection flow is not currently exposed in the map UI.
- Google and Apple login buttons are not connected to provider sign-in flows; email/password is the implemented authentication method.
- The countdown is a local demonstration and is not synchronized with a server or real parking session.

## Before publishing or deploying

The current project contains Google Maps and Firebase configuration in application files. Do not publish unrestricted credentials or reuse the prototype configuration for a production deployment. Replace these values with credentials owned by your project, restrict API keys, and use an appropriate per-platform configuration and secret-management approach. Also review Firebase Authentication security settings, the external availability service, application signing, and privacy disclosures before release.
