// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_extracted_expense.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AiExtractedExpense _$AiExtractedExpenseFromJson(Map<String, dynamic> json) =>
    _AiExtractedExpense(
      amount: (json['amount'] as num?)?.toDouble(),
      transactionType: json['transaction_type'] as String?,
      paymentType: json['payment_type'] as String?,
      transactionDate: json['transaction_date'] as String?,
      categoryId: json['category_id'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$AiExtractedExpenseToJson(_AiExtractedExpense instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'transaction_type': instance.transactionType,
      'payment_type': instance.paymentType,
      'transaction_date': instance.transactionDate,
      'category_id': instance.categoryId,
      'description': instance.description,
    };
