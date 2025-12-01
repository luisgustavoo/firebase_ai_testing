import 'package:firebase_ai_testing/domain/models/transaction.dart';
import 'package:firebase_ai_testing/routing/routes.dart';
import 'package:firebase_ai_testing/ui/core/widgets/widgets.dart';
import 'package:firebase_ai_testing/ui/transaction/view_models/transaction_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// Transactions screen
///
/// Displays list of transactions with filtering, pagination, and create functionality.
/// Uses ListenableBuilder to observe TransactionViewModel.
/// Follows 1:1 View-ViewModel relationship pattern.
class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({
    required this.viewModel,
    super.key,
  });

  final TransactionViewModel viewModel;

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final ScrollController _scrollController = ScrollController();
  final _currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: r'R$');
  final _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    // Load transactions on screen init
    widget.viewModel.loadTransactionsCommand.execute();

    // Setup scroll listener for pagination
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      // Load more when scrolled to 90% of the list
      if (widget.viewModel.hasMore &&
          !widget.viewModel.loadMoreCommand.running) {
        widget.viewModel.loadMoreCommand.execute();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transações'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: ListenableBuilder(
              listenable: widget.viewModel,
              builder: (context, child) {
                return _buildBody();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddTransaction,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFilterChips() {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, child) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              FilterChip(
                label: const Text('Todas'),
                selected: widget.viewModel.filter == null,
                onSelected: (_) => widget.viewModel.setFilter(null),
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('Receitas'),
                selected: widget.viewModel.filter == TransactionType.income,
                onSelected: (_) =>
                    widget.viewModel.setFilter(TransactionType.income),
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('Despesas'),
                selected: widget.viewModel.filter == TransactionType.expense,
                onSelected: (_) =>
                    widget.viewModel.setFilter(TransactionType.expense),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody() {
    final loadCommand = widget.viewModel.loadTransactionsCommand;

    // Show loading indicator on first load
    if (loadCommand.running && widget.viewModel.transactions.isEmpty) {
      return const LoadingIndicator();
    }

    // Show error view
    if (loadCommand.error && widget.viewModel.transactions.isEmpty) {
      return ErrorView(
        message: 'Não foi possível carregar as transações',
        onRetry: loadCommand.execute,
      );
    }

    // Show empty state
    if (widget.viewModel.transactions.isEmpty) {
      return const EmptyStateView(
        icon: Icons.receipt_long_outlined,
        message: 'Nenhuma transação ainda\nToque no + para criar uma',
      );
    }

    // Show transactions list with pull-to-refresh
    return RefreshIndicator(
      onRefresh: () async {
        await widget.viewModel.loadTransactionsCommand.execute();
      },
      child: ListView.builder(
        controller: _scrollController,
        itemCount:
            widget.viewModel.transactions.length +
            (widget.viewModel.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          // Show loading indicator at the end if loading more
          if (index == widget.viewModel.transactions.length) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final transaction = widget.viewModel.transactions[index];
          return _buildTransactionTile(transaction);
        },
      ),
    );
  }

  Widget _buildTransactionTile(Transaction transaction) {
    final isIncome = transaction.transactionType == TransactionType.income;
    final color = isIncome ? Colors.green : Colors.red;
    final icon = isIncome ? Icons.arrow_upward : Icons.arrow_downward;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.1),
        child: Icon(icon, color: color),
      ),
      title: Text(
        transaction.description ?? 'Sem descrição',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      subtitle: Text(
        '${_dateFormat.format(transaction.transactionDate)} • ${_getPaymentTypeLabel(transaction.paymentType)}',
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: Text(
        _currencyFormat.format(transaction.amount),
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _getPaymentTypeLabel(PaymentType type) {
    return switch (type) {
      PaymentType.creditCard => 'Cartão de Crédito',
      PaymentType.debitCard => 'Cartão de Débito',
      PaymentType.pix => 'PIX',
      PaymentType.money => 'Dinheiro',
    };
  }

  void _showFilterDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filtrar Transações'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Todas'),
              leading: Icon(
                widget.viewModel.filter == null
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
              ),
              onTap: () {
                widget.viewModel.setFilter(null);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: const Text('Receitas'),
              leading: Icon(
                widget.viewModel.filter == TransactionType.income
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
              ),
              onTap: () {
                widget.viewModel.setFilter(TransactionType.income);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: const Text('Despesas'),
              leading: Icon(
                widget.viewModel.filter == TransactionType.expense
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
              ),
              onTap: () {
                widget.viewModel.setFilter(TransactionType.expense);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  void _navigateToAddTransaction() {
    context.pushNamed(Routes.addTransaction);
  }
}
