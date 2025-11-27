# Technology Stack

## Framework & Language

- Flutter SDK ^3.9.2
- Dart language
- Multi-platform: Android and iOS

## Core Dependencies

### Firebase
- `firebase_core` - Firebase initialization
- `firebase_ai` - AI/ML capabilities
- `firebase_app_check` - Backend security (Play Integrity/Device Check)

### Architecture & State Management
- `get_it` + `injectable` - Dependency injection with code generation
- `go_router` - Declarative routing
- `ChangeNotifier` - State management for ViewModels

### Code Generation
- `freezed` + `freezed_annotation` - Immutable models and unions
- `json_serializable` - JSON serialization
- `injectable_generator` - DI code generation
- `build_runner` - Code generation orchestration

### Platform Features
- `camera` - Native camera integration

## Common Commands

### Setup
```bash
# Install dependencies
flutter pub get

# Generate code (DI, models, serialization)
flutter pub run build_runner build --delete-conflicting-outputs
```

### Development
```bash
# Run app
flutter run

# Run on specific device
flutter run -d <device-id>

# Hot reload is automatic during development
```

### Code Generation
```bash
# Watch mode for continuous generation
flutter pub run build_runner watch --delete-conflicting-outputs

# Clean and rebuild
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### Linting
```bash
# Analyze code
flutter analyze
```

## Build Configuration

- Linter: `flutter_lints` package
- Formatter: Preserves trailing commas (see `analysis_options.yaml`)
- Firebase config generated via FlutterFire CLI

## Platform-Specific Files

- Android: `android/app/google-services.json`
- iOS: `ios/Runner/GoogleService-Info.plist`
- Generated options: `lib/firebase_options.dart`
