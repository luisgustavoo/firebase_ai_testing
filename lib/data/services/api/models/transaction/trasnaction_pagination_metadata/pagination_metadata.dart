import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination_metadata.freezed.dart';
part 'pagination_metadata.g.dart';

@freezed
abstract class PaginationMetadata with _$PaginationMetadata {
  const factory PaginationMetadata({
    required int page,
    @JsonKey(name: 'page_size') required int pageSize,
    required int total,
    @JsonKey(name: 'total_pages') required int totalPages,
    @JsonKey(name: 'has_next') required bool hasNext,
    @JsonKey(name: 'has_previous') required bool hasPrevious,
  }) = _PaginationMetadata;

  factory PaginationMetadata.fromJson(Map<String, dynamic> json) =>
      _$PaginationMetadataFromJson(json);
}
