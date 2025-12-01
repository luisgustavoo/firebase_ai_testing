import 'package:firebase_ai_testing/data/services/api/models/transaction/transaction_api.dart';
import 'package:firebase_ai_testing/data/services/api/models/transaction/trasnaction_pagination_metadata/pagination_metadata.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transactions_response.freezed.dart';
part 'transactions_response.g.dart';

@freezed
abstract class TransactionsResponse with _$TransactionsResponse {
  const factory TransactionsResponse({
    required List<TransactionApiModel> transactions,
    required PaginationMetadata pagination,
  }) = _TransactionsResponse;

  factory TransactionsResponse.fromJson(Map<String, dynamic> json) =>
      _$TransactionsResponseFromJson(json);
}
