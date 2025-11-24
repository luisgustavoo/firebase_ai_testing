import 'package:firebase_ai_testing/data/services/firebase_ai_service.dart';
import 'package:firebase_ai_testing/data/services/model/expense_model.dart';
import 'package:firebase_ai_testing/utils/result.dart';
import 'package:injectable/injectable.dart';

@injectable
class FirebaseAiRepository {
  FirebaseAiRepository({required FirebaseAiService aiService})
    : _aiService = aiService;

  final FirebaseAiService _aiService;

  Future<Result<ExpenseModel>> sendImageToAi(String file) async {
    final result = await _aiService.sendImageToAi(file);
    switch (result) {
      case Ok():
        return Result.ok(result.value);
      case Error():
        return Result.error(result.error);
    }
  }
}
