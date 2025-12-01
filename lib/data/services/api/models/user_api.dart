import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_api.freezed.dart';
part 'user_api.g.dart';

@freezed
abstract class UserApi with _$UserApi {
  const factory UserApi({
    required String id,
    required String name,
    required String email,
    required String status,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserApi;

  factory UserApi.fromJson(Map<String, dynamic> json) =>
      _$UserApiFromJson(json);
}
