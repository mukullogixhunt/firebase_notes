# Firebase Notes App

A simple Flutter application demonstrating CRUD (Create, Read, Update, Delete) operations for notes, integrated with Firebase for backend services including Authentication (Email/Password, Google Sign-In) and Firestore Database.

## Features

*   User Authentication:
    *   Sign Up with Email & Password
    *   Sign In with Email & Password
    *   Sign In with Google
    *   Sign Out
*   Notes Management (User-specific):
    *   Create new notes
    *   View a list of existing notes
    *   Edit existing notes
    *   Delete notes
*   User Profile display
*   Persistence using Firebase Firestore
*   Local caching of user details using `shared_preferences`.

## Prerequisites

*   [Flutter SDK](https://flutter.dev/docs/get-started/install) (latest stable version recommended)
*   An IDE like [Visual Studio Code](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio)
*   A configured Firebase project.
*   An Android Emulator/Device or iOS Simulator/Device.

## Firebase Setup

This project requires a Firebase project to handle authentication and database storage.

1.  **Create Firebase Project:** Go to the [Firebase Console](https://console.firebase.google.com/) and create a new project.
2.  **Enable Authentication:**
    *   In the Firebase console, navigate to **Authentication** (under Build).
    *   Go to the **Sign-in method** tab.
    *   Enable **Email/Password** provider.
    *   Enable **Google** provider. You might need to provide a project support email.
3.  **Enable Firestore:**
    *   Navigate to **Firestore Database** (under Build).
    *   Click **Create database**.
    *   Start in **Test mode** for easy setup (remember to configure proper security rules for production!). Select a Firestore location.
4.  **Register Apps:**
    *   In your Firebase project settings (⚙️ icon > Project settings), add your Flutter app for **Android** and **iOS**.
    *   Follow the on-screen instructions carefully.
        *   **Android:** Provide the package name (e.g., `com.example.firebase_notes`). Download the `google-services.json` file. You **must** add your debug signing certificate SHA-1 (and potentially SHA-256) fingerprint to the Firebase project settings for Google Sign-In to work. You can get it using `cd android && ./gradlew signingReport`.
        *   **iOS:** Provide the iOS bundle ID. Download the `GoogleService-Info.plist` file. Ensure you add the `REVERSED_CLIENT_ID` from the `.plist` file to your `ios/Runner/Info.plist` as a URL Scheme (see Firebase documentation for details).
5.  **Place Configuration Files:**
    *   Place the downloaded `google-services.json` file inside the `android/app/` directory of your Flutter project.
    *   Place the downloaded `GoogleService-Info.plist` file inside the `ios/Runner/` directory of your Flutter project (use Xcode to add it correctly).
6.  **Platform Configuration:** Ensure you have completed any additional platform-specific setup steps mentioned in the Firebase documentation (like adding dependencies to `build.gradle` files for Android or configuring `Info.plist` for iOS).

## Project Setup (Local)

1.  **Clone the Repository:**
    ```bash
    git clone https://github.com/mukullogixhunt/firebase_notes.git
    ```
2.  **Navigate to Project Directory:**
    ```bash
    cd firebase_notes
    ```
3.  **Install Dependencies:**
    ```bash
    flutter pub get
    ```

## Running the App

1.  Ensure you have a connected device (Android/iOS) or a running emulator/simulator.
2.  Make sure you have completed the Firebase Setup steps above, including placing the configuration files.
3.  Run the app using the Flutter CLI:
    ```bash
    flutter run
    ```

## Code Structure

The project follows a feature-first structure combined with layered architecture principles (inspired by Clean Architecture).

*   `lib/`
    *   `core/`: Contains shared code used across multiple features.
        *   `constants/`: Application constants (e.g., media paths).
        *   `errors/`: Custom Failure and Exception classes.
        *   `extentions/`: Dart extension methods.
        *   `usecases/`: Base use case definition.
        *   `utils/`: Utility classes (e.g., `CacheHelper`, `FullScreenLoader`).
    *   `features/`: Contains individual feature modules.
        *   `auth/`: Authentication related code.
            *   `data/`: Data layer (Repositories implementation, Data sources, Models).
            *   `domain/`: Domain layer (Entities, Repositories interface, Use cases).
            *   `presentation/`: Presentation layer (Bloc, Screens/Widgets).
        *   `notes/`: Notes related code (following the same layered structure as `auth`).
    *   `injection_container.dart`: Dependency injection setup using `get_it`.
    *   `main.dart`: App entry point, BlocProvider setup, and initial routing.

## Design Decisions

*   **State Management:** `flutter_bloc` is used for state management. This choice promotes separation of concerns (UI from business logic), improves testability, and provides a predictable state flow, which is beneficial for managing asynchronous operations like Firebase calls.
*   **Architecture:** A layered approach (Presentation, Domain, Data) within each feature module helps in creating maintainable, scalable, and testable code. It isolates dependencies (e.g., UI doesn't know about Firebase directly) and clarifies the role of each code component.
*   **Dependency Injection:** `get_it` is used as a service locator to manage dependencies. This decouples classes from their concrete implementations, making the code easier to test and modify.
*   **Routing:** `go_router` (implied by usage) handles navigation. It offers type-safe routing, simplifies deep linking, and provides a clear way to manage navigation flow.
*   **Error Handling:** `dartz` package (specifically the `Either` type) is used in the Domain and Data layers to explicitly handle success and failure states returned from use cases and repositories. This forces the Presentation layer (Bloc) to acknowledge and manage potential errors gracefully.
*   **Firebase Integration:** Firebase Auth and Firestore are used as the backend-as-a-service, simplifying backend development for authentication and data storage.
*   **Immutability & Equality:** `equatable` is used for entities and states to simplify equality checks and ensure immutability, which works well with Bloc.
*   **Local Caching:** `shared_preferences` (via `CacheHelper`) is used for simple local caching of user ID and basic user details, potentially reducing unnecessary fetches.

## Key Dependencies

*   `flutter_bloc`: State Management
*   `firebase_core`: Firebase initialization
*   `firebase_auth`: Firebase Authentication
*   `cloud_firestore`: Firebase Firestore Database
*   `google_sign_in`: Google Sign-In functionality
*   `get_it`: Service Locator for Dependency Injection
*   `go_router`: Navigation
*   `equatable`: Value equality simplification
*   `dartz`: Functional programming types (`Either` for error handling)
*   `shared_preferences`: Local key-value storage

## License
