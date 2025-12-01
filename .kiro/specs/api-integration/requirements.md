# Requirements Document

## Introduction

This specification defines the integration of the Flutter expense tracking application with a REST API backend. The integration will replace the current Firebase-only approach with a comprehensive API-based architecture that handles user authentication, category management, and transaction tracking. The system will follow Flutter's official architecture recommendations, implementing a clean separation between data, domain, and application layers with reactive state management using ChangeNotifier and ListenableBuilder.

## Glossary

- **API Client**: HTTP client component responsible for making network requests to the backend API
- **Repository**: Data layer component that abstracts data sources and provides a clean API to the application layer
- **DTO (Data Transfer Object)**: Model representing data structure received from or sent to the API
- **Domain Model**: Application-level model representing business entities
- **Bearer Token**: JWT authentication token included in request headers for protected endpoints
- **ChangeNotifier**: Flutter's built-in class for implementing observable state
- **ListenableBuilder**: Flutter widget that rebuilds when a Listenable (like ChangeNotifier) changes
- **Transaction**: Financial record representing income or expense
- **Category**: Classification for organizing transactions
- **Pagination**: Technique for dividing large datasets into pages

## Requirements

### Requirement 1

**User Story:** As a user, I want to register a new account in the system, so that I can access the expense tracking features.

#### Acceptance Criteria

1. WHEN a user provides valid name, email, and password THEN the system SHALL create a new user account and return user details
2. WHEN a user attempts to register with an existing email THEN the system SHALL reject the registration and display an appropriate error message
3. WHEN a user provides invalid data (name < 3 chars, invalid email, password < 6 chars) THEN the system SHALL validate input and prevent the API call
4. WHEN registration is successful THEN the system SHALL store user information and navigate to the login screen
5. WHEN network errors occur during registration THEN the system SHALL handle the error gracefully and inform the user

### Requirement 2

**User Story:** As a user, I want to log into my account, so that I can access my personal expense data securely.

#### Acceptance Criteria

1. WHEN a user provides valid email and password THEN the system SHALL authenticate the user and return a JWT token
2. WHEN a user provides invalid credentials THEN the system SHALL reject the login and display an error message
3. WHEN login is successful THEN the system SHALL store the JWT token securely for subsequent requests
4. WHEN login is successful THEN the system SHALL navigate to the home screen
5. WHEN the stored token exists on app launch THEN the system SHALL validate the token and auto-login the user

### Requirement 3

**User Story:** As an authenticated user, I want to view my profile information, so that I can verify my account details.

#### Acceptance Criteria

1. WHEN an authenticated user requests profile data THEN the system SHALL fetch and display user information from the API
2. WHEN the authentication token is invalid or expired THEN the system SHALL handle the 401 error and redirect to login
3. WHEN network errors occur THEN the system SHALL display an appropriate error state
4. WHEN profile data is loading THEN the system SHALL display a loading indicator

### Requirement 4

**User Story:** As an authenticated user, I want to view all my expense categories, so that I can organize my transactions effectively.

#### Acceptance Criteria

1. WHEN an authenticated user requests categories THEN the system SHALL fetch and display all categories (default and custom)
2. WHEN categories are loading THEN the system SHALL display a loading indicator
3. WHEN no categories exist THEN the system SHALL display an empty state
4. WHEN network errors occur THEN the system SHALL display an error state with retry option
5. WHEN the category list updates THEN the UI SHALL reactively reflect the changes using ListenableBuilder

### Requirement 5

**User Story:** As an authenticated user, I want to create custom expense categories, so that I can personalize my expense tracking.

#### Acceptance Criteria

1. WHEN a user provides a valid category description THEN the system SHALL create the category and add it to the list
2. WHEN a user provides an optional icon THEN the system SHALL include the icon in the category
3. WHEN category description is less than 3 characters THEN the system SHALL validate and prevent the API call
4. WHEN category creation is successful THEN the system SHALL update the category list reactively
5. WHEN network errors occur THEN the system SHALL handle the error and inform the user

### Requirement 6

**User Story:** As an authenticated user, I want to edit my custom categories, so that I can keep my organization system up to date.

#### Acceptance Criteria

1. WHEN a user updates a category they own THEN the system SHALL send the update to the API and refresh the list
2. WHEN a user attempts to edit a category they don't own THEN the system SHALL handle the 403 error appropriately
3. WHEN a category doesn't exist THEN the system SHALL handle the 404 error appropriately
4. WHEN the update is successful THEN the system SHALL reactively update the UI
5. WHEN validation fails THEN the system SHALL prevent the API call and show validation errors

