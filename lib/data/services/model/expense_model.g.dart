// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExpenseModel _$ExpenseModelFromJson(Map<String, dynamic> json) =>
    _ExpenseModel(
      estabelecimento: json['estabelecimento'] as String?,
      data: json['data'] == null
          ? null
          : DateTime.parse(json['data'] as String),
      valor: (json['valor'] as num?)?.toDouble(),
      categoria: json['categoria'] as String?,
      metodoPagamento: json['metodoPagamento'] as String?,
    );

Map<String, dynamic> _$ExpenseModelToJson(_ExpenseModel instance) =>
    <String, dynamic>{
      'estabelecimento': instance.estabelecimento,
      'data': instance.data?.toIso8601String(),
      'valor': instance.valor,
      'categoria': instance.categoria,
      'metodoPagamento': instance.metodoPagamento,
    };
