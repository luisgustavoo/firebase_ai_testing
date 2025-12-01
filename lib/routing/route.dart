import 'package:firebase_ai_testing/config/dependencies.dart';
import 'package:firebase_ai_testing/data/repositories/auth_repository.dart';
import 'package:firebase_ai_testing/routing/routes.dart';
import 'package:firebase_ai_testing/ui/auth/widgets/login_screen.dart';
import 'package:firebase_ai_testing/ui/auth/widgets/register_screen.dart';
import 'package:firebase_ai_testing/ui/category/category.dart';
import 'package:firebase_ai_testing/ui/home/home.dart';
import 'package:firebase_ai_testing/ui/receipt_scanner/widgets/receipt_scanner_screen.dart';
import 'package:firebase_ai_testing/ui/splash/widgets/splash_screen.dart';
import 'package:firebase_ai_testing/ui/transaction/transaction.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Router {
  Router._();

  static GoRouter router(AuthRepository authRepository) => GoRouter(
    initialLocation: Routes.splash,
    debugLogDiagnostics: true,
    redirect: (context, state) =>
        _handleRedirect(context, state, authRepository),
    refreshListenable: authRepository,
    routes: [
      // Splash screen - initial route
      GoRoute(
        name: Routes.splash,
        path: Routes.splash,
        pageBuilder: (context, state) => _buildPageWithTransition(
          context,
          state,
          SplashScreen(viewModel: getIt()),
        ),
      ),
      GoRoute(
        name: Routes.login,
        path: Routes.login,
        pageBuilder: (context, state) => _buildPageWithTransition(
          context,
          state,
          LoginScreen(viewModel: getIt()),
        ),
      ),
      GoRoute(
        name: Routes.register,
        path: Routes.register,
        pageBuilder: (context, state) => _buildPageWithTransition(
          context,
          state,
          RegisterScreen(viewModel: getIt()),
        ),
      ),
      GoRoute(
        name: Routes.home,
        path: Routes.home,
        pageBuilder: (context, state) => _buildPageWithTransition(
          context,
          state,
          HomeScreen(viewModel: getIt()),
        ),
      ),
      GoRoute(
        name: Routes.categories,
        path: Routes.categories,
        pageBuilder: (context, state) => _buildPageWithTransition(
          context,
          state,
          CategoriesScreen(viewModel: getIt()),
        ),
      ),
      GoRoute(
        name: Routes.transactions,
        path: Routes.transactions,
        pageBuilder: (context, state) => _buildPageWithTransition(
          context,
          state,
          TransactionsScreen(viewModel: getIt()),
        ),
      ),
      GoRoute(
        name: Routes.addTransaction,
        path: Routes.addTransaction,
        pageBuilder: (context, state) => _buildPageWithTransition(
          context,
          state,
          AddTransactionScreen(viewModel: getIt()),
        ),
      ),
      GoRoute(
        name: Routes.scanReceipt,
        path: Routes.scanReceipt,
        pageBuilder: (context, state) => _buildPageWithTransition(
          context,
          state,
          ReceiptScannerScreen(viewModel: getIt()),
        ),
      ),
    ],
  );

  /// Handle route guards and redirects
  ///
  /// Redirects to login if user is not authenticated and trying to access protected routes.
  /// Redirects to home if user is authenticated and trying to access auth routes.
  /// Allows splash screen to always be accessible.
  static Future<String?> _handleRedirect(
    BuildContext context,
    GoRouterState state,
    AuthRepository authRepository,
  ) async {
    // Allow splash screen to always be accessible
    if (state.matchedLocation == Routes.splash) {
      return null;
    }

    final isAuthenticated = await authRepository.isAuthenticated;
    final isAuthRoute =
        state.matchedLocation == Routes.login ||
        state.matchedLocation == Routes.register;

    // If not authenticated and trying to access protected route, redirect to login
    if (!isAuthenticated && !isAuthRoute) {
      return Routes.login;
    }

    // If authenticated and trying to access auth route, redirect to home
    if (isAuthenticated && isAuthRoute) {
      return Routes.home;
    }

    // No redirect needed
    return null;
  }

  /// Build page with smooth transition animation
  static Page<void> _buildPageWithTransition(
    BuildContext context,
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Fade transition
        return FadeTransition(
          opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
          child: child,
        );
      },
    );
  }
}
