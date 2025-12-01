import 'package:firebase_ai_testing/data/repositories/auth_repository.dart';
import 'package:firebase_ai_testing/data/repositories/user_repository.dart';
import 'package:firebase_ai_testing/domain/models/user.dart';
import 'package:firebase_ai_testing/utils/command.dart';
import 'package:firebase_ai_testing/utils/result.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

/// ViewModel for authentication operations
///
/// Coordinates between UI and AuthRepository/UserRepository.
/// Does NOT perform validation - validation is handled in UI layer (TextFormField validators).
/// Uses Command pattern for async operations with loading/error states.
@injectable
class AuthViewModel extends ChangeNotifier {
  AuthViewModel(this._authRepository, this._userRepository);

  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  User? _currentUser;

  /// Current authenticated user
  User? get currentUser => _currentUser;

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
    // Call repository
    final result = await _authRepository.register(
      params.name,
      params.email,
      params.password,
    );

    return switch (result) {
      Ok(:final value) => _handleRegisterSuccess(value),
      Error(:final error) => Result.error(error),
    };
  }

  /// Handle successful registration
  Result<void> _handleRegisterSuccess(User user) {
    _currentUser = user;
    notifyListeners();
    return const Result.ok(null);
  }

  /// Login with email and password
  ///
  /// Note: Input validation should be done in UI layer (TextFormField validators).
  /// Updates currentUser and isAuthenticated on success.
  Future<Result<void>> _login(LoginParams params) async {
    // Call auth repository to login and store token
    final loginResult = await _authRepository.login(
      params.email,
      params.password,
    );

    return switch (loginResult) {
      Ok() => await _handleLoginSuccess(),
      Error(:final error) => Result.error(error),
    };
  }

  /// Handle successful login by fetching user data
  Future<Result<void>> _handleLoginSuccess() async {
    // Fetch user data from UserRepository
    final userResult = await _userRepository.getUser();

    return switch (userResult) {
      Ok(:final value) => _updateCurrentUser(value),
      Error(:final error) => Result.error(error),
    };
  }

  /// Update current user and notify listeners
  Result<void> _updateCurrentUser(User user) {
    _currentUser = user;
    notifyListeners();
    return const Result.ok(null);
  }

  /// Logout current user
  ///
  /// Clears currentUser and authentication state.
  Future<Result<void>> _logout() async {
    await _authRepository.logout();
    _userRepository.clearUser();
    _currentUser = null;
    notifyListeners();
    return const Result.ok(null);
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
