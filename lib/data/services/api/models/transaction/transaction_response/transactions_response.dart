import 'package:firebase_ai_testing/data/services/api/models/transaction/transaction_api.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transactions_response.freezed.dart';
part 'transactions_response.g.dart';

@freezed
abstract class TransactionsResponse with _$TransactionsResponse {
  const factory TransactionsResponse({
    required int page,
    required int pageSize,
    required int total,
    required int totalPages,
    required bool hasNext,
    required bool hasPrevious,
    required List<TransactionApiModel> transactions,
  }) = _TransactionsResponse;

  factory TransactionsResponse.fromJson(Map<String, dynamic> json) =>
      _$TransactionsResponseFromJson(json);
}
