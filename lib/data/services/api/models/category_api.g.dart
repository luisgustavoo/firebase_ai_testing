// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CategoryApi _$CategoryApiFromJson(Map<String, dynamic> json) => _CategoryApi(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  description: json['description'] as String,
  icon: json['icon'] as String?,
  isDefault: json['is_default'] as bool,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$CategoryApiToJson(_CategoryApi instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'description': instance.description,
      'icon': instance.icon,
      'is_default': instance.isDefault,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
