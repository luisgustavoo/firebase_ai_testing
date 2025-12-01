import 'package:firebase_ai_testing/domain/models/transaction.dart';

/// Validation utilities for input data
///
/// Provides static methods for validating user input before API calls.
/// All validation methods return null if valid, or an error message if invalid.
class Validators {
  // Private constructor to prevent instantiation
  Validators._();

  /// Validates email format
  ///
  /// Returns null if valid, error message if invalid.
  /// Valid email must match standard email pattern.
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    // Standard email regex pattern - more strict to avoid consecutive dots
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?(\.[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?)*\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Invalid email format';
    }

    return null;
  }

  /// Validates password length
  ///
  /// Returns null if valid, error message if invalid.
  /// Password must be at least 6 characters.
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  /// Validates name length
  ///
  /// Returns null if valid, error message if invalid.
  /// Name must be at least 3 characters.
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }

    if (value.length < 3) {
      return 'Name must be at least 3 characters';
    }

    return null;
  }

  /// Validates amount is positive
  ///
  /// Returns null if valid, error message if invalid.
  /// Amount must be greater than 0.
  static String? validateAmount(double? value) {
    if (value == null) {
      return 'Amount is required';
    }

    if (value <= 0) {
      return 'Amount must be greater than 0';
    }

    return null;
  }

  /// Validates description length
  ///
  /// Returns null if valid, error message if invalid.
  /// Description must be at least 3 characters (default).
  static String? validateDescription(String? value, {int minLength = 3}) {
    if (value == null || value.isEmpty) {
      return 'Description is required';
    }

    if (value.length < minLength) {
      return 'Description must be at least $minLength characters';
    }

    return null;
  }

  /// Validates transaction type
  ///
  /// Returns null if valid, error message if invalid.
  /// Transaction type must be exactly 'income' or 'expense' (lowercase).
  static String? validateTransactionType(String? value) {
    if (value == null || value.isEmpty) {
      return 'Transaction type is required';
    }

    final validTypes = ['income', 'expense'];
    if (!validTypes.contains(value)) {
      return 'Transaction type must be income or expense';
    }

    return null;
  }

  /// Validates payment type
  ///
  /// Returns null if valid, error message if invalid.
  /// Payment type must be exactly one of: credit_card, debit_card, pix, money (lowercase).
  static String? validatePaymentType(String? value) {
    if (value == null || value.isEmpty) {
      return 'Payment type is required';
    }

    final validTypes = ['credit_card', 'debit_card', 'pix', 'money'];
    if (!validTypes.contains(value)) {
      return 'Payment type must be credit_card, debit_card, pix, or money';
    }

    return null;
  }

  /// Validates TransactionType enum
  ///
  /// Returns true if valid, false otherwise.
  static bool isValidTransactionType(TransactionType type) {
    return TransactionType.values.contains(type);
  }

  /// Validates PaymentType enum
  ///
  /// Returns true if valid, false otherwise.
  static bool isValidPaymentType(PaymentType type) {
    return PaymentType.values.contains(type);
  }
}
