import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_api.freezed.dart';
part 'transaction_api.g.dart';

@freezed
abstract class TransactionApi with _$TransactionApi {
  const factory TransactionApi({
    required String id,
    required String userId,
    required double amount,
    required String transactionType,
    required String paymentType,
    required DateTime transactionDate,
    required DateTime createdAt,
    String? categoryId,
    String? description,
  }) = _TransactionApi;

  factory TransactionApi.fromJson(Map<String, dynamic> json) =>
      _$TransactionApiFromJson(json);
}
