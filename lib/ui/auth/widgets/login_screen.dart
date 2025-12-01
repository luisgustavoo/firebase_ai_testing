import 'package:firebase_ai_testing/ui/auth/view_models/auth_view_model.dart';
import 'package:firebase_ai_testing/ui/core/widgets/widgets.dart';
import 'package:firebase_ai_testing/utils/validators.dart';
import 'package:flutter/material.dart';

/// Login screen widget
///
/// Provides email and password fields with validation.
/// Uses AuthViewModel for authentication logic.
/// Displays loading indicator during login and error messages on failure.
class LoginScreen extends StatefulWidget {
  const LoginScreen({required this.viewModel, super.key});

  final AuthViewModel viewModel;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    // Validate form
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    // Execute login command
    await widget.viewModel.loginCommand.execute(
      LoginParams(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
    );

    // Check for errors
    if (widget.viewModel.loginCommand.error && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.viewModel.loginCommand.error.toString()),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    // Navigate to home on success
    if (widget.viewModel.loginCommand.completed && mounted) {
      // TODO(routing): Navigate to home screen when routing is implemented
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login realizado com sucesso!'),
        ),
      );
    }
  }

  void _navigateToRegister() {
    // TODO(routing): Navigate to register screen when routing is implemented
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Navegação para registro será implementada'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ListenableBuilder(
              listenable: widget.viewModel,
              builder: (context, child) {
                final isLoading = widget.viewModel.loginCommand.running;

                return Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // App logo or title
                      Icon(
                        Icons.account_balance_wallet,
                        size: 80,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Bem-vindo',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Faça login para continuar',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 48),

                      // Email field
                      CustomTextField(
                        controller: _emailController,
                        labelText: 'Email',
                        hintText: 'seu@email.com',
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        prefixIcon: const Icon(Icons.email_outlined),
                        validator: Validators.validateEmail,
                        enabled: !isLoading,
                      ),
                      const SizedBox(height: 16),

                      // Password field
                      CustomTextField(
                        controller: _passwordController,
                        labelText: 'Senha',
                        hintText: '••••••',
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        prefixIcon: const Icon(Icons.lock_outlined),
                        validator: Validators.validatePassword,
                        enabled: !isLoading,
                        onFieldSubmitted: (_) => _handleLogin(),
                      ),
                      const SizedBox(height: 24),

                      // Login button
                      CustomFilledButton(
                        onPressed: isLoading ? null : _handleLogin,
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Entrar'),
                      ),
                      const SizedBox(height: 16),

                      // Register link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Não tem uma conta? ',
                            style: theme.textTheme.bodyMedium,
                          ),
                          CustomTextButton(
                            onPressed: isLoading ? null : _navigateToRegister,
                            child: const Text('Cadastre-se'),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
