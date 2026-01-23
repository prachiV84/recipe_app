# 🍳 Recipe App

A Flutter recipe application for browsing and saving recipes from TheMealDB API.

## Features

- Search recipes by name
- Filter by category and cuisine
- Grid and list view modes
- Save favorite recipes offline
- Detailed recipe instructions with ingredients
- YouTube video integration
- Image zoom viewer

## Tech Stack

- Flutter & Dart
- Riverpod (state management)
- TheMealDB API
- SharedPreferences (local storage)
- GetIt (dependency injection)

## Getting Started

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Build APK
flutter build apk --release
```

## Testing

```bash
# Run all tests
flutter test

# With coverage
flutter test --coverage
```

## Project Structure

lib/
├── core/                           (Constants & DI)
├── data/                           (Models, Services, Repositories)
│   ├── models/          (1 file)   - Recipe model
│   ├── services/        (2 files)  - API & Storage services
│   └── repositories/    (1 file)   - Data abstraction
└── presentation/                   (UI & State Management)
    ├── pages/           (4 files)  - Home, List, Detail, Favorites
    ├── widgets/         (1 file)   - Reusable components
    └── providers/       (1 file)   - Riverpod state
```

## Requirements

- Flutter 3.0+
- Dart 3.0+
- Android API 21+

---

Made with Flutter
