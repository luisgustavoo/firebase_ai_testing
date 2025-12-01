import 'package:firebase_ai_testing/ui/auth/logout/view_models/logout_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Logout button widget
///
/// Displays a logout icon button that triggers logout operation.
/// Shows error feedback if logout fails.
class LogoutButton extends StatefulWidget {
  const LogoutButton({required this.viewModel, super.key});

  final LogoutViewModel viewModel;

  @override
  State<LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<LogoutButton> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.logout.addListener(_onResult);
  }

  @override
  void didUpdateWidget(covariant LogoutButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.logout.removeListener(_onResult);
    widget.viewModel.logout.addListener(_onResult);
  }

  @override
  void dispose() {
    widget.viewModel.logout.removeListener(_onResult);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.logout),
      onPressed: widget.viewModel.logout.execute,
      tooltip: 'Sair',
    );
  }

  void _onResult() {
    // We do not need to navigate to `/login` on logout,
    // it is done automatically by GoRouter redirect logic.
    if (widget.viewModel.logout.error) {
      widget.viewModel.logout.clearResult();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Erro ao fazer logout'),
            action: SnackBarAction(
              label: 'Tentar novamente',
              onPressed: widget.viewModel.logout.execute,
            ),
          ),
        );
      }
    } else if (widget.viewModel.logout.completed && mounted) {
      // Navigate to login on successful logout
      context.go('/login');
    }
  }
}
