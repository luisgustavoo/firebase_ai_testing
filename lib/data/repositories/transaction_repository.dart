import 'package:firebase_ai_testing/data/services/api/api_service.dart';
import 'package:firebase_ai_testing/data/services/api/models/transaction/transaction_request/create_transaction_request.dart';
import 'package:firebase_ai_testing/data/services/api/models/transaction/transaction_response/transactions_response.dart';
import 'package:firebase_ai_testing/domain/mappers/transaction_mapper.dart';
import 'package:firebase_ai_testing/domain/models/transaction.dart';
import 'package:firebase_ai_testing/utils/result.dart';
import 'package:injectable/injectable.dart';

/// Repository for handling transaction operations
///
/// Manages transaction creation and paginated listing.
/// Transforms API models to domain models and handles errors.
@lazySingleton
class TransactionRepository {
  TransactionRepository(this._apiService);

  final ApiService _apiService;

  /// Create a new transaction
  ///
  /// Returns Result<Transaction> with the created transaction.
  /// Note: Input validation and date formatting should be done in the ViewModel/UI layer.
  Future<Result<Transaction>> createTransaction(
    CreateTransactionRequest request,
  ) async {
    // Call API service - returns Result<TransactionApi>
    final result = await _apiService.createTransaction(request);

    // Transform Result<TransactionApi> to Result<Transaction>
    return switch (result) {
      Ok(:final value) => Result.ok(TransactionMapper.toDomain(value)),
      Error(:final error) => Result.error(error),
    };
  }

  /// Get transactions with pagination and optional filters
  ///
  /// Returns Result<TransactionsResponse> with transactions and pagination metadata.
  /// Parameters:
  /// - page: Page number (default: 1)
  /// - pageSize: Number of items per page (default: 20)
  /// - type: Optional filter by transaction type (income/expense)
  Future<Result<TransactionsResponse>> getTransactions({
    int page = 1,
    int pageSize = 20,
    TransactionType? type,
  }) async {
    // Convert TransactionType enum to string for API
    final typeString = type != null ? _transactionTypeToString(type) : null;

    // Call API service - returns Result<TransactionsResponse>
    final result = await _apiService.getTransactions(
      page: page,
      pageSize: pageSize,
      type: typeString,
    );

    // Return result as-is since TransactionsResponse contains both
    // transactions and pagination metadata
    return result;
  }

  /// Convert TransactionType enum to string for API
  String _transactionTypeToString(TransactionType type) {
    switch (type) {
      case TransactionType.income:
        return 'income';
      case TransactionType.expense:
        return 'expense';
    }
  }
}
