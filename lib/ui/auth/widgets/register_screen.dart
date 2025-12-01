import 'package:firebase_ai_testing/ui/auth/view_models/auth_view_model.dart';
import 'package:firebase_ai_testing/ui/core/widgets/widgets.dart';
import 'package:firebase_ai_testing/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Registration screen widget
///
/// Provides name, email and password fields with validation.
/// Uses AuthViewModel for registration logic.
/// Displays loading indicator during registration and error messages on failure.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({required this.viewModel, super.key});

  final AuthViewModel viewModel;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    // Validate form
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    // Execute register command
    await widget.viewModel.registerCommand.execute(
      RegisterParams(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
    );

    // Check for errors
    if (widget.viewModel.registerCommand.error && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.viewModel.registerCommand.error.toString()),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    // Navigate to login on success
    if (widget.viewModel.registerCommand.completed && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cadastro realizado com sucesso! Faça login.'),
        ),
      );
      context.pop();
    }
  }

  void _navigateToLogin() {
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Conta'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ListenableBuilder(
              listenable: widget.viewModel,
              builder: (context, child) {
                final isLoading = widget.viewModel.registerCommand.running;

                return Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // App logo or title
                      Icon(
                        Icons.person_add_outlined,
                        size: 80,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Criar Conta',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Preencha os dados para começar',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 48),

                      // Name field
                      CustomTextField(
                        controller: _nameController,
                        labelText: 'Nome',
                        hintText: 'Seu nome completo',
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        prefixIcon: const Icon(Icons.person_outlined),
                        validator: Validators.validateName,
                        enabled: !isLoading,
                      ),
                      const SizedBox(height: 16),

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
                        hintText: 'Mínimo 6 caracteres',
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        prefixIcon: const Icon(Icons.lock_outlined),
                        validator: Validators.validatePassword,
                        enabled: !isLoading,
                        onFieldSubmitted: (_) => _handleRegister(),
                      ),
                      const SizedBox(height: 24),

                      // Register button
                      CustomFilledButton(
                        onPressed: isLoading ? null : _handleRegister,
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Cadastrar'),
                      ),
                      const SizedBox(height: 16),

                      // Back to login link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Já tem uma conta? ',
                            style: theme.textTheme.bodyMedium,
                          ),
                          CustomTextButton(
                            onPressed: isLoading ? null : _navigateToLogin,
                            child: const Text('Fazer login'),
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
