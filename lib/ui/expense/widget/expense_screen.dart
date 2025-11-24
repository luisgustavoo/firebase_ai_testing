import 'package:firebase_ai_testing/data/services/model/expense_model.dart';
import 'package:flutter/material.dart';

class ExpenseScreen extends StatelessWidget {
  const ExpenseScreen({
    required ExpenseModel expenseModel,
    super.key,
  }) : _expenseModel = expenseModel;

  final ExpenseModel _expenseModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Text(_expenseModel.estabelecimento ?? ''),
            Text(_expenseModel.data?.toIso8601String() ?? ''),
            Text(_expenseModel.valor.toString()),
            Text(_expenseModel.categoria ?? ''),
            Text(_expenseModel.metodoPagamento ?? ''),
          ],
        ),
      ),
    );
  }
}
