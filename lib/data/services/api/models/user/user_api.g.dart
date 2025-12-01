// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserApiModel _$UserApiModelFromJson(Map<String, dynamic> json) =>
    _UserApiModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      status: json['status'] as String,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$UserApiModelToJson(_UserApiModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'status': instance.status,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
