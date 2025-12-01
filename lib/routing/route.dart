import 'package:firebase_ai_testing/config/dependencies.dart';
import 'package:firebase_ai_testing/data/services/model/expense_model.dart';
import 'package:firebase_ai_testing/routing/routes.dart';
import 'package:firebase_ai_testing/ui/camera_preview/widget/camera_preview_screen.dart';
import 'package:firebase_ai_testing/ui/expense/widget/expense_screen.dart';
import 'package:firebase_ai_testing/ui/home/widgets/home_screen.dart';
import 'package:go_router/go_router.dart';

class Router {
  Router._();

  static final router = GoRouter(
    initialLocation: Routes.home,
    routes: [
      GoRoute(
        name: Routes.home,
        path: Routes.home,
        builder: (context, state) {
          return const HomeScreen();
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
    ],
  );
}
