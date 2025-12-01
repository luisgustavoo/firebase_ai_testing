import 'package:firebase_ai_testing/data/repositories/auth_repository.dart';
import 'package:firebase_ai_testing/data/repositories/user_repository.dart';
import 'package:firebase_ai_testing/utils/command.dart';
import 'package:firebase_ai_testing/utils/result.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

/// ViewModel for splash screen
///
/// Manages authentication check logic.
/// Checks for stored token and validates it with the API.
@injectable
class SplashViewModel extends ChangeNotifier {
  SplashViewModel(this._authRepository, this._userRepository);

  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  AuthStatus _authStatus = AuthStatus.checking;

  /// Current authentication status
  AuthStatus get authStatus => _authStatus;

  set authStatus(AuthStatus status) {
    if (_authStatus != status) {
      _authStatus = status;
      notifyListeners();
    }
  }

  late final Command0<void> checkAuthCommand = Command0(_checkAuth);

  /// Check authentication status
  ///
  /// Verifies if token exists and validates it with the API.
  Future<Result<void>> _checkAuth() async {
    // Check if token exists
    final hasToken = await _authRepository.isAuthenticated;

    if (!hasToken) {
      // No token, user needs to login
      authStatus = AuthStatus.unauthenticated;
      return const Result.ok(null);
    }

    // Token exists, validate it by fetching user profile
    final result = await _userRepository.getUser();

    switch (result) {
      case Ok():
        // Valid token, user is authenticated
        authStatus = AuthStatus.authenticated;
        return const Result.ok(null);
      case Error():
        // Invalid token (401), user needs to login
        authStatus = AuthStatus.unauthenticated;
        return const Result.ok(null);
    }
  }
}

/// Authentication status enum
enum AuthStatus {
  /// Checking authentication status
  checking,

  /// User is authenticated
  authenticated,

  /// User is not authenticated
  unauthenticated,
}
