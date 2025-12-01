import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_extracted_expense.freezed.dart';
part 'ai_extracted_expense.g.dart';

/// Raw data extracted by AI from receipt images
///
/// This is a DTO (Data Transfer Object) that represents the raw JSON response from AI.
/// It differs from TransactionApiModel (API response with id, userId, createdAt)
/// and CreateTransactionRequest (has DateTime, required fields).
///
/// All fields are optional since AI extraction may fail.
/// transactionDate is String (ISO format) since it comes from JSON.
/// The repository validates and transforms this to CreateTransactionRequest.
@freezed
abstract class AiExtractedExpense with _$AiExtractedExpense {
  const factory AiExtractedExpense({
    double? amount,
    String? transactionType,
    String? paymentType,
    String? transactionDate,
    String? categoryId,
    String? description,
  }) = _AiExtractedExpense;

  factory AiExtractedExpense.fromJson(Map<String, dynamic> json) =>
      _$AiExtractedExpenseFromJson(json);
}
