import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';

@freezed
abstract class Category with _$Category {
  const factory Category({
    required String id,
    required String userId,
    required String description,
    required bool isDefault,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? icon,
  }) = _Category;
}
