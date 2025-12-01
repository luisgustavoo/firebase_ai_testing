import 'package:firebase_ai_testing/data/services/api/api_service.dart';
import 'package:firebase_ai_testing/data/services/api/models/user/user_api.dart';
import 'package:firebase_ai_testing/domain/mappers/user_mapper.dart';
import 'package:firebase_ai_testing/domain/models/user.dart';
import 'package:firebase_ai_testing/utils/result.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

/// Repository for user data management
///
/// Implements basic local caching for user profile data.
/// Extends ChangeNotifier to notify listeners of user data changes.
@lazySingleton
class UserRepository extends ChangeNotifier {
  UserRepository(this._apiService);

  final ApiService _apiService;

  User? _cachedUser;

  /// Get cached user data
  User? get user => _cachedUser;

  /// Get user profile
  ///
  /// Returns cached data if available, otherwise fetches from API.
  /// Implements local caching strategy.
  Future<Result<User>> getUser() async {
    if (_cachedUser == null) {
      // No cached data, fetch from API
      final result = await _apiService.getUserProfile();

      return switch (result) {
        Ok(:final value) => _handleUserFetched(value),
        Error(:final error) => Result.error(error),
      };
    } else {
      // Return cached data if available
      return Result.ok(_cachedUser!);
    }
  }

  /// Handle successful user fetch
  Result<User> _handleUserFetched(UserApiModel userApi) {
    final user = UserMapper.toDomain(userApi);
    _cachedUser = user;
    notifyListeners();
    return Result.ok(user);
  }

  /// Refresh user data from API
  ///
  /// Forces a fresh fetch from the API, bypassing cache.
  Future<Result<User>> refreshUser() async {
    final result = await _apiService.getUserProfile();

    return switch (result) {
      Ok(:final value) => _handleUserFetched(value),
      Error(:final error) => Result.error(error),
    };
  }

  /// Clear cached user data
  ///
  /// Should be called on logout.
  void clearUser() {
    _cachedUser = null;
    notifyListeners();
  }
}
