// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransactionApiModel _$TransactionApiModelFromJson(Map<String, dynamic> json) =>
    _TransactionApiModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      transactionType: json['transaction_type'] as String,
      paymentType: json['payment_type'] as String,
      transactionDate: DateTime.parse(json['transaction_date'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      categoryId: json['category_id'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$TransactionApiModelToJson(
  _TransactionApiModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'amount': instance.amount,
  'transaction_type': instance.transactionType,
  'payment_type': instance.paymentType,
  'transaction_date': instance.transactionDate.toIso8601String(),
  'created_at': instance.createdAt.toIso8601String(),
  'category_id': instance.categoryId,
  'description': instance.description,
};
