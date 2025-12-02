import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_api_model.freezed.dart';
part 'transaction_api_model.g.dart';

@freezed
abstract class TransactionApiModel with _$TransactionApiModel {
  const factory TransactionApiModel({
    required String id,
    required String userId,
    required double amount,
    required String transactionType,
    required String paymentType,
    required DateTime transactionDate,
    required DateTime createdAt,
    String? categoryId,
    String? description,
  }) = _TransactionApiModel;

  factory TransactionApiModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionApiModelFromJson(json);
}
