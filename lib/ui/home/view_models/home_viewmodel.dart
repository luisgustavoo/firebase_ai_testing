import 'package:firebase_ai_testing/data/repositories/user_repository.dart';
import 'package:firebase_ai_testing/domain/models/user.dart';
import 'package:firebase_ai_testing/utils/result.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

/// ViewModel for Home screen
///
/// Manages UI state for the home/dashboard screen.
/// Provides user information and summary data.
@injectable
class HomeViewModel extends ChangeNotifier {
  HomeViewModel({
    required UserRepository userRepository,
  }) : _userRepository = userRepository {
    _loadUserData();
  }

  final UserRepository _userRepository;

  User? _currentUser;

  /// Current authenticated user
  User? get currentUser => _currentUser;

  /// User display name
  String get userName => _currentUser?.name ?? 'Usuário';

  /// Load user data from repository
  Future<void> _loadUserData() async {
    // Listen to user repository changes
    _userRepository.addListener(_onUserChanged);

    // Get user data (uses cache if available)
    final result = await _userRepository.getUser();
    switch (result) {
      case Ok(:final value):
        _currentUser = value;
        notifyListeners();
      case Error():
        // Error getting user, user will remain null
        break;
    }
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
