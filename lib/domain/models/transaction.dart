import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction.freezed.dart';

@freezed
abstract class Transaction with _$Transaction {
  const factory Transaction({
    required String id,
    required String userId,
    required double amount,
    required TransactionType transactionType,
    required PaymentType paymentType,
    required DateTime transactionDate,
    required DateTime createdAt,
    String? categoryId,
    String? description,
  }) = _Transaction;
}

enum TransactionType { income, expense }

enum PaymentType { creditCard, debitCard, pix, money }
