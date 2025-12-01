import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_request.freezed.dart';
part 'category_request.g.dart';

@freezed
abstract class CategoryRequest with _$CategoryRequest {
  const factory CategoryRequest({
    required String description,
    String? icon,
  }) = _CategoryRequest;

  factory CategoryRequest.fromJson(Map<String, dynamic> json) =>
      _$CategoryRequestFromJson(json);
}
