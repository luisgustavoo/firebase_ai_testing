---
inclusion: always
---

# Project Structure & Architecture

## Folder Organization

```
lib/
├── main.dart                    # App entry point, Firebase & DI initialization
├── firebase_options.dart        # Generated Firebase config (FlutterFire CLI)
├── config/                      # Dependency injection setup
│   ├── dependencies.dart        # GetIt configuration with @InjectableInit
│   └── dependencies.config.dart # Generated DI code
├── routing/                     # go_router configuration
├── data/                        # Data layer
│   ├── services/                # External service integrations
│   │   ├── firebase_ai_service.dart
│   │   └── model/               # Service-specific models
│   └── repositories/            # Repository pattern implementations
├── ui/                          # Presentation layer
│   ├── camera_preview/
│   │   ├── view_models/         # ChangeNotifier-based ViewModels
│   │   └── widget/              # Screen widgets
│   ├── expense/
│   └── home/
└── utils/                       # Shared utilities
    ├── command.dart             # Command pattern for async operations
    └── result.dart              # Result type for error handling
```

## Architecture Patterns

**Layered Architecture:**
- **UI Layer:** Widgets + ViewModels (ChangeNotifier)
- **Data Layer:** Repositories → Services → External APIs/Firebase
- **Dependency Injection:** Injectable + GetIt with code generation

**Key Conventions:**

1. **Dependency Injection:**
   - Use `@lazySingleton` for services and repositories
   - Use `@postConstruct` or `@PostConstruct()` for initialization logic
   - Register dependencies via `configureDependencies()` in main.dart

2. **Repositories (Source of Truth):**
   - Extend `ChangeNotifier` to notify listeners of state changes
   - Call `notifyListeners()` after state changes (login, logout, data updates)
   - Handle business logic and data persistence
   - Do NOT perform input validation (validation belongs in UI layer)

3. **ViewModels:**
   - Extend `ChangeNotifier`
   - Use `Command` pattern from `utils/command.dart` for async operations
   - Inject repositories via constructor
   - Coordinate between UI and repositories (thin layer)
   - Do NOT perform input validation (validation belongs in UI layer)
   - Call `notifyListeners()` after state changes

4. **UI Layer (Validation):**
   - Use `TextFormField` with `validator` parameter for input validation
   - Use validators from `utils/validators.dart`
   - Example: `validator: Validators.validateEmail`
   - Validation happens in UI, NOT in ViewModels or Repositories

5. **Models:**
   - Use `@freezed` for immutable data classes
   - Include `fromJson`/`toJson` for serialization
   - Generate with: `part 'filename.freezed.dart'` and `part 'filename.g.dart'`

6. **Error Handling:**
   - Use `Result<T>` type from `utils/result.dart`
   - Pattern match with `Ok()` and `Error()` cases

7. **Firebase AI Integration:**
   - Configure `GenerativeModel` with system instructions
   - Use `FunctionDeclaration` for AI function calling
   - Handle function calls in service layer before returning final response

## Code Generation

Always run after modifying:
- `@Injectable` annotations → `flutter pub run build_runner build --delete-conflicting-outputs`
- `@freezed` models → same command
- `@JsonSerializable` classes → same command
