import 'package:firebase_ai_testing/data/repositories/category_repository.dart';
import 'package:firebase_ai_testing/data/repositories/transaction_repository.dart';
import 'package:firebase_ai_testing/data/services/api/models/transaction/transaction_request/create_transaction_request.dart';
import 'package:firebase_ai_testing/domain/models/category.dart' as domain;
import 'package:firebase_ai_testing/utils/command.dart';
import 'package:firebase_ai_testing/utils/result.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:injectable/injectable.dart';

/// ViewModel for Add Transaction screen
///
/// Coordinates between UI, TransactionRepository, and CategoryRepository.
/// Manages form state and transaction creation.
/// Follows 1:1 View-ViewModel relationship pattern.
@injectable
class AddTransactionViewModel extends ChangeNotifier {
  AddTransactionViewModel(
    this._transactionRepository,
    this._categoryRepository,
  ) {
    _loadCategories();
  }

  final TransactionRepository _transactionRepository;
  final CategoryRepository _categoryRepository;

  List<domain.Category> _categories = [];

  /// Available categories for selection
  List<domain.Category> get categories => _categories;

  late final Command1<void, CreateTransactionRequest> createTransactionCommand =
      Command1(_createTransaction);
  late final Command0<void> loadCategoriesCommand = Command0(_loadCategories);

  /// Load categories for dropdown
  Future<Result<void>> _loadCategories() async {
    final result = await _categoryRepository.getCategories();

    return switch (result) {
      Ok(:final value) => _handleCategoriesLoaded(value),
      Error(:final error) => Result.error(error),
    };
  }

  /// Handle successful categories load
  Result<void> _handleCategoriesLoaded(List<domain.Category> categories) {
    _categories = categories;
    notifyListeners();
    return const Result.ok(null);
  }

  /// Create a new transaction
  Future<Result<void>> _createTransaction(
    CreateTransactionRequest request,
  ) async {
    final result = await _transactionRepository.createTransaction(request);

    return switch (result) {
      Ok() => const Result.ok(null),
      Error(:final error) => Result.error(error),
    };
  }
}
