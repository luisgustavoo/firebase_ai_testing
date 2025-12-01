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
      icon: json['icon'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$CategoryApiModelToJson(_CategoryApiModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'description': instance.description,
      'icon': instance.icon,
      'created_at': instance.createdAt.toIso8601String(),
    };
