import 'package:firebase_ai_testing/config/dependencies.dart';
import 'package:firebase_ai_testing/domain/models/transaction.dart';
import 'package:firebase_ai_testing/routing/routes.dart';
import 'package:firebase_ai_testing/ui/auth/logout/logout.dart';
import 'package:firebase_ai_testing/ui/home/view_models/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Home/Dashboard screen
///
/// Displays user summary, quick actions, and recent transactions.
/// Uses ListenableBuilder to observe HomeViewModel for user data.
/// Follows 1:1 View-ViewModel relationship pattern.
class HomeScreen extends StatefulWidget {
  const HomeScreen({
    required this.viewModel,
    super.key,
  });

  final HomeViewModel viewModel;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final LogoutViewModel _logoutViewModel;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _logoutViewModel = getIt<LogoutViewModel>();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate based on selected tab
    switch (index) {
      case 0:
        // Already on home
        break;
      case 1:
        // Navigate to categories
        context.pushNamed(Routes.categories);
        break;
      case 2:
        // Navigate to transactions
        context.pushNamed(Routes.transactions);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Olá, ${widget.viewModel.userName}'),
            actions: [
              LogoutButton(viewModel: _logoutViewModel),
            ],
          ),
          body: _buildBody(),
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Início',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.category),
                label: 'Categorias',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long),
                label: 'Transações',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        );
      },
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Summary cards
          _buildSummaryCards(),
          const SizedBox(height: 24),

          // Quick actions
          _buildQuickActions(),
          const SizedBox(height: 24),

          // Recent transactions
          _buildRecentTransactions(),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    // Show loading state
    if (widget.viewModel.loadSummaryCommand.running) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Resumo',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                title: 'Receitas',
                value: widget.viewModel.formattedIncome,
                icon: Icons.arrow_upward,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                title: 'Despesas',
                value: widget.viewModel.formattedExpense,
                icon: Icons.arrow_downward,
                color: Colors.red,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildSummaryCard(
          title: 'Saldo',
          value: widget.viewModel.formattedBalance,
          icon: Icons.account_balance_wallet,
          color: widget.viewModel.balance >= 0 ? Colors.blue : Colors.orange,
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ações Rápidas',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: () {
                  context.pushNamed(Routes.addTransaction);
                },
                icon: const Icon(Icons.add),
                label: const Text('Nova Transação'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  context.pushNamed(Routes.categories);
                },
                icon: const Icon(Icons.category),
                label: const Text('Categorias'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              context.pushNamed(Routes.scanReceipt);
            },
            icon: const Icon(Icons.camera_alt),
            label: const Text('Escanear Recibo'),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentTransactions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Transações Recentes',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextButton(
              onPressed: () {
                context.pushNamed(Routes.transactions);
              },
              child: const Text('Ver Todas'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        widget.viewModel.recentTransactions.isEmpty
            ? _buildEmptyState()
            : _buildTransactionsList(),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.receipt_long_outlined,
                size: 48,
                color: Theme.of(context).colorScheme.outline,
              ),
              const SizedBox(height: 12),
              Text(
                'Nenhuma transação ainda',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 4),
              Text(
                'Adicione sua primeira transação',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionsList() {
    return Column(
      children: widget.viewModel.recentTransactions
          .map(
            (transaction) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor:
                      transaction.transactionType == TransactionType.income
                      ? Colors.green.shade100
                      : Colors.red.shade100,
                  child: Icon(
                    transaction.transactionType == TransactionType.income
                        ? Icons.arrow_upward
                        : Icons.arrow_downward,
                    color: transaction.transactionType == TransactionType.income
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
                title: Text(transaction.description ?? 'Sem descrição'),
                subtitle: Text(
                  _formatDate(transaction.transactionDate),
                ),
                trailing: Text(
                  'R\$ ${transaction.amount.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: transaction.transactionType == TransactionType.income
                        ? Colors.green
                        : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Hoje';
    } else if (difference.inDays == 1) {
      return 'Ontem';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} dias atrás';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
