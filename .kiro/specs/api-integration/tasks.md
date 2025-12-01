# Implementation Plan

## Architecture Notes

This implementation follows Flutter's official architecture guidelines (https://docs.flutter.dev/app-architecture):

- **Service Layer**: Wraps external APIs, returns `Future<Result<T>>` with API models
- **Repository Layer**: Transforms API models to domain models, manages data, returns `Result<DomainModel>`
- **ViewModel Layer**: Validates user input, manages UI state, calls repositories
- **UI Layer**: Displays data, captures user input, observes ViewModels

**Important**: Input validation is done in the ViewModel layer, NOT in Repository or Service layers.

---

- [x] 1. Setup project dependencies and base infrastructure
  - Add new dependencies to pubspec.yaml (flutter_secure_storage, http)
  - Configure dependency injection for new services
  - Create base folder structure (data/api, data/models, data/repositories, domain/models, domain/mappers)
  - _Requirements: 10.1, 10.2_

- [x] 2. Implement token storage service
  - Create TokenStorageService using flutter_secure_storage
  - Implement saveToken, getToken, deleteToken, hasToken methods
  - _Requirements: 12.1, 12.4, 12.5_

- [x] 2.1 Write property test for token storage
  - **Property 30: Token is stored securely after login**
  - **Property 31: Logout clears stored token**
  - **Property 32: App restart retrieves stored token**
  - **Validates: Requirements 12.1, 12.4, 12.5**

- [x] 3. Implement API client with authentication
  - Create ApiClient class with http package
  - Configure base URL, timeouts, and headers
  - Implement request methods (get, post, put, delete)
  - Add automatic Bearer token injection via interceptor
  - Handle HTTP errors and map to meaningful exceptions
  - _Requirements: 10.5, 10.7, 12.2_

- [x] 3.1 Write property test for authenticated requests
  - **Property 26: Authenticated requests include Bearer token**
  - **Validates: Requirements 10.5, 12.2**

- [x] 3.2 Write unit tests for API client
  - Test request methods with different HTTP verbs
  - Test error handling for network failures
  - Test timeout handling
  - _Requirements: 10.7_

- [x] 4. Create API models and request/response classes
  - Create UserApi model with freezed and json_serializable
  - Create LoginRequest, RegisterRequest, LoginResponse models
  - Create CategoryApi, CreateCategoryRequest, UpdateCategoryRequest models
  - Create TransactionApi, CreateTransactionRequest models
  - Create TransactionsResponse and PaginationMetadata models
  - Run build_runner to generate code
  - _Requirements: 1.1, 2.1, 4.1, 5.1, 8.1, 9.1_

- [x] 4.1 Write unit tests for model serialization
  - Test fromJson for all API models
  - Test toJson for all request models
  - Test date parsing and formatting
  - _Requirements: 8.5_

- [x] 5. Create domain models
  - Create User domain model with UserStatus enum
  - Create Category domain model
  - Create Transaction domain model with TransactionType and PaymentType enums
  - _Requirements: 10.2_

- [x] 6. Implement mappers between API and domain models
  - Create UserMapper (toDomain, toApi)
  - Create CategoryMapper (toDomain, toApi)
  - Create TransactionMapper (toDomain, toApi, toCreateRequest)
  - Handle enum conversions (string to enum and vice versa)
  - Handle date formatting to ISO 8601
  - _Requirements: 8.5_

- [x] 6.1 Write property test for date formatting
  - **Property 21: Dates are formatted to ISO 8601**
  - **Validates: Requirements 8.5**

- [x] 6.2 Write unit tests for mappers
  - Test API to domain conversion for all models
  - Test domain to API conversion for all models
  - Test enum conversions
  - _Requirements: 10.2_

- [x] 7. Implement validation utilities
  - Create Validators class with static methods
  - Implement validateEmail (format check)
  - Implement validatePassword (min 6 chars)
  - Implement validateName (min 3 chars)
  - Implement validateAmount (must be > 0)
  - Implement validateDescription (min 3 chars)
  - Implement validateTransactionType (must be income or expense)
  - Implement validatePaymentType (must be valid enum value)
  - _Requirements: 1.3, 5.3, 6.5, 8.2, 8.3, 8.4_

