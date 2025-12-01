import 'package:firebase_ai_testing/data/services/api/models/user/user_api.dart';
import 'package:firebase_ai_testing/domain/models/user.dart';

class UserMapper {
  /// Converts UserApi (API model) to User (domain model)
  static User toDomain(UserApiModel api) {
    return User(
      id: api.id,
      name: api.name,
      email: api.email,
      status: _statusFromString(api.status),
      createdAt: api.createdAt,
      updatedAt: api.updatedAt,
    );
  }

  /// Converts User (domain model) to UserApi (API model)
  static UserApiModel toApi(User domain) {
    return UserApiModel(
      id: domain.id,
      name: domain.name,
      email: domain.email,
      status: _statusToString(domain.status),
      createdAt: domain.createdAt,
      updatedAt: domain.updatedAt,
    );
  }

  /// Converts string status to UserStatus enum
  static UserStatus _statusFromString(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return UserStatus.active;
      case 'inactive':
        return UserStatus.inactive;
      default:
        throw ArgumentError('Unknown user status: $status');
    }
  }

  /// Converts UserStatus enum to string
  static String _statusToString(UserStatus status) {
    switch (status) {
      case UserStatus.active:
        return 'active';
      case UserStatus.inactive:
        return 'inactive';
    }
  }
}
