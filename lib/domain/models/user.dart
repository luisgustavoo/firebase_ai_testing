import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
abstract class User with _$User {
  const factory User({
    required String id,
    required String name,
    required String email,
    required UserStatus status,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _User;
}

enum UserStatus { active, inactive }
