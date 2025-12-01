import 'package:firebase_ai_testing/data/repositories/transaction_repository.dart';
import 'package:firebase_ai_testing/data/services/api/models/transaction/transaction_request/create_transaction_request.dart';
import 'package:firebase_ai_testing/data/services/api/models/transaction/transaction_response/transactions_response.dart';
import 'package:firebase_ai_testing/data/services/api/models/transaction/trasnaction_pagination_metadata/pagination_metadata.dart';
import 'package:firebase_ai_testing/domain/mappers/transaction_mapper.dart';
import 'package:firebase_ai_testing/domain/models/transaction.dart';
import 'package:firebase_ai_testing/utils/command.dart';
import 'package:firebase_ai_testing/utils/result.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

/// ViewModel for transaction operations
///
/// Coordinates between UI and TransactionRepository.
/// Does NOT perform validation - validation is handled in UI layer (TextFormField validators).
/// Uses Command pattern for async operations with loading/error states.
@injectable
class TransactionViewModel extends ChangeNotifier {
  TransactionViewModel(this._transactionRepository);

  final TransactionRepository _transactionRepository;

  List<Transaction> _transactions = [];
  PaginationMetadata? _pagination;
  TransactionType? _filter;

  /// Current list of transactions
  List<Transaction> get transactions => _transactions;

  /// Current pagination metadata
  PaginationMetadata? get pagination => _pagination;

  /// Current filter (transaction type)
  TransactionType? get filter => _filter;

  /// Whether there are more pages to load
  bool get hasMore => _pagination?.hasNext ?? false;

  late final Command1<void, CreateTransactionParams> createTransactionCommand =
      Command1(_createTransaction);
  late final Command0<void> loadTransactionsCommand = Command0(
    _loadTransactions,
  );
  late final Command0<void> loadMoreCommand = Command0(_loadMore);

  /// Create a new transaction
  ///
  /// Note: Input validation and date formatting should be done in UI layer.
  /// Adds the new transaction to the list on success.
  Future<Result<void>> _createTransaction(
    CreateTransactionParams params,
  ) async {
    final result = await _transactionRepository.createTransaction(
      params.request,
    );

    return switch (result) {
      Ok(:final value) => _handleCreateSuccess(value),
      Error(:final error) => Result.error(error),
    };
  }

  /// Handle successful transaction creation
  Result<void> _handleCreateSuccess(Transaction transaction) {
    // Add new transaction to the beginning of the list
    _transactions = [transaction, ..._transactions];
    notifyListeners();
    return const Result.ok(null);
  }

  /// Load transactions (first page)
  ///
  /// Fetches the first page of transactions with current filter.
  Future<Result<void>> _loadTransactions() async {
    final result = await _transactionRepository.getTransactions(
      type: _filter,
    );

    return switch (result) {
      Ok(:final value) => _handleLoadSuccess(value),
      Error(:final error) => Result.error(error),
    };
  }

  /// Handle successful transaction load
  Result<void> _handleLoadSuccess(TransactionsResponse response) {
    // Convert API models to domain models
    _transactions = response.transactions
        .map(TransactionMapper.toDomain)
        .toList();

    // Extract pagination metadata from response
    _pagination = PaginationMetadata(
      page: response.page,
      pageSize: response.pageSize,
      total: response.total,
      totalPages: response.totalPages,
      hasNext: response.hasNext,
      hasPrevious: response.hasPrevious,
    );

    notifyListeners();
    return const Result.ok(null);
  }

  /// Load more transactions (next page)
  ///
  /// Appends the next page of transactions to the existing list.
  /// Only loads if hasMore is true.
  Future<Result<void>> _loadMore() async {
    // Don't load if no more pages
    if (!hasMore) {
      return const Result.ok(null);
    }

    final nextPage = (_pagination?.page ?? 0) + 1;

    final result = await _transactionRepository.getTransactions(
      page: nextPage,
      type: _filter,
    );

    return switch (result) {
      Ok(:final value) => _handleLoadMoreSuccess(value),
      Error(:final error) => Result.error(error),
    };
  }

  /// Handle successful load more
  Result<void> _handleLoadMoreSuccess(TransactionsResponse response) {
    // Convert API models to domain models and append to existing list
    final newTransactions = response.transactions
        .map(TransactionMapper.toDomain)
        .toList();

    _transactions = [..._transactions, ...newTransactions];

    // Extract pagination metadata from response
    _pagination = PaginationMetadata(
      page: response.page,
      pageSize: response.pageSize,
      total: response.total,
      totalPages: response.totalPages,
      hasNext: response.hasNext,
      hasPrevious: response.hasPrevious,
    );

    notifyListeners();
    return const Result.ok(null);
  }

  /// Set filter and reload transactions
  ///
  /// Changes the transaction type filter and reloads the first page.
  Future<void> setFilter(TransactionType? filter) async {
    _filter = filter;
    notifyListeners();
    await loadTransactionsCommand.execute();
  }
}

/// Parameters for create transaction command
class CreateTransactionParams {
  CreateTransactionParams({
    required this.request,
  });

  final CreateTransactionRequest request;
}
