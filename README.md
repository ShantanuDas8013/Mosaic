# Mosaic

Mosaic is a community platform built with Flutter. It allows users to create and join communities, post content, interact with posts, and manage community moderation tools. The project demonstrates advanced Flutter concepts, state management with Riverpod, and integration with Firebase for authentication, storage, and real-time updates.

## Features

- **User Authentication:** Sign up, log in, and manage user sessions with Firebase Auth.
- **Community Management:** Create, join, and leave communities. Assign moderators and manage community settings.
- **Posting System:** Create text, image, and link posts within communities.
- **Feed & Comments:** View posts in communities, upvote/downvote, and comment on posts.
- **Moderation Tools:** Community moderators can manage members and content.
- **Responsive UI:** Works seamlessly on mobile, web, and desktop.
- **Theming:** Light and dark mode support.

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [Firebase Project](https://firebase.google.com/)
- Dart 3.x recommended

### Setup

1. **Clone the repository:**

   ```sh
   git clone https://github.com/yourusername/mosaic.git
   cd mosaic
   ```

2. **Install dependencies:**

   ```sh
   flutter pub get
   ```

3. **Firebase Configuration:**

   - Create a Firebase project.
   - Add Android, iOS, and Web apps in the Firebase console.
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) and place them in the respective directories.
   - For web, update `web/index.html` and add your Firebase config to `lib/firebase_options.dart` (if using [FlutterFire CLI](https://firebase.flutter.dev/docs/cli/)).

4. **Run the app:**
   ```sh
   flutter run
   ```

### Building for Desktop

- **Windows:**
  ```sh
  flutter config --enable-windows-desktop
  flutter run -d windows
  ```
- **Linux:**
  ```sh
  flutter config --enable-linux-desktop
  flutter run -d linux
  ```

## Folder Structure

- `lib/` - Main application code
  - `features/` - Feature modules (auth, community, post, etc.)
  - `core/` - Common widgets and utilities
  - `models/` - Data models
  - `theme/` - App theming
- `web/`, `windows/`, `linux/` - Platform-specific files

## Contributing

Contributions are welcome! Please open issues and submit pull requests for improvements or bug fixes.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Acknowledgements

- [Flutter](https://flutter.dev/)
- [Firebase](https://firebase.google.com/)
- [Riverpod](https://riverpod.dev/)
- [Routemaster](https://pub.dev/packages/routemaster)
