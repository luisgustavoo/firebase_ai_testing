// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_transaction_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateTransactionRequest _$CreateTransactionRequestFromJson(
  Map<String, dynamic> json,
) => _CreateTransactionRequest(
  categoryId: json['category_id'] as String?,
  amount: (json['amount'] as num).toDouble(),
  description: json['description'] as String?,
  transactionType: json['transaction_type'] as String,
  paymentType: json['payment_type'] as String,
  transactionDate: DateTime.parse(json['transaction_date'] as String),
);

Map<String, dynamic> _$CreateTransactionRequestToJson(
  _CreateTransactionRequest instance,
) => <String, dynamic>{
  'category_id': instance.categoryId,
  'amount': instance.amount,
  'description': instance.description,
  'transaction_type': instance.transactionType,
  'payment_type': instance.paymentType,
  'transaction_date': instance.transactionDate.toIso8601String(),
};
