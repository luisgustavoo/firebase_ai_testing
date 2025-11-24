import 'dart:developer';
import 'package:firebase_ai_testing/data/repositories/firebase_ai_repository.dart';
import 'package:firebase_ai_testing/data/services/model/expense_model.dart';
import 'package:firebase_ai_testing/utils/command.dart';
import 'package:firebase_ai_testing/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class CameraPreviewViewModel extends ChangeNotifier {
  CameraPreviewViewModel({required FirebaseAiRepository firebaseAiRepository})
    : _firebaseAiRepository = firebaseAiRepository;

  @postConstruct
  void init() {
    sendImageToAi = Command1(_sendImageToAi);
  }

  final FirebaseAiRepository _firebaseAiRepository;
  late final Command1<void, String> sendImageToAi;
  ExpenseModel? expenseModel;

  Future<Result<void>> _sendImageToAi(String file) async {
    final result = await _firebaseAiRepository.sendImageToAi(file);
    switch (result) {
      case Ok():
        expenseModel = result.value;
        notifyListeners();
        return Result.ok(null);
      case Error():
        log('Erro ao analisar imagem');
        return Result.error(result.error);
    }
  }
}
