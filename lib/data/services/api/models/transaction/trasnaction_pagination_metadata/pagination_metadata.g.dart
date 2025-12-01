// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination_metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PaginationMetadata _$PaginationMetadataFromJson(Map<String, dynamic> json) =>
    _PaginationMetadata(
      page: (json['page'] as num).toInt(),
      pageSize: (json['page_size'] as num).toInt(),
      total: (json['total'] as num).toInt(),
      totalPages: (json['total_pages'] as num).toInt(),
      hasNext: json['has_next'] as bool,
      hasPrevious: json['has_previous'] as bool,
    );

Map<String, dynamic> _$PaginationMetadataToJson(_PaginationMetadata instance) =>
    <String, dynamic>{
      'page': instance.page,
      'page_size': instance.pageSize,
      'total': instance.total,
      'total_pages': instance.totalPages,
      'has_next': instance.hasNext,
      'has_previous': instance.hasPrevious,
    };
