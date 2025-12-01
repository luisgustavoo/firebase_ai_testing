// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CategoryApiModel _$CategoryApiModelFromJson(Map<String, dynamic> json) =>
    _CategoryApiModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      description: json['description'] as String,
      isDefault: json['is_default'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      icon: json['icon'] as String?,
    );

Map<String, dynamic> _$CategoryApiModelToJson(_CategoryApiModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'description': instance.description,
      'is_default': instance.isDefault,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'icon': instance.icon,
    };
