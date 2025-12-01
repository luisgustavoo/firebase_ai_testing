// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactions_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransactionsResponse _$TransactionsResponseFromJson(
  Map<String, dynamic> json,
) => _TransactionsResponse(
  transactions: (json['transactions'] as List<dynamic>)
      .map((e) => TransactionApi.fromJson(e as Map<String, dynamic>))
      .toList(),
  pagination: PaginationMetadata.fromJson(
    json['pagination'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$TransactionsResponseToJson(
  _TransactionsResponse instance,
) => <String, dynamic>{
  'transactions': instance.transactions.map((e) => e.toJson()).toList(),
  'pagination': instance.pagination.toJson(),
};
