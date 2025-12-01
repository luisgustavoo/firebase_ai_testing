import 'package:firebase_ai_testing/ui/category/view_models/category_view_model.dart';
import 'package:firebase_ai_testing/ui/core/widgets/widgets.dart';
import 'package:flutter/material.dart';

/// Categories screen
///
/// Displays list of categories with create, edit, and delete functionality.
/// Uses ListenableBuilder to observe CategoryViewModel.
/// Follows 1:1 View-ViewModel relationship pattern.
class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({
    required this.viewModel,
    super.key,
  });

  final CategoryViewModel viewModel;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  void initState() {
    super.initState();
    // Load categories on screen init
    widget.viewModel.loadCategoriesCommand.execute();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorias'),
      ),
      body: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, child) {
          return _buildBody();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateCategoryDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    final loadCommand = widget.viewModel.loadCategoriesCommand;

    // Show loading indicator
    if (loadCommand.running) {
      return const LoadingIndicator();
    }

    // Show error view
    if (loadCommand.error) {
      return ErrorView(
        message: 'Não foi possível carregar as categorias',
        onRetry: loadCommand.execute,
      );
    }

    // Show empty state
    if (widget.viewModel.categories.isEmpty) {
      return const EmptyStateView(
        icon: Icons.category_outlined,
        message: 'Nenhuma categoria ainda\nToque no + para criar uma',
      );
    }

    // Show categories list
    return ListView.builder(
      itemCount: widget.viewModel.categories.length,
      itemBuilder: (context, index) {
        final category = widget.viewModel.categories[index];
        return Dismissible(
          key: Key(category.id),
          background: _buildSwipeBackground(
            alignment: Alignment.centerLeft,
            color: Colors.blue,
            icon: Icons.edit,
          ),
          secondaryBackground: _buildSwipeBackground(
            alignment: Alignment.centerRight,
            color: Colors.red,
            icon: Icons.delete,
          ),
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.startToEnd) {
              // Edit action
              _showEditCategoryDialog(
                category.id,
                category.description,
                category.icon,
              );
              return false;
            } else {
              // Delete action
              return _showDeleteConfirmation(
                category.id,
                category.description,
              );
            }
          },
          child: ListTile(
            leading: CircleAvatar(
              child: Text(
                category.icon ?? '📁',
                style: const TextStyle(fontSize: 24),
              ),
            ),
            title: Text(category.description),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showEditCategoryDialog(
              category.id,
              category.description,
              category.icon,
            ),
          ),
        );
      },
    );
  }

  Widget _buildSwipeBackground({
    required Alignment alignment,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      color: color,
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }

  void _showCreateCategoryDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => _CategoryDialog(
        viewModel: widget.viewModel,
        title: 'Nova Categoria',
        onSave: (description, icon) async {
          await widget.viewModel.createCategoryCommand.execute(
            CreateCategoryParams(
              description: description,
              icon: icon,
            ),
          );

          if (widget.viewModel.createCategoryCommand.completed) {
            if (context.mounted) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Categoria criada com sucesso')),
              );
            }
          } else if (widget.viewModel.createCategoryCommand.error) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Erro ao criar categoria')),
              );
            }
          }
        },
      ),
    );
  }

  void _showEditCategoryDialog(String id, String description, String? icon) {
    showDialog<void>(
      context: context,
      builder: (context) => _CategoryDialog(
        viewModel: widget.viewModel,
        title: 'Editar Categoria',
        initialDescription: description,
        initialIcon: icon,
        onSave: (newDescription, newIcon) async {
          await widget.viewModel.updateCategoryCommand.execute(
            UpdateCategoryParams(
              id: id,
              description: newDescription,
              icon: newIcon,
            ),
          );

          if (widget.viewModel.updateCategoryCommand.completed) {
            if (context.mounted) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Categoria atualizada com sucesso'),
                ),
              );
            }
          } else if (widget.viewModel.updateCategoryCommand.error) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Erro ao atualizar categoria')),
              );
            }
          }
        },
      ),
    );
  }

  Future<bool> _showDeleteConfirmation(String id, String description) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Categoria'),
        content: Text('Deseja realmente excluir a categoria "$description"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (result ?? false) {
      await widget.viewModel.deleteCategoryCommand.execute(id);

      if (widget.viewModel.deleteCategoryCommand.completed) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Categoria excluída com sucesso')),
          );
        }
        return true;
      } else if (widget.viewModel.deleteCategoryCommand.error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erro ao excluir categoria')),
          );
        }
      }
    }

    return false;
  }
}

/// Dialog for creating/editing categories
class _CategoryDialog extends StatefulWidget {
  const _CategoryDialog({
    required this.viewModel,
    required this.title,
    required this.onSave,
    this.initialDescription,
    this.initialIcon,
  });

  final CategoryViewModel viewModel;
  final String title;
  final String? initialDescription;
  final String? initialIcon;
  final Future<void> Function(String description, String? icon) onSave;

  @override
  State<_CategoryDialog> createState() => _CategoryDialogState();
}

class _CategoryDialogState extends State<_CategoryDialog> {
  late final TextEditingController _descriptionController;
  late final TextEditingController _iconController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(
      text: widget.initialDescription,
    );
    _iconController = TextEditingController(text: widget.initialIcon);
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descrição',
                hintText: 'Ex: Alimentação',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Campo obrigatório';
                }
                if (value.trim().length < 3) {
                  return 'Mínimo de 3 caracteres';
                }
                return null;
              },
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _iconController,
              decoration: const InputDecoration(
                labelText: 'Ícone (emoji)',
                hintText: 'Ex: 🍔',
              ),
              maxLength: 2,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _handleSave,
          child: const Text('Salvar'),
        ),
      ],
    );
  }

  Future<void> _handleSave() async {
    if (_formKey.currentState!.validate()) {
      final description = _descriptionController.text.trim();
      final icon = _iconController.text.trim().isEmpty
          ? null
          : _iconController.text.trim();

      await widget.onSave(description, icon);
    }
  }
}
