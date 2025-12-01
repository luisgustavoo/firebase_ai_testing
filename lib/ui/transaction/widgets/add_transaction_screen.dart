import 'package:firebase_ai_testing/data/services/api/models/transaction/transaction_request/create_transaction_request.dart';
import 'package:firebase_ai_testing/domain/models/transaction.dart';
import 'package:firebase_ai_testing/ui/transaction/view_models/add_transaction_view_model.dart';
import 'package:firebase_ai_testing/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// Add Transaction screen
///
/// Form for creating new transactions with validation.
/// Follows 1:1 View-ViewModel relationship pattern.
class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({
    required this.viewModel,
    super.key,
  });

  final AddTransactionViewModel viewModel;

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  TransactionType _transactionType = TransactionType.expense;
  PaymentType _paymentType = PaymentType.money;
  DateTime _selectedDate = DateTime.now();
  String? _selectedCategoryId;

  final _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    // Categories are loaded automatically in ViewModel constructor
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Transação'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Amount field
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Valor',
                hintText: 'Ex: 100.00',
                prefixText: r'R$ ',
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Campo obrigatório';
                }
                final amount = double.tryParse(value);
                return Validators.validateAmount(amount);
              },
            ),
            const SizedBox(height: 16),

            // Description field
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descrição',
                hintText: 'Ex: Almoço no restaurante',
              ),
              maxLength: 200,
              validator: Validators.validateDescription,
            ),
            const SizedBox(height: 16),

            // Category dropdown
            ListenableBuilder(
              listenable: widget.viewModel,
              builder: (context, child) {
                final categories = widget.viewModel.categories;

                return DropdownButtonFormField<String?>(
                  initialValue: _selectedCategoryId,
                  decoration: const InputDecoration(
                    labelText: 'Categoria (opcional)',
                  ),
                  items: [
                    const DropdownMenuItem<String?>(
                      child: Text('Sem categoria'),
                    ),
                    ...categories.map((category) {
                      return DropdownMenuItem<String?>(
                        value: category.id,
                        child: Row(
                          children: [
                            if (category.icon != null) ...[
                              Text(
                                category.icon!,
                                style: const TextStyle(fontSize: 20),
                              ),
                              const SizedBox(width: 8),
                            ],
                            Text(category.description),
                          ],
                        ),
                      );
                    }),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedCategoryId = value;
                    });
                  },
                );
              },
            ),
            const SizedBox(height: 16),

            // Transaction type selector
            const Text('Tipo de Transação', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            SegmentedButton<TransactionType>(
              segments: const [
                ButtonSegment(
                  value: TransactionType.income,
                  label: Text('Receita'),
                  icon: Icon(Icons.arrow_upward),
                ),
                ButtonSegment(
                  value: TransactionType.expense,
                  label: Text('Despesa'),
                  icon: Icon(Icons.arrow_downward),
                ),
              ],
              selected: {_transactionType},
              onSelectionChanged: (newSelection) {
                setState(() {
                  _transactionType = newSelection.first;
                });
              },
            ),
            const SizedBox(height: 16),

            // Payment type dropdown
            DropdownButtonFormField<PaymentType>(
              initialValue: _paymentType,
              decoration: const InputDecoration(
                labelText: 'Forma de Pagamento',
              ),
              items: const [
                DropdownMenuItem(
                  value: PaymentType.creditCard,
                  child: Text('Cartão de Crédito'),
                ),
                DropdownMenuItem(
                  value: PaymentType.debitCard,
                  child: Text('Cartão de Débito'),
                ),
                DropdownMenuItem(
                  value: PaymentType.pix,
                  child: Text('PIX'),
                ),
                DropdownMenuItem(
                  value: PaymentType.money,
                  child: Text('Dinheiro'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _paymentType = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),

            // Date picker
            ListTile(
              title: const Text('Data da Transação'),
              subtitle: Text(_dateFormat.format(_selectedDate)),
              trailing: const Icon(Icons.calendar_today),
              onTap: _selectDate,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Theme.of(context).dividerColor),
              ),
            ),
            const SizedBox(height: 24),

            // Save button
            ListenableBuilder(
              listenable: widget.viewModel,
              builder: (context, child) {
                final isLoading =
                    widget.viewModel.createTransactionCommand.running;

                return FilledButton(
                  onPressed: isLoading ? null : _handleSave,
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Salvar'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _handleSave() async {
    if (_formKey.currentState!.validate()) {
      final amount = double.parse(_amountController.text);
      final description = _descriptionController.text.trim();

      // Convert enums to API format
      final transactionTypeStr = _transactionType == TransactionType.income
          ? 'income'
          : 'expense';
      final paymentTypeStr = _getPaymentTypeString(_paymentType);

      final request = CreateTransactionRequest(
        amount: amount,
        transactionType: transactionTypeStr,
        paymentType: paymentTypeStr,
        transactionDate: _selectedDate,
        categoryId: _selectedCategoryId,
        description: description.isEmpty ? null : description,
      );

      await widget.viewModel.createTransactionCommand.execute(request);

      if (widget.viewModel.createTransactionCommand.completed) {
        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Transação criada com sucesso')),
          );
        }
      } else if (widget.viewModel.createTransactionCommand.error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erro ao criar transação')),
          );
        }
      }
    }
  }

  String _getPaymentTypeString(PaymentType type) {
    return switch (type) {
      PaymentType.creditCard => 'credit_card',
      PaymentType.debitCard => 'debit_card',
      PaymentType.pix => 'pix',
      PaymentType.money => 'money',
    };
  }
}