- [x] 7.1 Write property test for validation
  - **Property 2: Invalid registration data is rejected (will be tested in ViewModel)**
  - **Property 13: Short category descriptions are rejected (will be tested in ViewModel)**
  - **Property 15: Invalid updates are prevented (will be tested in ViewModel)**
  - **Property 18: Zero or negative amounts are rejected (will be tested in ViewModel)**
  - **Property 19: Invalid transaction types are rejected (will be tested in ViewModel)**
  - **Property 20: Invalid payment types are rejected (will be tested in ViewModel)**
  - Note: Validators utility class tests basic validation logic
  - **Validates: Requirements 1.3, 5.3, 6.5, 8.2, 8.3, 8.4**

- [x] 8. Implement AuthRepository
  - Create AuthRepository with ApiService and TokenStorageService dependencies
  - Implement register method (call service, transform to domain model, return Result<User>)
  - Implement login method (call service, store token, return Result<LoginResponse>)
  - Implement getProfile method (call service, transform to domain model, return Result<User>)
  - Implement logout method (clear token, clear service token)
  - Implement isAuthenticated method (check if token exists)
  - Handle 401 errors by clearing token
  - Note: Input validation is done in ViewModel layer, not Repository
  - _Requirements: 1.1, 1.2, 1.3, 2.1, 2.2, 2.3, 3.1, 3.2, 12.3_

- [x] 8.1 Write property test for authentication
  - **Property 1: Valid registration creates user account**
  - **Property 4: Valid login returns JWT token**
  - **Property 5: Successful login persists token**
  - **Property 7: Authenticated requests fetch profile data**
  - **Validates: Requirements 1.1, 2.1, 2.3, 3.1**

- [x] 8.2 Write unit tests for AuthRepository
  - Test registration with valid data
  - Test registration with duplicate email (400 error)
  - Test login with valid credentials
  - Test login with invalid credentials (401 error)
  - Test getProfile with valid token
  - Test getProfile with expired token (401 error)
  - Test logout clears token
  - _Requirements: 1.2, 2.2, 3.2, 12.3_

- [x] 9. Implement CategoryRepository
  - Create CategoryRepository with ApiService dependency
  - Implement getCategories method (call service, transform to domain models, return Result<List<Category>>)
  - Implement createCategory method (call service, transform to domain model, return Result<Category>)
  - Implement updateCategory method (call service, transform to domain model, return Result<Category>)
  - Implement deleteCategory method (call service, return Result<void>)
  - Handle 403 (permission denied) and 404 (not found) errors
  - Note: Input validation is done in ViewModel layer, not Repository
  - _Requirements: 4.1, 5.1, 5.3, 6.1, 6.2, 6.3, 7.1, 7.2_

- [x] 9.1 Write property test for category operations
  - **Property 9: Category fetch returns all categories**
  - **Property 11: Valid category creation adds to list**
  - **Property 12: Optional icon is included when provided**
  - **Property 14: Category updates are applied**
  - **Property 16: Category deletion removes from list**
  - **Property 22: Null category_id is allowed**
  - **Validates: Requirements 4.1, 5.1, 5.2, 6.1, 7.1, 8.6**

- [x] 9.2 Write unit tests for CategoryRepository
  - Test getCategories returns all categories
  - Test createCategory with valid data
  - Test createCategory with API error (400)
  - Test updateCategory with valid data
  - Test updateCategory with permission error (403)
  - Test deleteCategory with valid id
  - Test deleteCategory with not found error (404)
  - Note: Validation tests will be in ViewModel tests
  - _Requirements: 4.1, 5.3, 6.2, 6.3, 7.2_

- [ ] 10. Implement TransactionRepository
  - Create TransactionRepository with ApiService dependency
  - Implement createTransaction method (call service, transform to domain model, return Result<Transaction>)
  - Implement getTransactions method with pagination (call service, transform to domain models, return Result<TransactionsResponse>)
  - Handle pagination parameters (page, pageSize, type filter)
  - Note: Input validation and date formatting done in ViewModel layer
  - _Requirements: 8.1, 8.2, 8.3, 8.4, 8.5, 8.6, 9.1, 9.3_

