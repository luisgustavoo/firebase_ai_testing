# Design Document - API Integration

## Overview

This design document outlines the architecture for integrating the Flutter expense tracking application with a REST API backend. The implementation follows Flutter's official architecture recommendations (https://docs.flutter.dev/app-architecture), organizing code into clear layers: Data, Domain, and Application. The system uses ChangeNotifier for state management and ListenableBuilder for reactive UI updates, ensuring a clean separation of concerns and maintainable codebase.

The integration replaces the current Firebase-only approach with a comprehensive API-based solution that handles:
- User authentication (registration, login, token management)
- Category management (CRUD operations)
- Transaction management (creation and paginated listing)
- Secure token storage and automatic header injection
- Comprehensive error handling and loading states

## Architecture

### Layer Structure

Following Flutter's recommended architecture, the system is organized into three main layers:

**1. Data Layer**
- **Services**: Wrap external API endpoints and expose asynchronous response objects (Future/Stream)
- **API Models**: Models representing API data structures (suffixed with `Api`)
- **Request/Response Models**: Models for API requests/responses (suffixed with `Request`/`Response`)
- **Repositories**: Abstract data sources and provide clean interfaces to the application layer
- **Token Storage**: Secure storage for JWT tokens using flutter_secure_storage

**2. Domain Layer**
- **Domain Models**: Business entities (User, Category, Transaction) separate from API models
- **Mappers**: Convert between API models and domain models
- **Result Types**: Encapsulate success/failure outcomes

**3. Application Layer**
- **ViewModels**: ChangeNotifier-based classes managing UI state
- **Commands**: Encapsulate async operations with loading/error states
- **Use Cases**: Optional layer for complex business logic

**4. Presentation Layer**
- **Screens**: Top-level widgets representing app pages
- **Widgets**: Reusable UI components
- **ListenableBuilder**: Reactive widgets that rebuild on state changes

### Dependency Flow

```
UI (Screens/Widgets)
    ↓ (observes)
ViewModels (ChangeNotifier)
    ↓ (calls)
Repositories
    ↓ (uses)
Services + API Models
    ↓ (communicates with)
REST API Backend
```

### Authentication Flow

```
1. User Login → ViewModel → Repository → API Client
2. API returns JWT token
3. Token stored in flutter_secure_storage
4. Interceptor automatically adds "Authorization: Bearer {token}" to all requests
5. On 401 error → Clear token → Navigate to login
```

## Components and Interfaces

### 1. API Service

**Purpose**: Wrap REST API endpoints and expose asynchronous response objects

