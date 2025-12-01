import 'package:firebase_ai_testing/data/services/api/api_service.dart';
import 'package:firebase_ai_testing/data/services/api/models/login_request/login_request.dart';
import 'package:firebase_ai_testing/data/services/api/models/login_response/login_response.dart';
import 'package:firebase_ai_testing/data/services/api/models/register_request/register_request.dart';
import 'package:firebase_ai_testing/data/services/token_storage_service.dart';
import 'package:firebase_ai_testing/domain/mappers/user_mapper.dart';
import 'package:firebase_ai_testing/domain/models/user.dart';
import 'package:firebase_ai_testing/utils/result.dart';
import 'package:injectable/injectable.dart';

/// Repository for handling authentication operations
///
/// Manages user registration, login, profile fetching, and logout.
/// Handles token storage and automatic header injection via ApiService.
@lazySingleton
class AuthRepository {
  AuthRepository(this._apiService, this._tokenStorage);

  final ApiService _apiService;
  final TokenStorageService _tokenStorage;

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
    // Store token
    await _tokenStorage.saveToken(loginResponse.token);

    // Update API service token
    _apiService.authToken = loginResponse.token;

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

  /// Get authenticated user profile
  ///
  /// Requires valid authentication token.
  /// Returns Result<User> with user data.
  Future<Result<User>> getProfile() async {
    // Call API service - returns Result<UserApi>
    final result = await _apiService.getUserProfile();

    return switch (result) {
      Ok(:final value) => Result.ok(UserMapper.toDomain(value)),
      Error(:final error) => await _handleProfileError(error),
    };
  }

  /// Handle profile fetch error, clearing token on 401
  Future<Result<User>> _handleProfileError(Exception error) async {
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

  /// Check if user is authenticated
  ///
  /// Returns true if a valid token exists in storage.
  Future<bool> isAuthenticated() async {
    return _tokenStorage.hasToken();
  }

  /// Clear token from storage and API service
  Future<void> _clearToken() async {
    await _tokenStorage.deleteToken();
    _apiService.authToken = null;
  }
}
