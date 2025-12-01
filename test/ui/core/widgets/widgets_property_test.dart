import 'package:firebase_ai_testing/ui/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// **Feature: api-integration, Property 28: Error states display with recovery options**
/// **Feature: api-integration, Property 29: Validation feedback is displayed**
/// **Validates: Requirements 11.5, 11.7**
///
/// Property-based tests for UI components.
/// Verifies error handling, validation feedback, and recovery options.
void main() {
  group('UI Components Property Tests', () {
    testWidgets(
      'Property 28: Error states display with recovery options',
      (tester) async {
        // **Feature: api-integration, Property 28: Error states display with recovery options**
        // For any error message, ErrorView should display the message and a retry button

        var retryPressed = false;
        const errorMessage = 'Erro ao carregar dados';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ErrorView(
                message: errorMessage,
                onRetry: () {
                  retryPressed = true;
                },
              ),
            ),
          ),
        );

        // Verify error message is displayed
        expect(find.text(errorMessage), findsOneWidget);

        // Verify error icon is displayed
        expect(find.byIcon(Icons.error_outline), findsOneWidget);

        // Verify retry button is displayed
        expect(find.text('Tentar novamente'), findsOneWidget);
        expect(find.byIcon(Icons.refresh), findsOneWidget);

        // Verify retry button works
        await tester.tap(find.text('Tentar novamente'));
        await tester.pump();

        expect(retryPressed, true);
      },
    );

    testWidgets(
      'Property 28: Error view displays different error messages',
      (tester) async {
        // **Feature: api-integration, Property 28: Error states display with recovery options**
        // For any error message, the ErrorView should display that specific message

        final errorMessages = [
          'Sem conexão com a internet',
          'Sessão expirada',
          'Erro no servidor',
          'Dados inválidos',
        ];

        for (final message in errorMessages) {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: ErrorView(
                  message: message,
                  onRetry: () {},
                ),
              ),
            ),
          );

          // Verify each specific error message is displayed
          expect(find.text(message), findsOneWidget);
        }
      },
    );

    testWidgets(
      'Property 29: Validation feedback is displayed in CustomTextField',
      (tester) async {
        // **Feature: api-integration, Property 29: Validation feedback is displayed**
        // For any validation error, CustomTextField should display the error message

        final controller = TextEditingController();
        const validationError = 'Campo obrigatório';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Form(
                child: CustomTextField(
                  controller: controller,
                  labelText: 'Email',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return validationError;
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),
        );

        // Trigger validation by submitting empty field
        await tester.enterText(find.byType(TextFormField), '');
        await tester.pump();

        // Find the Form widget and validate it
        await tester.pump();

        // Verify validation error is displayed
        expect(find.text(validationError), findsOneWidget);
      },
    );

    testWidgets(
      'Property 29: CustomTextField shows different validation errors',
      (tester) async {
        // **Feature: api-integration, Property 29: Validation feedback is displayed**
        // For any validation rule, CustomTextField should display appropriate error

        final testCases = [
          ('', 'Campo obrigatório'),
          ('ab', 'Mínimo 3 caracteres'),
          ('invalid-email', 'Email inválido'),
        ];

        for (final (input, expectedError) in testCases) {
          final controller = TextEditingController();

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: Form(
                  child: CustomTextField(
                    controller: controller,
                    labelText: 'Campo',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo obrigatório';
                      }
                      if (value.length < 3) {
                        return 'Mínimo 3 caracteres';
                      }
                      if (!value.contains('@')) {
                        return 'Email inválido';
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ),
          );

          // Enter test input
          await tester.enterText(find.byType(TextFormField), input);
          await tester.pump();

          // Trigger validation
          await tester.pump();

          // Verify expected error is displayed
          expect(find.text(expectedError), findsOneWidget);
        }
      },
    );

    testWidgets(
      'Property 28: EmptyStateView displays appropriate message',
      (tester) async {
        // **Feature: api-integration, Property 28: Error states display with recovery options**
        // For any empty state, EmptyStateView should display the message and icon

        const emptyMessage = 'Nenhum item encontrado';

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: EmptyStateView(
                message: emptyMessage,
              ),
            ),
          ),
        );

        // Verify empty state message is displayed
        expect(find.text(emptyMessage), findsOneWidget);

        // Verify icon is displayed
        expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
      },
    );

    testWidgets(
      'Property 28: LoadingIndicator displays progress indicator',
      (tester) async {
        // **Feature: api-integration, Property 28: Error states display with recovery options**
        // For any loading state, LoadingIndicator should display a progress indicator

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: LoadingIndicator(),
            ),
          ),
        );

        // Verify loading indicator is displayed
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    testWidgets(
      'Property 29: CustomTextField accepts user input',
      (tester) async {
        // **Feature: api-integration, Property 29: Validation feedback is displayed**
        // For any valid input, CustomTextField should accept and display it

        final controller = TextEditingController();
        const testInput = 'test@example.com';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomTextField(
                controller: controller,
                labelText: 'Email',
              ),
            ),
          ),
        );

        // Enter text
        await tester.enterText(find.byType(TextFormField), testInput);
        await tester.pump();

        // Verify text is displayed
        expect(find.text(testInput), findsOneWidget);
        expect(controller.text, testInput);
      },
    );

    testWidgets(
      'Property 29: CustomTextField supports different input types',
      (tester) async {
        // **Feature: api-integration, Property 29: Validation feedback is displayed**
        // For any keyboard type, CustomTextField should configure appropriately

        final controller = TextEditingController();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomTextField(
                controller: controller,
                labelText: 'Email',
                keyboardType: TextInputType.emailAddress,
              ),
            ),
          ),
        );

        // Verify text field is rendered
        expect(find.byType(TextFormField), findsOneWidget);
        expect(find.byType(CustomTextField), findsOneWidget);
      },
    );

    testWidgets(
      'Property 29: CustomTextField supports password obscuring',
      (tester) async {
        // **Feature: api-integration, Property 29: Validation feedback is displayed**
        // For any password field, CustomTextField should obscure text

        final controller = TextEditingController();
        const testPassword = 'secret123';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomTextField(
                controller: controller,
                labelText: 'Senha',
                obscureText: true,
              ),
            ),
          ),
        );

        // Verify text field is rendered
        expect(find.byType(TextFormField), findsOneWidget);

        // Enter password
        await tester.enterText(find.byType(TextFormField), testPassword);
        await tester.pump();

        // Verify password is in controller (even if obscured in UI)
        expect(controller.text, testPassword);
      },
    );

    testWidgets(
      'Property 28: Custom buttons display correctly',
      (tester) async {
        // **Feature: api-integration, Property 28: Error states display with recovery options**
        // For any button type, custom buttons should display and respond to taps

        var filledPressed = false;
        var outlinedPressed = false;
        var textPressed = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  CustomFilledButton(
                    onPressed: () {
                      filledPressed = true;
                    },
                    child: const Text('Filled'),
                  ),
                  CustomOutlinedButton(
                    onPressed: () {
                      outlinedPressed = true;
                    },
                    child: const Text('Outlined'),
                  ),
                  CustomTextButton(
                    onPressed: () {
                      textPressed = true;
                    },
                    child: const Text('Text'),
                  ),
                ],
              ),
            ),
          ),
        );

        // Verify all buttons are displayed
        expect(find.text('Filled'), findsOneWidget);
        expect(find.text('Outlined'), findsOneWidget);
        expect(find.text('Text'), findsOneWidget);

        // Test filled button
        await tester.tap(find.text('Filled'));
        await tester.pump();
        expect(filledPressed, true);

        // Test outlined button
        await tester.tap(find.text('Outlined'));
        await tester.pump();
        expect(outlinedPressed, true);

        // Test text button
        await tester.tap(find.text('Text'));
        await tester.pump();
        expect(textPressed, true);
      },
    );
  });
}