**Key Responsibilities**:
- Configure base URL (http://localhost:8080)
- Set default headers (Content-Type: application/json)
- Implement request/response interceptors
- Handle timeouts (30 seconds default)
- Automatic token injection for authenticated requests
- Expose Future/Stream objects for async operations

**Interface**:
```dart
class ApiService {
  Future<Response> get(String path, {Map<String, dynamic>? queryParams});
  Future<Response> post(String path, {dynamic body});
  Future<Response> put(String path, {dynamic body});
  Future<Response> delete(String path);
  void setAuthToken(String? token);
}
```

### 2. Token Storage Service

**Purpose**: Securely store and retrieve JWT tokens

**Interface**:
```dart
class TokenStorageService {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> deleteToken();
  Future<bool> hasToken();
}
```

### 3. Auth Repository

**Purpose**: Handle authentication operations

**Dependencies**: ApiService, TokenStorageService

**Interface**:
```dart
class AuthRepository {
  Future<Result<User>> register(String name, String email, String password);
  Future<Result<AuthResponse>> login(String email, String password);
  Future<Result<User>> getProfile();
  Future<void> logout();
  Future<bool> isAuthenticated();
}
```

### 4. Category Repository

**Purpose**: Manage category CRUD operations

**Dependencies**: ApiService

**Interface**:
```dart
class CategoryRepository {
  Future<Result<List<Category>>> getCategories();
  Future<Result<Category>> createCategory(String description, String? icon);
  Future<Result<Category>> updateCategory(String id, String description, String? icon);
  Future<Result<void>> deleteCategory(String id);
}
```

### 5. Transaction Repository

**Purpose**: Manage transaction operations

**Dependencies**: ApiService

**Interface**:
```dart
class TransactionRepository {
  Future<Result<Transaction>> createTransaction(CreateTransactionRequest request);
  Future<Result<PaginatedTransactions>> getTransactions({
    int page = 1,
    int pageSize = 20,
    TransactionType? type,
  });
}
```

### 6. ViewModels

**Auth ViewModel**:
```dart
class AuthViewModel extends ChangeNotifier {
  Command<void> registerCommand;
  Command<void> loginCommand;
  Command<void> logoutCommand;
  User? currentUser;
  bool get isAuthenticated;
}
```

**Category ViewModel**:
```dart
class CategoryViewModel extends ChangeNotifier {
  Command<void> loadCategoriesCommand;
  Command<void> createCategoryCommand;
  Command<void> updateCategoryCommand;
  Command<void> deleteCategoryCommand;
  List<Category> categories;
  bool get isLoading;
  String? get error;
}
```

**Transaction ViewModel**:
```dart
class TransactionViewModel extends ChangeNotifier {
  Command<void> createTransactionCommand;
  Command<void> loadTransactionsCommand;
  Command<void> loadMoreCommand;
  List<Transaction> transactions;
  PaginationMetadata? pagination;
  TransactionType? filter;
  bool get hasMore;
  bool get isLoading;
}
```

## Data Models

### API Models

**UserApi**:
```dart
@freezed
class UserApi with _$UserApi {
  const factory UserApi({
    required String id,
    required String name,
    required String email,
    required String status,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserApi;
  
  factory UserApi.fromJson(Map<String, dynamic> json) => _$UserApiFromJson(json);
}
```

**LoginResponse**:
```dart
@freezed
class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    required String token,
    required UserApi user,
  }) = _LoginResponse;
  
  factory LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);
}
```

**RegisterRequest**:
```dart
@freezed
class RegisterRequest with _$RegisterRequest {
  const factory RegisterRequest({
    required String name,
    required String email,
    required String password,
  }) = _RegisterRequest;
  
  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}
```

**LoginRequest**:
```dart
@freezed
class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    required String email,
    required String password,
  }) = _LoginRequest;
  
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}
```

**CategoryApi**:
```dart
@freezed
class CategoryApi with _$CategoryApi {
  const factory CategoryApi({
    required String id,
    required String userId,
    required String description,
    String? icon,
    required bool isDefault,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CategoryApi;
  
  factory CategoryApi.fromJson(Map<String, dynamic> json) => _$CategoryApiFromJson(json);
}
```

**CreateCategoryRequest**:
```dart
@freezed
class CreateCategoryRequest with _$CreateCategoryRequest {
  const factory CreateCategoryRequest({
    required String description,
    String? icon,
  }) = _CreateCategoryRequest;
  
  Map<String, dynamic> toJson() => _$CreateCategoryRequestToJson(this);
}
```

**UpdateCategoryRequest**:
```dart
@freezed
class UpdateCategoryRequest with _$UpdateCategoryRequest {
  const factory UpdateCategoryRequest({
    required String description,
    String? icon,
  }) = _UpdateCategoryRequest;
  
  Map<String, dynamic> toJson() => _$UpdateCategoryRequestToJson(this);
}
```

**TransactionApi**:
```dart
@freezed
class TransactionApi with _$TransactionApi {
  const factory TransactionApi({
    required String id,
    required String userId,
    String? categoryId,
    required double amount,
    String? description,
    required String transactionType,
    required String paymentType,
    required DateTime transactionDate,
    required DateTime createdAt,
  }) = _TransactionApi;
  
  factory TransactionApi.fromJson(Map<String, dynamic> json) => _$TransactionApiFromJson(json);
}
```

**CreateTransactionRequest**:
```dart
@freezed
class CreateTransactionRequest with _$CreateTransactionRequest {
  const factory CreateTransactionRequest({
    String? categoryId,
    required double amount,
    String? description,
    required String transactionType,
    required String paymentType,
    required DateTime transactionDate,
  }) = _CreateTransactionRequest;
  
  Map<String, dynamic> toJson() => _$CreateTransactionRequestToJson(this);
}
```

**TransactionsResponse**:
```dart
@freezed
class TransactionsResponse with _$TransactionsResponse {
  const factory TransactionsResponse({
    required List<TransactionApi> transactions,
    required PaginationMetadata pagination,
  }) = _TransactionsResponse;
  
  factory TransactionsResponse.fromJson(Map<String, dynamic> json) => _$TransactionsResponseFromJson(json);
}
```

**PaginationMetadata**:
```dart
@freezed
class PaginationMetadata with _$PaginationMetadata {
  const factory PaginationMetadata({
    required int page,
    required int pageSize,
    required int total,
    required int totalPages,
    required bool hasNext,
    required bool hasPrevious,
  }) = _PaginationMetadata;
  
  factory PaginationMetadata.fromJson(Map<String, dynamic> json) => _$PaginationMetadataFromJson(json);
}
```

### Domain Models

**User**:
```dart
@freezed
class User with _$User {
  const factory User({
    required String id,
    required String name,
    required String email,
    required UserStatus status,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _User;
}

enum UserStatus { active, inactive }
```

**Category**:
```dart
@freezed
class Category with _$Category {
  const factory Category({
    required String id,
    required String userId,
    required String description,
    String? icon,
    required bool isDefault,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Category;
}
```

**Transaction**:
```dart
@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    required String id,
    required String userId,
    String? categoryId,
    required double amount,
    String? description,
    required TransactionType transactionType,
    required PaymentType paymentType,
    required DateTime transactionDate,
    required DateTime createdAt,
  }) = _Transaction;
}

enum TransactionType { income, expense }
enum PaymentType { creditCard, debitCard, pix, money }
```



### Mappers

Mappers convert between API models and domain models:

```dart
class UserMapper {
  static User toDomain(UserApi api);
  static UserApi toApi(User domain);
}

class CategoryMapper {
  static Category toDomain(CategoryApi api);
  static CategoryApi toApi(Category domain);
}

class TransactionMapper {
  static Transaction toDomain(TransactionApi api);
  static TransactionApi toApi(Transaction domain);
  static CreateTransactionRequest toCreateRequest(Transaction transaction);
}
```

## Correctness Properties

*A property is a characteristic or behavior that should hold true across all valid executions of a system-essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees.*

### Property 1: Valid registration creates user account

*For any* valid user data (name ≥ 3 chars, valid email format, password ≥ 6 chars), registration should succeed and return user details with matching name and email.

**Validates: Requirements 1.1**

### Property 2: Invalid registration data is rejected before API call

*For any* invalid user data (name < 3 chars, invalid email, or password < 6 chars), the validation should prevent the API call and return a validation error.

**Validates: Requirements 1.3**

### Property 3: Successful registration stores user data

*For any* successful registration, the user information should be available after the operation completes.

**Validates: Requirements 1.4**

### Property 4: Valid login returns JWT token

*For any* valid credentials, login should succeed and return a non-empty JWT token.

**Validates: Requirements 2.1**

### Property 5: Successful login persists token

*For any* successful login, the JWT token should be stored and retrievable from secure storage.

**Validates: Requirements 2.3**

### Property 6: Stored token enables auto-login

*For any* valid stored token, app launch should automatically authenticate the user without requiring login.

**Validates: Requirements 2.5**

### Property 7: Authenticated requests fetch profile data

*For any* authenticated user with valid token, profile request should return user information matching the authenticated user.

**Validates: Requirements 3.1**

### Property 8: Loading state is shown during async operations

*For any* async operation (profile fetch, category load, transaction load), the loading state should be true during execution and false after completion.

**Validates: Requirements 3.4, 4.2, 9.5, 11.4**

### Property 9: Category fetch returns all categories

*For any* authenticated user, fetching categories should return a list containing both default and custom categories.

**Validates: Requirements 4.1**

### Property 10: UI reactively reflects data changes

*For any* data change (category added, transaction created, list updated), notifyListeners should be called and observers should be notified.

**Validates: Requirements 4.5, 5.4, 6.4, 7.3, 8.7, 9.8**

### Property 11: Valid category creation adds to list

*For any* valid category (description ≥ 3 chars), creation should succeed and the category should appear in the category list.

**Validates: Requirements 5.1**

### Property 12: Optional icon is included when provided

*For any* category creation with an icon, the created category should contain the provided icon.

**Validates: Requirements 5.2**

### Property 13: Short category descriptions are rejected

*For any* category description with less than 3 characters, validation should prevent the API call.

**Validates: Requirements 5.3**

### Property 14: Category updates are applied

*For any* valid category update by the owner, the update should succeed and the category list should reflect the changes.

**Validates: Requirements 6.1**

### Property 15: Invalid updates are prevented

*For any* invalid category data, validation should prevent the API call and return validation errors.

**Validates: Requirements 6.5**

### Property 16: Category deletion removes from list

*For any* category deletion by the owner, the category should be removed from the category list.

**Validates: Requirements 7.1**

### Property 17: Valid transaction creation succeeds

*For any* valid transaction data (amount > 0, valid type, valid payment type, valid date), creation should succeed.

**Validates: Requirements 8.1**

### Property 18: Zero or negative amounts are rejected

*For any* transaction with amount ≤ 0, validation should prevent the API call.

**Validates: Requirements 8.2**

### Property 19: Invalid transaction types are rejected

*For any* transaction_type not in {income, expense}, validation should prevent the API call.

**Validates: Requirements 8.3**

### Property 20: Invalid payment types are rejected

*For any* payment_type not in {credit_card, debit_card, pix, money}, validation should prevent the API call.

**Validates: Requirements 8.4**

### Property 21: Dates are formatted to ISO 8601

*For any* transaction date, the system should format it to ISO 8601 before sending to the API.

**Validates: Requirements 8.5**

### Property 22: Null category_id is allowed

*For any* transaction with null category_id, creation should succeed (category is optional).

**Validates: Requirements 8.6**

### Property 23: Pagination loads next page when available

*For any* transaction list where has_next is true, scrolling to the end should trigger loading the next page.

**Validates: Requirements 9.2**

### Property 24: Filters are applied to API requests

*For any* transaction type filter (income/expense), the API request should include the filter parameter.

**Validates: Requirements 9.3**

### Property 25: No loading when no more pages

*For any* transaction list where has_next is false, no additional API requests should be made.

**Validates: Requirements 9.4**

### Property 26: Authenticated requests include Bearer token

*For any* authenticated API request, the Authorization header should contain "Bearer {token}".

**Validates: Requirements 10.5, 12.2**

### Property 27: Theme changes are reflected in UI

*For any* theme change (light/dark), the UI should update to reflect the new theme.

**Validates: Requirements 11.2**

### Property 28: Error states display with recovery options

*For any* error occurrence, the UI should display an error message with a retry or recovery option.

**Validates: Requirements 11.5**

### Property 29: Validation feedback is displayed

*For any* form validation error, the UI should display clear feedback indicating the validation issue.

**Validates: Requirements 11.7**

### Property 30: Token is stored securely after login

*For any* successful login, the JWT token should be stored using flutter_secure_storage.

**Validates: Requirements 12.1**

### Property 31: Logout clears stored token

*For any* logout operation, the stored token should be removed from secure storage.

**Validates: Requirements 12.4**

### Property 32: App restart retrieves stored token

*For any* app restart with a stored token, the token should be retrieved and available for authentication.

**Validates: Requirements 12.5**

## Error Handling

### Error Types

**1. Network Errors**
- Connection timeout
- No internet connection
- Server unreachable

**2. HTTP Errors**
- 400 Bad Request: Invalid data
- 401 Unauthorized: Invalid/expired token
- 403 Forbidden: Insufficient permissions
- 404 Not Found: Resource doesn't exist
- 500 Internal Server Error: Server error

**3. Validation Errors**
- Client-side validation failures
- Format errors
- Required field missing

### Error Handling Strategy

**Repository Layer**:
- Catch exceptions from API client
- Convert to Result<T> type (Ok or Error)
- Map HTTP status codes to meaningful error messages

**ViewModel Layer**:
- Handle Result<T> from repositories
- Update error state
- Notify listeners

**UI Layer**:
- Display error messages using SnackBar or AlertDialog
- Provide retry buttons for recoverable errors
- Show empty states for no data scenarios

**Special Cases**:
- 401 errors: Clear token, navigate to login
- Network errors: Show retry option
- Validation errors: Show inline form errors

### Error Message Mapping

```dart
class ErrorMapper {
  static String mapHttpError(int statusCode, String? message) {
    switch (statusCode) {
      case 400: return message ?? 'Dados inválidos';
      case 401: return 'Sessão expirada. Faça login novamente';
      case 403: return 'Você não tem permissão para esta ação';
      case 404: return 'Recurso não encontrado';
      case 500: return 'Erro no servidor. Tente novamente mais tarde';
      default: return 'Erro desconhecido';
    }
  }
  
  static String mapNetworkError(Exception e) {
    if (e is TimeoutException) return 'Tempo esgotado. Verifique sua conexão';
    if (e is SocketException) return 'Sem conexão com a internet';
    return 'Erro de rede. Tente novamente';
  }
}
```

## Testing Strategy

### Unit Testing

Unit tests will verify specific examples and edge cases:

**Auth Tests**:
- Test registration with valid data
- Test login with valid credentials
- Test token storage and retrieval
- Test logout clears token

**Category Tests**:
- Test category creation with valid data
- Test category update
- Test category deletion
- Test empty category list handling

**Transaction Tests**:
- Test transaction creation with valid data
- Test pagination with different page sizes
- Test filtering by transaction type
- Test null category_id handling

**Validation Tests**:
- Test email format validation
- Test password length validation
- Test amount validation (positive numbers)
- Test enum validation (transaction type, payment type)

**Mapper Tests**:
- Test API model to domain conversion
- Test domain to API model conversion
- Test date formatting to ISO 8601

### Property-Based Testing

Property-based tests will verify universal properties across all inputs using the **fast_check** library for Dart (or **test** package with custom generators).

**Configuration**:
- Minimum 100 iterations per property test
- Each test tagged with: `**Feature: api-integration, Property {number}: {property_text}**`

**Test Categories**:

1. **Validation Properties** (Properties 2, 13, 15, 18, 19, 20):
   - Generate random invalid inputs
   - Verify validation catches all invalid cases

2. **Data Integrity Properties** (Properties 1, 3, 5, 11, 14, 16, 17, 22):
   - Generate random valid data
   - Verify operations succeed and data is preserved

3. **Reactive Update Properties** (Property 10):
   - Generate random state changes
   - Verify notifyListeners is called

4. **Pagination Properties** (Properties 23, 24, 25):
   - Generate random pagination states
   - Verify correct loading behavior

5. **Authentication Properties** (Properties 4, 6, 26, 30, 31, 32):
   - Generate random tokens and credentials
   - Verify token handling is correct

6. **Format Properties** (Property 21):
   - Generate random dates
   - Verify ISO 8601 output format

7. **UI Properties** (Properties 8, 27, 28, 29):
   - Generate random UI states
   - Verify correct UI behavior

### Integration Testing

Integration tests will verify end-to-end flows:
- Complete registration → login → create category → create transaction flow
- Token expiration and re-authentication flow
- Pagination with multiple pages
- Error recovery flows

### Test Utilities

**Mock API Client**:
```dart
class MockApiClient extends Mock implements ApiClient {}
```

**Test Data Generators**:
```dart
class TestDataGenerator {
  static User randomUser();
  static Category randomCategory();
  static Transaction randomTransaction();
  static String randomEmail();
  static String randomPassword({int minLength = 6});
}
```

**Property Test Generators**:
```dart
class PropertyGenerators {
  static Arbitrary<String> validEmail();
  static Arbitrary<String> invalidEmail();
  static Arbitrary<String> validPassword();
  static Arbitrary<String> invalidPassword();
  static Arbitrary<double> positiveAmount();
  static Arbitrary<double> invalidAmount();
  static Arbitrary<TransactionType> transactionType();
  static Arbitrary<PaymentType> paymentType();
}
```

## UI Design Guidelines

### Material 3 Implementation

**Theme Configuration**:
- Use Material 3 color schemes
- Define light and dark themes
- Use ColorScheme.fromSeed for consistent colors
- Apply theme to MaterialApp

**Component Usage**:
- Use Material 3 components (Card, FilledButton, OutlinedButton)
- Apply elevation and shadows per Material 3 specs
- Use proper spacing (8dp grid system)
- Implement proper touch targets (minimum 48x48dp)

### Screen Designs

**1. Login Screen**:
- Email and password text fields
- Login button (FilledButton)
- Register link (TextButton)
- Loading indicator during authentication
- Error message display (SnackBar)

**2. Registration Screen**:
- Name, email, and password text fields
- Register button (FilledButton)
- Back to login link
- Validation feedback inline
- Loading indicator during registration

**3. Home/Dashboard Screen**:
- AppBar with user name and logout button
- Summary cards (total income, total expenses, balance)
- Quick action buttons (Add Transaction, Manage Categories)
- Recent transactions list
- Bottom navigation bar

**4. Categories Screen**:
- AppBar with "Categories" title
- List of categories with icons
- FloatingActionButton to add category
- Swipe actions for edit/delete
- Empty state when no categories
- Loading indicator
- Error state with retry button

**5. Transactions Screen**:
- AppBar with "Transactions" title and filter button
- Filter chips (All, Income, Expense)
- Paginated list of transactions
- Pull-to-refresh
- Load more indicator at bottom
- Empty state when no transactions
- FloatingActionButton to add transaction

**6. Add/Edit Transaction Screen**:
- Amount text field (numeric keyboard)
- Description text field
- Category dropdown
- Transaction type selector (Income/Expense)
- Payment type selector
- Date picker
- Save button
- Validation feedback

**7. Add/Edit Category Screen**:
- Description text field
- Icon picker (emoji or icon selector)
- Save button
- Validation feedback

### Reactive UI Pattern

All screens use ListenableBuilder for reactive updates:

```dart
ListenableBuilder(
  listenable: viewModel,
  builder: (context, child) {
    if (viewModel.isLoading) {
      return LoadingIndicator();
    }
    
    if (viewModel.error != null) {
      return ErrorView(
        message: viewModel.error!,
        onRetry: viewModel.retryCommand.execute,
      );
    }
    
    if (viewModel.data.isEmpty) {
      return EmptyStateView();
    }
    
    return DataView(data: viewModel.data);
  },
)
```

### Accessibility

- Semantic labels for all interactive elements
- Sufficient color contrast (WCAG AA)
- Support for screen readers
- Keyboard navigation support
- Scalable text (respect user font size settings)

### Animations

- Page transitions using go_router
- List item animations (fade in, slide)
- Loading shimmer effects
- Button press feedback
- Smooth scroll animations

## Dependencies

### New Dependencies to Add

```yaml
dependencies:
  # HTTP client
  http: ^1.2.2
  
  # Secure storage for tokens
  flutter_secure_storage: ^9.0.0
  
  # State management (already included)
  # ChangeNotifier is built into Flutter
  
  # Routing (already included)
  go_router: ^17.0.0
  
  # Dependency injection (already included)
  get_it: ^9.1.0
  injectable: ^2.6.0
  
  # Models (already included)
  freezed_annotation: ^3.1.0
  json_annotation: ^4.9.0

dev_dependencies:
  # Code generation (already included)
  build_runner: ^2.10.4
  freezed: ^3.2.3
  json_serializable: ^6.11.2
  injectable_generator: ^2.9.1
  
  # Testing
  mockito: ^5.4.4
  test: ^1.25.0
  
  # Property-based testing
  # Note: Dart doesn't have a mature PBT library like QuickCheck
  # We'll use the test package with custom generators
```

### Configuration

**API Base URL**:
- Development: `http://localhost:8080`
- Production: Configure via environment variables or build flavors

**Timeout Configuration**:
- Connection timeout: 30 seconds
- Receive timeout: 30 seconds

## Implementation Notes

### Token Management

1. On app launch, check for stored token
2. If token exists, validate by calling `/api/users/me`
3. If valid, navigate to home; if invalid, navigate to login
4. On login success, store token and set in API client
5. On logout, clear token and navigate to login
6. On 401 error, clear token and navigate to login

### Pagination Implementation

1. Initial load: Fetch page 1 with default page size (20)
2. Store pagination metadata (has_next, current_page, total_pages)
3. On scroll to bottom: Check has_next, if true, fetch next page
4. Append new items to existing list
5. Update pagination metadata
6. Prevent duplicate requests with loading flag

### State Management Pattern

```dart
class ExampleViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  List<Item> _items = [];
  
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Item> get items => _items;
  
  Future<void> loadItems() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    final result = await _repository.getItems();
    
    result.when(
      ok: (items) {
        _items = items;
        _isLoading = false;
        notifyListeners();
      },
      error: (error) {
        _error = error;
        _isLoading = false;
        notifyListeners();
      },
    );
  }
}
```

### Validation Strategy

Implement validation at multiple levels:

1. **UI Level**: Real-time validation as user types
2. **ViewModel Level**: Validation before API calls
3. **Repository Level**: Final validation before network request

Use a validation utility class:

```dart
class Validators {
  static String? validateEmail(String? value);
  static String? validatePassword(String? value);
  static String? validateName(String? value);
  static String? validateAmount(double? value);
  static String? validateDescription(String? value, {int minLength = 3});
}
```

### Mapper Pattern

Keep API models and domain models separate:

- API models: Match API structure exactly, use snake_case for JSON keys
- Domain models: Use Dart conventions, camelCase
- Mappers: Handle conversion and any data transformation

This separation allows:
- API changes don't affect domain logic
- Domain models can have computed properties
- Easier testing with domain models

### Error Recovery

Implement retry mechanisms:

1. Network errors: Automatic retry with exponential backoff (optional)
2. User-initiated retry: Retry button in error states
3. Token expiration: Automatic redirect to login
4. Validation errors: Show inline feedback, no retry needed

### Performance Considerations

1. **Pagination**: Load data in chunks to avoid large payloads
2. **Caching**: Consider caching categories (rarely change)
3. **Debouncing**: Debounce search/filter inputs
4. **Lazy Loading**: Load images and heavy widgets lazily
5. **List Optimization**: Use ListView.builder for large lists

## Migration Strategy

Since the app currently uses Firebase AI for expense extraction, the migration will:

1. **Keep Firebase AI**: Continue using Firebase AI for receipt scanning
2. **Add API Integration**: Add new API-based features alongside Firebase
3. **Gradual Migration**: Move features to API incrementally
4. **Dual Mode**: Support both Firebase and API modes during transition

The Firebase AI service will call the API to:
- Fetch user categories for AI context
- Create transactions after AI extraction
- Sync data between Firebase and API

This hybrid approach allows:
- Leveraging existing Firebase AI investment
- Adding robust backend with API
- Smooth transition without breaking existing features
