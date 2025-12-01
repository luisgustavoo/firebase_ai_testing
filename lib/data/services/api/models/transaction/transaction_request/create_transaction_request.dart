import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_transaction_request.freezed.dart';
part 'create_transaction_request.g.dart';

@freezed
abstract class CreateTransactionRequest with _$CreateTransactionRequest {
  const factory CreateTransactionRequest({
    required double amount,
    required String transactionType,
    required String paymentType,
    required DateTime transactionDate,
    String? categoryId,
    String? description,
  }) = _CreateTransactionRequest;

  factory CreateTransactionRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateTransactionRequestFromJson(json);
}
