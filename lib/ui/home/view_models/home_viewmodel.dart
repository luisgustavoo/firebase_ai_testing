import 'dart:developer';

import 'package:firebase_ai_testing/data/repositories/transaction_repository.dart';
import 'package:firebase_ai_testing/data/repositories/user_repository.dart';
import 'package:firebase_ai_testing/data/services/api/models/transaction/transaction_api.dart';
import 'package:firebase_ai_testing/domain/mappers/transaction_mapper.dart';
import 'package:firebase_ai_testing/domain/models/transaction.dart';
import 'package:firebase_ai_testing/domain/models/user.dart';
import 'package:firebase_ai_testing/utils/command.dart';
import 'package:firebase_ai_testing/utils/result.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

/// ViewModel for Home screen
///
/// Manages UI state for the home/dashboard screen.
/// Provides user information and summary data.
/// Uses Command pattern for async operations with loading/error states.
@injectable
class HomeViewModel extends ChangeNotifier {
  HomeViewModel({
    required UserRepository userRepository,
    required TransactionRepository transactionRepository,
  }) : _userRepository = userRepository,
       _transactionRepository = transactionRepository {
    loadUserCommand = Command0(_loadUserData);
    loadSummaryCommand = Command0(_loadSummary);

    // Listen to user repository changes
    _userRepository.addListener(_onUserChanged);

    // Load data on initialization
    loadUserCommand.execute();
    loadSummaryCommand.execute();
  }

  final UserRepository _userRepository;
  final TransactionRepository _transactionRepository;

  User? _currentUser;
  List<Transaction> _recentTransactions = [];
  double _totalIncome = 0;
  double _totalExpense = 0;

  late final Command0<void> loadUserCommand;
  late final Command0<void> loadSummaryCommand;

  /// Current authenticated user
  User? get currentUser => _currentUser;

  /// User display name
  String get userName => _currentUser?.name ?? 'Usuário';

  /// Recent transactions (last 5)
  List<Transaction> get recentTransactions => _recentTransactions;

  /// Total income
  double get totalIncome => _totalIncome;

  /// Total expense
  double get totalExpense => _totalExpense;

  /// Balance (income - expense)
  double get balance => _totalIncome - _totalExpense;

  /// Formatted income
  String get formattedIncome => 'R\$ ${_totalIncome.toStringAsFixed(2)}';

  /// Formatted expense
  String get formattedExpense => 'R\$ ${_totalExpense.toStringAsFixed(2)}';

  /// Formatted balance
  String get formattedBalance => 'R\$ ${balance.toStringAsFixed(2)}';

  /// Load user data from repository
  Future<Result<void>> _loadUserData() async {
    // Get user data (uses cache if available)
    final result = await _userRepository.getUser();

    return switch (result) {
      Ok(:final value) => _handleUserLoaded(value),
      Error(:final error) => Result.error(error),
    };
  }

  /// Handle successful user load
  Result<void> _handleUserLoaded(User user) {
    _currentUser = user;
    notifyListeners();
    return const Result.ok(null);
  }

  /// Load summary data (transactions and calculations)
  Future<Result<void>> _loadSummary() async {
    // Get recent transactions

    final result = await _transactionRepository.getTransactions(
      pageSize: 5,
    );

    return switch (result) {
      Ok(:final value) => _handleSummaryLoaded(value.transactions),
      Error(:final error) => Result.error(error),
    };
  }

  /// Handle successful summary load
  Result<void> _handleSummaryLoaded(List<TransactionApiModel> transactions) {
    // Store recent transactions (limited to 5)
    try {
      _recentTransactions = transactions
          .take(5)
          .map(TransactionMapper.toDomain)
          .toList();

      // Calculate totals
      _totalIncome = 0;
      _totalExpense = 0;

      for (final transaction in transactions) {
        final t = TransactionMapper.toDomain(transaction);
        if (t.transactionType == TransactionType.income) {
          _totalIncome += t.amount;
        } else {
          _totalExpense += t.amount;
        }
      }

      notifyListeners();
      return const Result.ok(null);
    } on Exception catch (e) {
      log('Erro ao listar transações', error: e);
      return Result.error(e);
    }
  }

  /// Handle user repository changes
  void _onUserChanged() {
    // User data changed, update local state
    _currentUser = _userRepository.user;
    notifyListeners();
  }

  /// Refresh all data
  Future<void> refresh() async {
    await Future.wait([
      loadUserCommand.execute(),
      loadSummaryCommand.execute(),
    ]);
  }

  @override
  void dispose() {
    _userRepository.removeListener(_onUserChanged);
    super.dispose();
  }
}