- [ ] 10.1 Write property test for transaction operations
  - **Property 17: Valid transaction creation succeeds**
  - **Property 23: Pagination loads next page when available**
  - **Property 24: Filters are applied to API requests**
  - **Property 25: No loading when no more pages**
  - **Validates: Requirements 8.1, 9.2, 9.3, 9.4**

- [ ] 10.2 Write unit tests for TransactionRepository
  - Test createTransaction with valid data
  - Test createTransaction with API error (400)
  - Test createTransaction with null category_id
  - Test getTransactions with default pagination
  - Test getTransactions with custom page size
  - Test getTransactions with type filter
  - Note: Validation tests will be in ViewModel tests
  - _Requirements: 8.2, 8.3, 8.6, 9.1, 9.3_

- [ ] 11. Checkpoint - Ensure all repository tests pass
  - Ensure all tests pass, ask the user if questions arise.

- [ ] 12. Implement AuthViewModel
  - Create AuthViewModel extending ChangeNotifier
  - Add currentUser property
  - Add isAuthenticated getter
  - Implement registerCommand using Command pattern with input validation
  - Implement loginCommand using Command pattern with input validation
  - Implement logoutCommand using Command pattern
  - Call notifyListeners after state changes
  - Handle errors and update error state
  - Validate user input (name, email, password) before calling repository
  - _Requirements: 1.3, 1.4, 2.4, 10.3_

- [ ] 12.1 Write property test for AuthViewModel
  - **Property 3: Successful registration stores user data**
  - **Property 6: Stored token enables auto-login**
  - **Property 10: UI reactively reflects data changes**
  - **Validates: Requirements 1.4, 2.5, 4.5**

- [ ] 12.2 Write unit tests for AuthViewModel
  - Test register command validates input before calling repository
  - Test register command with invalid data shows validation errors
  - Test register command with valid data updates currentUser
  - Test login command validates input before calling repository
  - Test login command with invalid data shows validation errors
  - Test login command updates currentUser and isAuthenticated
  - Test logout command clears currentUser
  - Test notifyListeners is called after state changes
  - _Requirements: 1.4, 2.4_

- [ ] 13. Implement CategoryViewModel
  - Create CategoryViewModel extending ChangeNotifier
  - Add categories list property
  - Add isLoading and error properties
  - Implement loadCategoriesCommand using Command pattern
  - Implement createCategoryCommand using Command pattern
  - Implement updateCategoryCommand using Command pattern
  - Implement deleteCategoryCommand using Command pattern
  - Call notifyListeners after state changes
  - Handle loading and error states
  - _Requirements: 4.2, 4.4, 4.5, 5.4, 6.4, 7.3_

- [ ] 13.1 Write property test for CategoryViewModel
  - **Property 8: Loading state is shown during async operations**
  - **Property 10: UI reactively reflects data changes**
  - **Validates: Requirements 4.2, 4.5, 5.4, 6.4, 7.3**

- [ ] 13.2 Write unit tests for CategoryViewModel
  - Test loadCategories updates categories list
  - Test createCategory adds to categories list
  - Test updateCategory modifies category in list
  - Test deleteCategory removes from list
  - Test loading state during operations
  - Test error state on failures
  - Test notifyListeners is called
  - _Requirements: 4.2, 4.4, 5.4, 6.4, 7.3_

- [ ] 14. Implement TransactionViewModel
  - Create TransactionViewModel extending ChangeNotifier
  - Add transactions list property
  - Add pagination metadata property
  - Add filter property (TransactionType?)
  - Add isLoading and error properties
  - Add hasMore getter (based on pagination.hasNext)
  - Implement createTransactionCommand using Command pattern
  - Implement loadTransactionsCommand using Command pattern
  - Implement loadMoreCommand for pagination
  - Implement setFilter method to change filter
  - Call notifyListeners after state changes
  - Handle loading and error states
  - _Requirements: 8.7, 9.2, 9.4, 9.5, 9.8_

