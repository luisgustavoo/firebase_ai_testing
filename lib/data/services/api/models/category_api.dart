import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_api.freezed.dart';
part 'category_api.g.dart';

@freezed
abstract class CategoryApi with _$CategoryApi {
  const factory CategoryApi({
    required String id,
    required String userId,
    required String description,
    required bool isDefault,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? icon,
  }) = _CategoryApi;

  factory CategoryApi.fromJson(Map<String, dynamic> json) =>
      _$CategoryApiFromJson(json);
}
