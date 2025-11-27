# Project Structure

## Architecture Pattern

Clean architecture with separation of concerns:
- **UI Layer**: Screens and ViewModels
- **Data Layer**: Repositories and Services
- **Utils**: Shared utilities and patterns

## Folder Organization

```
lib/
├── config/              # App configuration
│   ├── dependencies.dart           # DI setup (get_it + injectable)
│   └── dependencies.config.dart    # Generated DI code
│
├── data/                # Data layer
│   ├── repositories/               # Repository pattern (business logic)
│   └── services/                   # External service integrations
│       └── model/                  # Data models (freezed + json_serializable)
│
├── routing/             # Navigation
│   ├── route.dart                  # GoRouter configuration
│   └── routes.dart                 # Route constants
│
├── ui/                  # Presentation layer
│   ├── camera_preview/
│   │   ├── view_models/           # Screen state management
│   │   └── widget/                # Screen widgets
│   ├── expense/
│   └── home/
│
├── utils/               # Shared utilities
│   ├── command.dart               # Command pattern for async actions
│   └── result.dart                # Result type for error handling
│
├── firebase_options.dart          # Generated Firebase config
└── main.dart                      # App entry point
```

## Key Conventions

### Dependency Injection
- Use `@injectable` for services and repositories
- Use `@lazySingleton` for ViewModels
- Use `@postConstruct` for initialization logic
- Access dependencies via `getIt()` from `config/dependencies.dart`

### State Management
- ViewModels extend `ChangeNotifier`
- Use `Command0` and `Command1` for async actions with loading/error states
- ViewModels injected into screens via constructor

### Routing
- Declarative routing with `go_router`
- Route definitions in `routing/route.dart`
- Route constants in `routing/routes.dart`
- Pass complex data via `state.extra`

### Data Models
- Use `@freezed` for immutable models
- Include JSON serialization with `fromJson`/`toJson`
- Models in `data/services/model/` directory
- Generate with `part` directives for `.freezed.dart` and `.g.dart`

### Error Handling
- Use `Result<T>` type (sealed class with `Ok` and `Error` variants)
- Pattern match with switch statements
- Propagate errors through repository → service layers

### Code Generation
- Run `build_runner` after modifying:
  - `@Injectable` annotations
  - `@freezed` models
  - `@JsonSerializable` classes
- Generated files use `.config.dart`, `.freezed.dart`, `.g.dart` suffixes

### File Naming
- Screens: `*_screen.dart`
- ViewModels: `*_view_model.dart`
- Models: `*_model.dart`
- Services: `*_service.dart`
- Repositories: `*_repository.dart`

### Firebase Integration
- Initialize in `main.dart` before `runApp()`
- Configure App Check with platform-specific providers
- Use debug providers in debug mode, production providers in release
