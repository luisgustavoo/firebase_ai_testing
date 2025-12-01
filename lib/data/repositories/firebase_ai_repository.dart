import 'dart:developer';

import 'package:firebase_ai_testing/data/services/api/api_service.dart';
import 'package:firebase_ai_testing/data/services/api/models/transaction/transaction_request/create_transaction_request.dart';
import 'package:firebase_ai_testing/data/services/firebase_ai_service.dart';
import 'package:firebase_ai_testing/data/services/firebase_ai_service/models/ai_extracted_expense.dart';
import 'package:firebase_ai_testing/domain/mappers/category_mapper.dart';
import 'package:firebase_ai_testing/domain/mappers/transaction_mapper.dart';
import 'package:firebase_ai_testing/domain/models/category.dart';
import 'package:firebase_ai_testing/domain/models/transaction.dart';
import 'package:firebase_ai_testing/utils/result.dart';
import 'package:injectable/injectable.dart';

/// Repository for handling Firebase AI operations
///
/// Combines FirebaseAiService with ApiService to provide AI-powered
/// expense extraction and transaction creation.
/// Following MVVM architecture: Repository combines services, not other repositories.
@lazySingleton
class FirebaseAiRepository {
  FirebaseAiRepository(
    this._firebaseAiService,
    this._apiService,
  );

  final FirebaseAiService _firebaseAiService;
  final ApiService _apiService;

  /// Initialize repository and configure AI service providers
  @postConstruct
  void init() {
    // Configure category provider for AI
    // Returns list of category descriptions with IDs for AI to choose from
    _firebaseAiService.categoryProvider = () async {
      final result = await _apiService.getUserProfile();

      switch (result) {
        case Ok(:final value):
          final result = await _apiService.getCategories(value.id);
          return switch (result) {
            Ok(:final value) =>
              value.map((c) => '${c.id}:${c.description}').toList(),
            Error() => [],
          };
        case Error(:final error):
          log('Error fetching user profile: $error');
          return [];
      }
    };

    // Configure transaction provider for AI
    _firebaseAiService.transactionProvider = () async {
      final result = await _apiService.getTransactions(
        pageSize: 50, // Get recent 50 transactions for AI context
      );
      return switch (result) {
        Ok(:final value) =>
          value.transactions
              .map(
                (t) => {
                  'amount': t.amount,
                  'type': t.transactionType,
                  'category': t.categoryId,
                  'date': t.transactionDate.toIso8601String(),
                  'description': t.description,
                },
              )
              .toList(),
        Error() => [],
      };
    };
  }

  /// Get all categories for the user
  ///
  /// Returns Result<List<Category>> with domain models.
  Future<Result<List<Category>>> getCategories() async {
    final result = await _apiService.getUserProfile();

    switch (result) {
      case Ok(:final value):
        final result = await _apiService.getCategories(value.id);
        return switch (result) {
          Ok(:final value) => Result.ok(
            value.map(CategoryMapper.toDomain).toList(),
          ),
          Error(:final error) => Result.error(error),
        };
      case Error(:final error):
        log('Error fetching user profile: $error');
        return Result.error(error);
    }
  }

  /// Extract expense data from receipt image using AI
  ///
  /// Returns Result<AiExtractedExpense> with extracted data.
  /// The AI will automatically fetch user categories during analysis.
  Future<Result<AiExtractedExpense>> extractExpenseFromReceipt(
    String imagePath,
  ) async {
    return _firebaseAiService.analyzeReceiptImage(imagePath);
  }

  /// Create transaction from AI-extracted expense data
  ///
  /// Validates extracted data and creates transaction via API service.
  /// Returns Result<Transaction> with the created transaction.
  Future<Result<Transaction>> createTransactionFromExtractedExpense(
    AiExtractedExpense extracted,
  ) async {
    try {
      // Validate extracted data
      if (extracted.amount == null || extracted.amount! <= 0) {
        return Result.error(
          Exception('Valor inválido extraído da imagem'),
        );
      }

      if (extracted.transactionDate == null) {
        return Result.error(
          Exception('Data inválida extraída da imagem'),
        );
      }

      if (extracted.transactionType == null) {
        return Result.error(
          Exception('Tipo de transação não especificado'),
        );
      }

      if (extracted.paymentType == null) {
        return Result.error(
          Exception('Método de pagamento não especificado'),
        );
      }

      // Parse date
      DateTime transactionDate;
      try {
        transactionDate = DateTime.parse(extracted.transactionDate!);
      } on FormatException {
        return Result.error(
          Exception('Formato de data inválido: ${extracted.transactionDate}'),
        );
      }

      // Create transaction request
      final request = CreateTransactionRequest(
        amount: extracted.amount!,
        transactionType: extracted.transactionType!,
        paymentType: extracted.paymentType!,
        transactionDate: transactionDate,
        categoryId: extracted.categoryId,
        description: extracted.description,
      );

      // Create transaction via API service
      final result = await _apiService.createTransaction(request);

      // Transform API model to domain model
      return switch (result) {
        Ok(:final value) => Result.ok(TransactionMapper.toDomain(value)),
        Error(:final error) => Result.error(error),
      };
    } on Exception catch (e) {
      log('Error creating transaction from extracted expense: $e');
      return Result.error(e);
    }
  }
}
