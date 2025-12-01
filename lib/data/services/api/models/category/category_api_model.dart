import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_api_model.freezed.dart';
part 'category_api_model.g.dart';

@freezed
abstract class CategoryApiModel with _$CategoryApiModel {
  const factory CategoryApiModel({
    required String id,
    required String userId,
    required String description,
    required bool isDefault,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? icon,
  }) = _CategoryApiModel;

  factory CategoryApiModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryApiModelFromJson(json);
}
