import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_api.freezed.dart';
part 'user_api.g.dart';

@freezed
abstract class UserApiModel with _$UserApiModel {
  const factory UserApiModel({
    required String id,
    required String name,
    required String email,
    required String status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UserApiModel;

  factory UserApiModel.fromJson(Map<String, dynamic> json) =>
      _$UserApiModelFromJson(json);
}