- [ ] 14.1 Write property test for TransactionViewModel
  - **Property 8: Loading state is shown during async operations**
  - **Property 10: UI reactively reflects data changes**
  - **Validates: Requirements 8.7, 9.5, 9.8**

- [ ] 14.2 Write unit tests for TransactionViewModel
  - Test createTransaction adds to list
  - Test loadTransactions populates list
  - Test loadMore appends to list
  - Test setFilter reloads with filter
  - Test hasMore based on pagination
  - Test loading state during operations
  - Test notifyListeners is called
  - _Requirements: 8.7, 9.2, 9.4, 9.5, 9.8_

- [ ] 15. Checkpoint - Ensure all ViewModel tests pass
  - Ensure all tests pass, ask the user if questions arise.

- [ ] 16. Configure dependency injection
  - Register TokenStorageService as singleton in GetIt
  - Register ApiService as singleton in GetIt
  - Register AuthRepository as singleton in GetIt
  - Register CategoryRepository as singleton in GetIt
  - Register TransactionRepository as singleton in GetIt
  - Register AuthViewModel as factory in GetIt
  - Register CategoryViewModel as factory in GetIt
  - Register TransactionViewModel as factory in GetIt
  - Run build_runner to generate injectable code
  - _Requirements: 10.1_

- [ ] 17. Implement Material 3 theme configuration
  - Create ThemeProvider extending ChangeNotifier
  - Define light theme using ColorScheme.fromSeed
  - Define dark theme using ColorScheme.fromSeed
  - Configure Material 3 useMaterial3: true
  - Add theme toggle functionality
  - _Requirements: 11.1, 11.2_

- [ ] 17.1 Write property test for theme switching
  - **Property 27: Theme changes are reflected in UI**
  - **Validates: Requirements 11.2**

- [ ] 18. Create reusable UI components
  - Create LoadingIndicator widget (CircularProgressIndicator with Material 3 styling)
  - Create ErrorView widget with retry button
  - Create EmptyStateView widget with icon and message
  - Create CustomTextField widget with validation feedback
  - Create CustomButton widgets (FilledButton, OutlinedButton wrappers)
  - _Requirements: 11.4, 11.5, 11.7_

- [ ] 18.1 Write property test for error and validation UI
  - **Property 28: Error states display with recovery options**
  - **Property 29: Validation feedback is displayed**
  - **Validates: Requirements 11.5, 11.7**

- [ ] 19. Implement Login screen
  - Create LoginScreen widget
  - Add email and password TextFields with validation
  - Add login FilledButton
  - Add "Register" TextButton navigation
  - Use ListenableBuilder to observe AuthViewModel
  - Show loading indicator during login
  - Show error SnackBar on failure
  - Navigate to home on success
  - _Requirements: 2.1, 2.2, 2.4, 11.4, 11.5_

- [ ] 20. Implement Registration screen
  - Create RegisterScreen widget
  - Add name, email, and password TextFields with validation
  - Add register FilledButton
  - Add "Back to login" TextButton navigation
  - Use ListenableBuilder to observe AuthViewModel
  - Show loading indicator during registration
  - Show error SnackBar on failure
  - Navigate to login on success
  - _Requirements: 1.1, 1.2, 1.3, 1.4, 1.5, 11.4, 11.5, 11.7_

- [ ] 21. Implement auto-login on app launch
  - Update main.dart to check for stored token on launch
  - If token exists, call AuthRepository.getProfile()
  - If valid, navigate to home screen
  - If invalid (401), clear token and navigate to login
  - Show splash screen during check
  - _Requirements: 2.5, 3.2, 12.5_

- [ ] 22. Implement Home/Dashboard screen
  - Create HomeScreen widget
  - Add AppBar with user name and logout button
  - Add summary cards (placeholder for now)
  - Add quick action buttons (Add Transaction, Manage Categories)
  - Add recent transactions list (placeholder for now)
  - Add BottomNavigationBar with tabs
  - Use ListenableBuilder to observe AuthViewModel
  - _Requirements: 11.1, 11.3_

