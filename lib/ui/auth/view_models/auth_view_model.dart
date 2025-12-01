import 'package:firebase_ai_testing/data/repositories/auth_repository.dart';
import 'package:firebase_ai_testing/data/services/api/models/user/user_api.dart';
import 'package:firebase_ai_testing/domain/mappers/user_mapper.dart';
import 'package:firebase_ai_testing/domain/models/user.dart';
import 'package:firebase_ai_testing/utils/command.dart';
import 'package:firebase_ai_testing/utils/result.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

/// ViewModel for authentication operations
///
/// Coordinates between UI and AuthRepository.
/// Does NOT perform validation - validation is handled in UI layer (TextFormField validators).
/// Uses Command pattern for async operations with loading/error states.
@injectable
class AuthViewModel extends ChangeNotifier {
  AuthViewModel(this._authRepository);

  final AuthRepository _authRepository;

  User? _currentUser;
  String? _error;

  /// Current authenticated user
  User? get currentUser => _currentUser;

  /// Current error message
  String? get error => _error;

  /// Whether user is authenticated (delegates to repository)
  Future<bool> get isAuthenticated => _authRepository.isAuthenticated;

  late final Command1<void, RegisterParams> registerCommand = Command1(
    _register,
  );
  late final Command1<void, LoginParams> loginCommand = Command1(_login);
  late final Command0<void> logoutCommand = Command0(_logout);

  /// Register a new user
  ///
  /// Note: Input validation should be done in UI layer (TextFormField validators).
  /// Updates currentUser on success.
  Future<Result<void>> _register(RegisterParams params) async {
    // Clear previous error
    _error = null;
    notifyListeners();

    // Call repository
    final result = await _authRepository.register(
      params.name,
      params.email,
      params.password,
    );

    return switch (result) {
      Ok(:final value) => _handleRegisterSuccess(value),
      Error(:final error) => _handleError(error),
    };
  }

  /// Handle successful registration
  Result<void> _handleRegisterSuccess(User user) {
    _currentUser = user;
    _error = null;
    notifyListeners();
    return const Result.ok(null);
  }

  /// Login with email and password
  ///
  /// Note: Input validation should be done in UI layer (TextFormField validators).
  /// Updates currentUser and isAuthenticated on success.
  Future<Result<void>> _login(LoginParams params) async {
    // Clear previous error
    _error = null;
    notifyListeners();

    // Call repository
    final result = await _authRepository.login(params.email, params.password);

    return switch (result) {
      Ok(:final value) => _handleLoginSuccess(value.user),
      Error(:final error) => _handleError(error),
    };
  }

  /// Handle successful login
  Result<void> _handleLoginSuccess(UserApiModel userApi) {
    // Convert UserApi to User domain model using mapper
    _currentUser = UserMapper.toDomain(userApi);
    _error = null;
    notifyListeners();
    return const Result.ok(null);
  }

  /// Logout current user
  ///
  /// Clears currentUser and authentication state.
  Future<Result<void>> _logout() async {
    await _authRepository.logout();
    _currentUser = null;
    _error = null;
    notifyListeners();
    return const Result.ok(null);
  }

  /// Handle error
  Result<void> _handleError(Exception error) {
    _error = error.toString();
    notifyListeners();
    return Result.error(error);
  }

  /// Clear error state
  void clearError() {
    _error = null;
    notifyListeners();
  }
}

/// Parameters for register command
class RegisterParams {
  RegisterParams({
    required this.name,
    required this.email,
    required this.password,
  });

  final String name;
  final String email;
  final String password;
}

/// Parameters for login command
class LoginParams {
  LoginParams({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
}
