// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransactionApi _$TransactionApiFromJson(Map<String, dynamic> json) =>
    _TransactionApi(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      categoryId: json['category_id'] as String?,
      amount: (json['amount'] as num).toDouble(),
      description: json['description'] as String?,
      transactionType: json['transaction_type'] as String,
      paymentType: json['payment_type'] as String,
      transactionDate: DateTime.parse(json['transaction_date'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$TransactionApiToJson(_TransactionApi instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'category_id': instance.categoryId,
      'amount': instance.amount,
      'description': instance.description,
      'transaction_type': instance.transactionType,
      'payment_type': instance.paymentType,
      'transaction_date': instance.transactionDate.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
    };