- [ ] 23. Implement Categories screen
  - Create CategoriesScreen widget
  - Add AppBar with "Categories" title
  - Use ListenableBuilder to observe CategoryViewModel
  - Display categories list with icons using ListView.builder
  - Add FloatingActionButton to create category
  - Implement swipe actions for edit/delete (Dismissible widget)
  - Show LoadingIndicator when loading
  - Show EmptyStateView when no categories
  - Show ErrorView with retry on error
  - _Requirements: 4.1, 4.2, 4.3, 4.4, 4.5, 11.4, 11.5, 11.6_

- [ ] 24. Implement Add/Edit Category dialog
  - Create CategoryDialog widget
  - Add description TextField with validation
  - Add icon TextField (emoji input)
  - Add save FilledButton
  - Show validation errors inline
  - Call CategoryViewModel.createCategory or updateCategory
  - Close dialog on success
  - _Requirements: 5.1, 5.2, 5.3, 5.5, 6.1, 6.5, 11.7_

- [ ] 25. Implement Transactions screen
  - Create TransactionsScreen widget
  - Add AppBar with "Transactions" title and filter button
  - Add filter chips (All, Income, Expense)
  - Use ListenableBuilder to observe TransactionViewModel
  - Display transactions list using ListView.builder
  - Implement pagination (load more on scroll to bottom)
  - Add FloatingActionButton to create transaction
  - Show LoadingIndicator when loading
  - Show EmptyStateView when no transactions
  - Show ErrorView with retry on error
  - Implement pull-to-refresh
  - _Requirements: 9.1, 9.2, 9.3, 9.4, 9.5, 9.6, 9.7, 9.8, 11.4, 11.5, 11.6_

- [ ] 26. Implement Add Transaction screen
  - Create AddTransactionScreen widget
  - Add amount TextField with numeric keyboard
  - Add description TextField
  - Add category dropdown (fetch from CategoryViewModel)
  - Add transaction type selector (SegmentedButton: Income/Expense)
  - Add payment type dropdown (credit_card, debit_card, pix, money)
  - Add date picker (DatePicker)
  - Add save FilledButton
  - Show validation errors inline
  - Call TransactionViewModel.createTransaction
  - Navigate back on success
  - _Requirements: 8.1, 8.2, 8.3, 8.4, 8.5, 8.6, 8.8, 11.7_

- [ ] 27. Configure routing with go_router
  - Define routes for all screens (login, register, home, categories, transactions, add-transaction)
  - Implement route guards (redirect to login if not authenticated)
  - Configure initial route based on authentication state
  - Add smooth page transitions
  - _Requirements: 11.3_

- [ ] 28. Implement logout functionality
  - Add logout button in AppBar
  - Call AuthViewModel.logout
  - Clear all ViewModels state
  - Navigate to login screen
  - _Requirements: 12.4_

- [ ] 29. Handle 401 errors globally
  - Add global error handler in ApiService
  - On 401 error, clear token and navigate to login
  - Show "Session expired" message
  - _Requirements: 3.2, 12.3_

- [ ] 30. Integrate with existing Firebase AI service
  - Update FirebaseAIService to fetch categories from CategoryRepository
  - Update FirebaseAIService to create transactions via TransactionRepository
  - Ensure AI-extracted data is validated before API calls
  - _Requirements: Migration Strategy_

- [ ] 31. Final checkpoint - End-to-end testing
  - Ensure all tests pass, ask the user if questions arise.
  - Test complete flow: register → login → create category → create transaction → view transactions
  - Test pagination with multiple pages
  - Test filtering transactions
  - Test error handling (network errors, validation errors)
  - Test theme switching
  - Test logout and re-login
  - Test auto-login on app restart

- [ ] 32. Polish UI and accessibility
  - Ensure all interactive elements have semantic labels
  - Verify color contrast meets WCAG AA standards
  - Test with screen reader
  - Ensure text scales properly
  - Add smooth animations for list items
  - Add loading shimmer effects
  - _Requirements: 11.1, 11.3, 11.6_
