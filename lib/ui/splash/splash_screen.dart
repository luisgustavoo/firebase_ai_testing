import 'package:firebase_ai_testing/ui/core/widgets/widgets.dart';
import 'package:firebase_ai_testing/ui/splash/view_models/splash_view_model.dart';
import 'package:flutter/material.dart';

/// Splash screen widget
///
/// Displays while checking for stored authentication token.
/// Automatically navigates to home if token is valid, or to login if invalid/missing.
class SplashScreen extends StatefulWidget {
  const SplashScreen({required this.viewModel, super.key});

  final SplashViewModel viewModel;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await widget.viewModel.checkAuthCommand.execute();

    if (!mounted) {
      return;
    }

    // Navigate based on auth status
    switch (widget.viewModel.authStatus) {
      case AuthStatus.authenticated:
        _navigateToHome();
      case AuthStatus.unauthenticated:
        _navigateToLogin();
      case AuthStatus.checking:
        // Still checking, do nothing
        break;
    }
  }

  void _navigateToHome() {
    // TODO: Navigate to home screen when routing is implemented
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Token válido! Navegando para home...'),
      ),
    );
  }

  void _navigateToLogin() {
    // TODO: Navigate to login screen when routing is implemented
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sem token ou token inválido. Navegando para login...'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, child) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App logo
                Icon(
                  Icons.account_balance_wallet,
                  size: 100,
                  color: colorScheme.primary,
                ),
                const SizedBox(height: 24),
                Text(
                  'Expense Tracker',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 48),
                // Loading indicator
                const LoadingIndicator(),
                const SizedBox(height: 16),
                Text(
                  'Verificando autenticação...',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
