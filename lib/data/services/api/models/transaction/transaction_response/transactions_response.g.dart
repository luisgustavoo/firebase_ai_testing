// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactions_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransactionsResponse _$TransactionsResponseFromJson(
  Map<String, dynamic> json,
) => _TransactionsResponse(
  page: (json['page'] as num).toInt(),
  pageSize: (json['page_size'] as num).toInt(),
  total: (json['total'] as num).toInt(),
  totalPages: (json['total_pages'] as num).toInt(),
  hasNext: json['has_next'] as bool,
  hasPrevious: json['has_previous'] as bool,
  transactions: (json['transactions'] as List<dynamic>)
      .map((e) => TransactionApiModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$TransactionsResponseToJson(
  _TransactionsResponse instance,
) => <String, dynamic>{
  'page': instance.page,
  'page_size': instance.pageSize,
  'total': instance.total,
  'total_pages': instance.totalPages,
  'has_next': instance.hasNext,
  'has_previous': instance.hasPrevious,
  'transactions': instance.transactions.map((e) => e.toJson()).toList(),
};
