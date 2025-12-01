import 'package:firebase_ai_testing/data/repositories/auth_repository.dart';
import 'package:firebase_ai_testing/data/repositories/user_repository.dart';
import 'package:firebase_ai_testing/utils/command.dart';
import 'package:firebase_ai_testing/utils/result.dart';
import 'package:injectable/injectable.dart';

/// ViewModel for logout operations
///
/// Handles logout logic and coordinates with AuthRepository and UserRepository.
@injectable
class LogoutViewModel {
  LogoutViewModel({
    required AuthRepository authRepository,
    required UserRepository userRepository,
  }) : _authRepository = authRepository,
       _userRepository = userRepository {
    logout = Command0(_logout);
  }

  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  late Command0<void> logout;

  Future<Result<void>> _logout() async {
    try {
      // Clear authentication
      await _authRepository.logout();

      // Clear user cache
      _userRepository.clearUser();

      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
