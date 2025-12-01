import 'package:firebase_ai_testing/data/repositories/user_repository.dart';
import 'package:firebase_ai_testing/domain/models/user.dart';
import 'package:firebase_ai_testing/utils/command.dart';
import 'package:firebase_ai_testing/utils/result.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

/// ViewModel for Home screen
///
/// Manages UI state for the home/dashboard screen.
/// Provides user information and summary data.
/// Uses Command pattern for async operations with loading/error states.
@injectable
class HomeViewModel extends ChangeNotifier {
  HomeViewModel({
    required UserRepository userRepository,
  }) : _userRepository = userRepository {
    loadUserCommand = Command0(_loadUserData)..execute();
    // Listen to user repository changes
    _userRepository.addListener(_onUserChanged);
  }

  final UserRepository _userRepository;

  User? _currentUser;

  late final Command0<void> loadUserCommand;

  /// Current authenticated user
  User? get currentUser => _currentUser;

  /// User display name
  String get userName => _currentUser?.name ?? 'Usuário';

  /// Load user data from repository
  Future<Result<void>> _loadUserData() async {
    // Get user data (uses cache if available)
    final result = await _userRepository.getUser();

    return switch (result) {
      Ok(:final value) => _handleUserLoaded(value),
      Error(:final error) => Result.error(error),
    };
  }

  /// Handle successful user load
  Result<void> _handleUserLoaded(User user) {
    _currentUser = user;
    notifyListeners();
    return const Result.ok(null);
  }

  /// Handle user repository changes
  void _onUserChanged() {
    // User data changed, update local state
    _currentUser = _userRepository.user;
    notifyListeners();
  }

  @override
  void dispose() {
    _userRepository.removeListener(_onUserChanged);
    super.dispose();
  }
}
