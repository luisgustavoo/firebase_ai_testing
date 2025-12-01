import 'package:firebase_ai_testing/config/dependencies.dart';
import 'package:firebase_ai_testing/data/services/model/expense_model.dart';
import 'package:firebase_ai_testing/routing/routes.dart';
import 'package:firebase_ai_testing/ui/auth/widgets/login_screen.dart';
import 'package:firebase_ai_testing/ui/auth/widgets/register_screen.dart';
import 'package:firebase_ai_testing/ui/camera_preview/widget/camera_preview_screen.dart';
import 'package:firebase_ai_testing/ui/category/category.dart';
import 'package:firebase_ai_testing/ui/expense/widget/expense_screen.dart';
import 'package:firebase_ai_testing/ui/home/home.dart';
import 'package:firebase_ai_testing/ui/transaction/transaction.dart';
import 'package:go_router/go_router.dart';

class Router {
  Router._();

  static final router = GoRouter(
    initialLocation: Routes.home,
    routes: [
      GoRoute(
        name: Routes.login,
        path: Routes.login,
        builder: (context, state) {
          return LoginScreen(viewModel: getIt());
        },
      ),
      GoRoute(
        name: Routes.register,
        path: Routes.register,
        builder: (context, state) {
          return RegisterScreen(viewModel: getIt());
        },
      ),
      GoRoute(
        name: Routes.home,
        path: Routes.home,
        builder: (context, state) {
          return HomeScreen(viewModel: getIt());
        },
      ),
      GoRoute(
        name: Routes.cameraPreview,
        path: Routes.cameraPreview,
        builder: (context, state) {
          return CameraPreviewScreen(viewModel: getIt());
        },
      ),
      GoRoute(
        name: Routes.expense,
        path: Routes.expense,
        builder: (context, state) {
          final expenseModel = state.extra! as ExpenseModel;
          return ExpenseScreen(expenseModel: expenseModel);
        },
      ),
      GoRoute(
        name: Routes.categories,
        path: Routes.categories,
        builder: (context, state) {
          return CategoriesScreen(viewModel: getIt());
        },
      ),
      GoRoute(
        name: Routes.transactions,
        path: Routes.transactions,
        builder: (context, state) {
          return TransactionsScreen(viewModel: getIt());
        },
      ),
      GoRoute(
        name: Routes.addTransaction,
        path: Routes.addTransaction,
        builder: (context, state) {
          return AddTransactionScreen(viewModel: getIt());
        },
      ),
    ],
  );
}
