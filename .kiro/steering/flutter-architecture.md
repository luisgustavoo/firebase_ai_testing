# Flutter Architecture Guidelines

Este documento define as diretrizes de arquitetura para o projeto, seguindo as recomendações oficiais do Flutter.

## View-ViewModel Relationship (1:1)

**REGRA FUNDAMENTAL**: Cada View DEVE ter exatamente 1 ViewModel correspondente.

### Estrutura de Pastas

```
lib/ui/
├── feature_name/
│   ├── view_models/
│   │   └── feature_viewmodel.dart
│   ├── widgets/
│   │   └── feature_screen.dart
│   └── feature.dart (barrel file)
```

### View (Widget)

- **Responsabilidades**:
  1. Renderizar UI baseada no estado do ViewModel
  2. Escutar mudanças do ViewModel usando `ListenableBuilder`
  3. Capturar eventos do usuário e delegá-los ao ViewModel

- **Regras**:
  - SEMPRE receber o ViewModel via construtor (nunca usar `getIt` diretamente na View)
  - NUNCA acessar repositórios diretamente
  - NUNCA conter lógica de negócio

**Exemplo correto**:

```dart
class HomeScreen extends StatefulWidget {
  const HomeScreen({
    required this.viewModel,  // ✅ ViewModel via construtor
    super.key,
  });

  final HomeViewModel viewModel;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,  // ✅ Escuta mudanças
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.viewModel.userName),  // ✅ Usa estado do ViewModel
          ),
          body: _buildBody(),
        );
      },
    );
  }
}
```

### ViewModel

- **Responsabilidades**:
  1. Gerenciar estado da UI
  2. Processar eventos do usuário
  3. Coordenar com repositórios (camada de dados)
  4. Notificar Views sobre mudanças de estado

- **Regras**:
  - SEMPRE estender `ChangeNotifier`
  - SEMPRE receber dependências (repositórios) via construtor
  - SEMPRE usar `@injectable` para injeção de dependências
  - SEMPRE chamar `notifyListeners()` após mudanças de estado
  - NUNCA acessar widgets ou contexto do Flutter

**Exemplo correto**:

```dart
@injectable
class HomeViewModel extends ChangeNotifier {
  HomeViewModel({
    required AuthRepository authRepository,  // ✅ Dependências via construtor
  }) : _authRepository = authRepository {
    _loadData();
  }

  final AuthRepository _authRepository;  // ✅ Repositório privado

  User? _currentUser;

  // ✅ Estado exposto como getters públicos
  User? get currentUser => _currentUser;
  String get userName => _currentUser?.name ?? 'Usuário';

  Future<void> _loadData() async {
    final result = await _authRepository.getProfile();
    switch (result) {
      case Ok(:final value):
        _currentUser = value;
        notifyListeners();  // ✅ Notifica listeners
      case Error():
        break;
    }
  }
}
```

## Injeção de Dependências

### ViewModels

- Registrar com `@injectable` ou `@lazySingleton`
- Receber todas as dependências via construtor

### Views

- Receber ViewModel via construtor
- Injetar ViewModel na rota usando `getIt()`

**Exemplo de rota**:

```dart
GoRoute(
  path: '/home',
  builder: (context, state) {
    return HomeScreen(viewModel: getIt());  // ✅ Injeta ViewModel
  },
),
```

## Command Pattern

Use `Command` para operações assíncronas que precisam gerenciar estados de loading/error:

```dart
class MyViewModel extends ChangeNotifier {
  MyViewModel({required MyRepository repository}) 
    : _repository = repository {
    loadCommand = Command0(_load);
  }

  late Command0<void> loadCommand;

  Future<Result<void>> _load() async {
    return _repository.loadData();
  }
}
```

Na View:

```dart
if (viewModel.loadCommand.running) {
  return LoadingIndicator();
}

if (viewModel.loadCommand.error) {
  return ErrorView(
    onRetry: viewModel.loadCommand.execute,
  );
}
```

## Widgets Reutilizáveis

Widgets pequenos e reutilizáveis (como `LogoutButton`) podem ter seus próprios ViewModels:

```dart
// ✅ LogoutButton tem seu próprio LogoutViewModel
class LogoutButton extends StatefulWidget {
  const LogoutButton({
    required this.viewModel,
    super.key,
  });

  final LogoutViewModel viewModel;
  // ...
}
```

## Separação de Responsabilidades em Repositórios

### Princípio de Responsabilidade Única

Cada repositório deve ter uma responsabilidade clara e bem definida:

**AuthRepository** - Apenas autenticação:
- Login
- Logout  
- Registro
- Gerenciamento de tokens
- Estado de autenticação

**UserRepository** - Gerenciamento de dados do usuário:
- Buscar perfil do usuário
- Cache local de dados do usuário
- Atualizar dados do usuário
- Limpar cache

**Exemplo de cache em repositório**:

```dart
@lazySingleton
class UserRepository extends ChangeNotifier {
  UserRepository(this._apiService);

  final ApiService _apiService;
  User? _cachedUser;

  User? get user => _cachedUser;

  Future<Result<User>> getUser() async {
    if (_cachedUser == null) {
      // No cached data, fetch from API
      final result = await _apiService.getUserProfile();
      return switch (result) {
        Ok(:final value) => _handleUserFetched(value),
        Error(:final error) => Result.error(error),
      };
    } else {
      // Return cached data
      return Result.ok(_cachedUser!);
    }
  }

  Result<User> _handleUserFetched(UserApiModel userApi) {
    final user = UserMapper.toDomain(userApi);
    _cachedUser = user;
    notifyListeners();
    return Result.ok(user);
  }

  void clearUser() {
    _cachedUser = null;
    notifyListeners();
  }
}
```

## Checklist de Revisão

Antes de fazer commit, verifique:

- [ ] Cada View tem exatamente 1 ViewModel?
- [ ] ViewModels recebem dependências via construtor?
- [ ] Views recebem ViewModel via construtor?
- [ ] ViewModels estendem `ChangeNotifier`?
- [ ] ViewModels chamam `notifyListeners()` após mudanças?
- [ ] Views usam `ListenableBuilder` para escutar mudanças?
- [ ] Nenhuma View acessa repositórios diretamente?
- [ ] ViewModels estão registrados com `@injectable`?
- [ ] Repositórios têm responsabilidades bem definidas?
- [ ] Cache implementado onde apropriado?

## Referências

- [Flutter Architecture Guide](https://docs.flutter.dev/app-architecture/guide)
- [Flutter Architecture Concepts](https://docs.flutter.dev/app-architecture/concepts)
- [Flutter Architecture Guide](https://docs.flutter.dev/app-architecture/guide)
- [Flutter Architecture Case Study](https://docs.flutter.dev/app-architecture/case-study)
- [Flutter Architecture UI Layer](https://docs.flutter.dev/app-architecture/case-study/ui-layer)
- [Flutter Architecture Data Layer](https://docs.flutter.dev/app-architecture/case-study/data-layer)
- [Flutter Architecture Dependency Injection](https://docs.flutter.dev/app-architecture/case-study/dependency-injection)
- [Flutter Architecture Testing](https://docs.flutter.dev/app-architecture/case-study/testing)
- [Flutter Architecture Recommendations](https://docs.flutter.dev/app-architecture/recommendations)
- [Flutter Architecture Design Patterns](https://docs.flutter.dev/app-architecture/design-patterns)
