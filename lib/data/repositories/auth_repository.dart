import 'package:firebase_ai_testing/data/services/api/api_service.dart';
import 'package:firebase_ai_testing/data/services/api/models/login_request/login_request.dart';
import 'package:firebase_ai_testing/data/services/api/models/login_response/login_response.dart';
import 'package:firebase_ai_testing/data/services/api/models/register_request/register_request.dart';
import 'package:firebase_ai_testing/data/services/token_storage_service.dart';
import 'package:firebase_ai_testing/domain/mappers/user_mapper.dart';
import 'package:firebase_ai_testing/domain/models/user.dart';
import 'package:firebase_ai_testing/utils/result.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

/// Repository for handling authentication operations
///
/// Source of truth for authentication state.
/// Extends ChangeNotifier to notify listeners of state changes.
/// Manages user registration, login, logout, and token management.
/// Handles token storage and automatic header injection via ApiService.
///
/// Note: User data management is handled by UserRepository.
@lazySingleton
class AuthRepository extends ChangeNotifier {
  AuthRepository(this._apiService, this._tokenStorage) {
    _setupAuthHeaderProvider();
  }

  final ApiService _apiService;
  final TokenStorageService _tokenStorage;

  bool? _isAuthenticated;
  String? _currentToken;

  /// Setup the auth header provider for ApiService
  void _setupAuthHeaderProvider() {
    _apiService.authHeaderProvider = () {
      if (_currentToken != null && _currentToken!.isNotEmpty) {
        return 'Bearer $_currentToken';
      }
      return null;
    };
  }

  /// Check if user is authenticated
  ///
  /// Returns cached status if available, otherwise fetches from storage.
  Future<bool> get isAuthenticated async {
    // Status is cached
    if (_isAuthenticated != null) {
      return _isAuthenticated!;
    }

    // No status cached, fetch from storage
    _isAuthenticated = await _tokenStorage.hasToken();
    return _isAuthenticated!;
  }

  /// Register a new user account
  ///
  /// Returns Result<User> with user data on success or error on failure.
  /// Note: Input validation should be done in the ViewModel/UI layer.
  Future<Result<User>> register(
    String name,
    String email,
    String password,
  ) async {
    // Create request
    final request = RegisterRequest(
      name: name,
      email: email,
      password: password,
    );

    // Call API service - returns Result<UserApi>
    final result = await _apiService.registerUser(request);

    // Transform Result<UserApi> to Result<User>
    return switch (result) {
      Ok(:final value) => Result.ok(UserMapper.toDomain(value)),
      Error(:final error) => Result.error(error),
    };
  }

  /// Login with email and password
  ///
  /// Calls API and stores token on success.
  /// Returns Result<LoginResponse> with token and user data.
  /// Note: Input validation should be done in the ViewModel/UI layer.
  Future<Result<LoginResponse>> login(String email, String password) async {
    // Create request
    final request = LoginRequest(
      email: email,
      password: password,
    );

    // Call API service - returns Result<LoginResponse>
    final result = await _apiService.loginUser(request);

    return switch (result) {
      Ok(:final value) => await _handleSuccessfulLogin(value),
      Error(:final error) => await _handleLoginError(error),
    };
  }

  /// Handle successful login by storing token
  Future<Result<LoginResponse>> _handleSuccessfulLogin(
    LoginResponse loginResponse,
  ) async {
    // Store token in secure storage
    await _tokenStorage.saveToken(loginResponse.token);

    // Update current token (used by authHeaderProvider)
    _currentToken = loginResponse.token;

    // Set auth status
    _isAuthenticated = true;

    // Notify listeners of state change
    notifyListeners();

    return Result.ok(loginResponse);
  }

  /// Handle login error, clearing token on 401
  Future<Result<LoginResponse>> _handleLoginError(Exception error) async {
    // Handle 401 errors by clearing token
    if (error is ApiException && error.statusCode == 401) {
      await _clearToken();
    }
    return Result.error(error);
  }

  /// Logout current user
  ///
  /// Clears stored token and API service token.
  Future<void> logout() async {
    await _clearToken();
  }

  /// Clear token from storage and memory
  Future<void> _clearToken() async {
    await _tokenStorage.deleteToken();

    // Clear current token (authHeaderProvider will return null)
    _currentToken = null;

    // Clear authenticated status
    _isAuthenticated = false;

    // Notify listeners of state change
    notifyListeners();
  }

  /// Load token from storage on app startup
  ///
  /// Should be called when the app starts to restore authentication state.
  /// Returns the stored token if available.
  Future<String?> loadStoredToken() async {
    final token = await _tokenStorage.getToken();
    if (token != null) {
      _currentToken = token;
      _isAuthenticated = true;
      notifyListeners();
    }
    return token;
  }
}
