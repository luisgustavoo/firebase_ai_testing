import 'package:firebase_ai_testing/data/services/firebase_ai_service.dart';
import 'package:firebase_ai_testing/data/services/model/expense_model.dart';
import 'package:firebase_ai_testing/utils/result.dart';
import 'package:injectable/injectable.dart';

@injectable
class FirebaseAiRepository {
  FirebaseAiRepository({required FirebaseAiService aiService})
    : _firebaseAiService = aiService;

  final FirebaseAiService _firebaseAiService;

  Future<Result<ExpenseModel>> sendImageToAi(String file) async {
    final result = await _firebaseAiService.sendImageToAi(file);
    switch (result) {
      case Ok():
        return Result.ok(result.value);
      case Error():
        return Result.error(result.error);
    }
  }
}
