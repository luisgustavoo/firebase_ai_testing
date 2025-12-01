import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination_metadata.freezed.dart';
part 'pagination_metadata.g.dart';

@freezed
abstract class PaginationMetadata with _$PaginationMetadata {
  const factory PaginationMetadata({
    required int page,
    required int pageSize,
    required int total,
    required int totalPages,
    required bool hasNext,
    required bool hasPrevious,
  }) = _PaginationMetadata;

  factory PaginationMetadata.fromJson(Map<String, dynamic> json) =>
      _$PaginationMetadataFromJson(json);
}
