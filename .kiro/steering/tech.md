---
inclusion: always
---

# Tech Stack

**Framework:** Flutter (SDK ^3.9.2)  
**Language:** Dart  
**Platforms:** Android, iOS

## Core Dependencies

- `firebase_core` ^4.2.1 - Firebase initialization
- `firebase_ai` ^3.6.0 - Gemini AI integration with function calling
- `firebase_app_check` ^0.4.1+2 - Backend security
- `camera` ^0.11.3 - Camera access for receipt capture
- `go_router` ^17.0.0 - Declarative routing
- `get_it` ^9.1.0 + `injectable` ^2.6.0 - Dependency injection
- `freezed` ^3.2.3 + `freezed_annotation` ^3.1.0 - Immutable models
- `json_serializable` ^6.11.2 - JSON serialization
- `http` ^1.2.2 - HTTP client

## Code Generation Tools

- `build_runner` ^2.10.4
- `injectable_generator` ^2.9.1
- `freezed` + `json_serializable`

## Common Commands

```bash
# Install dependencies
flutter pub get

# Generate code (DI, models, serialization)
flutter pub run build_runner build --delete-conflicting-outputs

# Run app
flutter run

# Run on specific device
flutter run -d <device-id>

# Clean build
flutter clean && flutter pub get
```

## Firebase Configuration

- Android: `android/app/google-services.json`
- iOS: `ios/Runner/GoogleService-Info.plist`
- Generated options: `lib/firebase_options.dart` (FlutterFire CLI)