### Requirement 7

**User Story:** As an authenticated user, I want to delete custom categories, so that I can remove categories I no longer need.

#### Acceptance Criteria

1. WHEN a user deletes a category they own THEN the system SHALL remove it from the API and update the list
2. WHEN a user attempts to delete a category they don't own THEN the system SHALL handle the 403 error appropriately
3. WHEN a category is successfully deleted THEN the system SHALL remove it from the UI reactively
4. WHEN a deleted category has associated transactions THEN the system SHALL handle the cascade behavior (category_id becomes null)
5. WHEN network errors occur THEN the system SHALL handle the error and inform the user

### Requirement 8

**User Story:** As an authenticated user, I want to create new transactions, so that I can track my income and expenses.

#### Acceptance Criteria

1. WHEN a user provides valid transaction data THEN the system SHALL create the transaction via the API
2. WHEN amount is zero or negative THEN the system SHALL validate and prevent the API call
3. WHEN transaction_type is not "income" or "expense" THEN the system SHALL validate and prevent the API call
4. WHEN payment_type is not one of the valid options (credit_card, debit_card, pix, money) THEN the system SHALL validate and prevent the API call
5. WHEN transaction_date is not in ISO 8601 format THEN the system SHALL format it correctly before sending
6. WHEN category_id is null THEN the system SHALL allow the transaction creation (category is optional)
7. WHEN transaction creation is successful THEN the system SHALL update the transaction list reactively
8. WHEN network errors occur THEN the system SHALL handle the error and inform the user

### Requirement 9

**User Story:** As an authenticated user, I want to view my transactions with pagination, so that I can browse through my financial history efficiently.

#### Acceptance Criteria

1. WHEN a user requests transactions THEN the system SHALL fetch paginated data from the API with default page size of 20
2. WHEN a user scrolls to the end of the list THEN the system SHALL load the next page if available
3. WHEN a user filters by transaction type (income/expense) THEN the system SHALL apply the filter and fetch filtered results
4. WHEN pagination metadata indicates no more pages THEN the system SHALL not attempt to load additional data
5. WHEN transactions are loading THEN the system SHALL display a loading indicator
6. WHEN no transactions exist THEN the system SHALL display an empty state
7. WHEN network errors occur THEN the system SHALL display an error state with retry option
8. WHEN the transaction list updates THEN the UI SHALL reactively reflect changes using ListenableBuilder

### Requirement 10

**User Story:** As a developer, I want a clean architecture implementation, so that the codebase is maintainable, testable, and follows Flutter best practices.

#### Acceptance Criteria

1. WHEN implementing data layer THEN the system SHALL create separate API clients, DTOs, and repositories
2. WHEN implementing domain layer THEN the system SHALL define domain models separate from DTOs
3. WHEN implementing application layer THEN the system SHALL use ChangeNotifier for state management
4. WHEN implementing UI layer THEN the system SHALL use ListenableBuilder for reactive updates
5. WHEN handling authentication THEN the system SHALL implement token storage and automatic header injection
6. WHEN handling errors THEN the system SHALL implement proper error types and user-friendly messages
7. WHEN making API calls THEN the system SHALL handle timeouts and network failures gracefully

### Requirement 11

**User Story:** As a user, I want a modern and intuitive interface following Material 3 design, so that I have a pleasant experience using the app.

#### Acceptance Criteria

1. WHEN viewing any screen THEN the system SHALL follow Material 3 design guidelines
2. WHEN the system theme changes THEN the UI SHALL support both light and dark modes
3. WHEN navigating between screens THEN the system SHALL provide smooth transitions
4. WHEN loading data THEN the system SHALL display appropriate loading states
5. WHEN errors occur THEN the system SHALL display user-friendly error messages with recovery options
6. WHEN displaying lists THEN the system SHALL implement smooth scrolling and proper item spacing
7. WHEN interacting with forms THEN the system SHALL provide clear validation feedback

### Requirement 12

**User Story:** As a user, I want secure token management, so that my authentication remains valid and secure across app sessions.

#### Acceptance Criteria

1. WHEN a user logs in successfully THEN the system SHALL store the JWT token securely using flutter_secure_storage
2. WHEN making authenticated requests THEN the system SHALL automatically include the Bearer token in headers
3. WHEN a token expires (401 error) THEN the system SHALL clear the token and redirect to login
4. WHEN a user logs out THEN the system SHALL clear the stored token
5. WHEN the app restarts THEN the system SHALL retrieve the stored token and validate it
