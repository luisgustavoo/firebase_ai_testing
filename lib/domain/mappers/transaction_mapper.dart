import 'package:firebase_ai_testing/data/services/api/models/transaction/transaction_api.dart';
import 'package:firebase_ai_testing/data/services/api/models/transaction/transaction_request/create_transaction_request.dart';
import 'package:firebase_ai_testing/domain/models/transaction.dart';

class TransactionMapper {
  /// Converts TransactionApi (API model) to Transaction (domain model)
  static Transaction toDomain(TransactionApiModel api) {
    return Transaction(
      id: api.id,
      userId: api.userId,
      amount: api.amount,
      transactionType: _transactionTypeFromString(api.transactionType),
      paymentType: _paymentTypeFromString(api.paymentType),
      transactionDate: api.transactionDate,
      createdAt: api.createdAt,
      categoryId: api.categoryId,
      description: api.description,
    );
  }

  /// Converts Transaction (domain model) to TransactionApi (API model)
  static TransactionApiModel toApi(Transaction domain) {
    return TransactionApiModel(
      id: domain.id,
      userId: domain.userId,
      amount: domain.amount,
      transactionType: _transactionTypeToString(domain.transactionType),
      paymentType: _paymentTypeToString(domain.paymentType),
      transactionDate: domain.transactionDate,
      createdAt: domain.createdAt,
      categoryId: domain.categoryId,
      description: domain.description,
    );
  }

  /// Converts Transaction (domain model) to CreateTransactionRequest
  static CreateTransactionRequest toCreateRequest(Transaction transaction) {
    return CreateTransactionRequest(
      amount: transaction.amount,
      transactionType: _transactionTypeToString(transaction.transactionType),
      paymentType: _paymentTypeToString(transaction.paymentType),
      transactionDate: _formatDateToIso8601(transaction.transactionDate),
      categoryId: transaction.categoryId,
      description: transaction.description,
    );
  }

  /// Converts string transaction type to TransactionType enum
  static TransactionType _transactionTypeFromString(String type) {
    switch (type.toLowerCase()) {
      case 'income':
        return TransactionType.income;
      case 'expense':
        return TransactionType.expense;
      default:
        throw ArgumentError('Unknown transaction type: $type');
    }
  }

  /// Converts TransactionType enum to string
  static String _transactionTypeToString(TransactionType type) {
    switch (type) {
      case TransactionType.income:
        return 'income';
      case TransactionType.expense:
        return 'expense';
    }
  }

  /// Converts string payment type to PaymentType enum
  static PaymentType _paymentTypeFromString(String type) {
    switch (type.toLowerCase()) {
      case 'credit_card':
      case 'creditcard':
        return PaymentType.creditCard;
      case 'debit_card':
      case 'debitcard':
        return PaymentType.debitCard;
      case 'pix':
        return PaymentType.pix;
      case 'money':
        return PaymentType.money;
      default:
        throw ArgumentError('Unknown payment type: $type');
    }
  }

  /// Converts PaymentType enum to string
  static String _paymentTypeToString(PaymentType type) {
    switch (type) {
      case PaymentType.creditCard:
        return 'credit_card';
      case PaymentType.debitCard:
        return 'debit_card';
      case PaymentType.pix:
        return 'pix';
      case PaymentType.money:
        return 'money';
    }
  }

  /// Formats DateTime to ISO 8601 string
  static DateTime _formatDateToIso8601(DateTime date) {
    // DateTime.toIso8601String() already returns ISO 8601 format
    // We return the DateTime as-is since json_serializable will handle the conversion
    return date;
  }
}
