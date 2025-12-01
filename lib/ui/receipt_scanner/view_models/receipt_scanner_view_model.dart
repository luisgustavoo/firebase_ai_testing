import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:firebase_ai_testing/data/repositories/firebase_ai_repository.dart';
import 'package:firebase_ai_testing/domain/models/transaction.dart';
import 'package:firebase_ai_testing/utils/command.dart';
import 'package:firebase_ai_testing/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@injectable
class ReceiptScannerViewModel extends ChangeNotifier {
  ReceiptScannerViewModel(this._firebaseAiRepository) {
    captureAndAnalyzeCommand = Command0(_captureAndAnalyze);
  }

  final FirebaseAiRepository _firebaseAiRepository;

  CameraController? _cameraController;
  CameraController? get cameraController => _cameraController;

  bool _isCameraInitialized = false;
  bool get isCameraInitialized => _isCameraInitialized;

  Transaction? _createdTransaction;
  Transaction? get createdTransaction => _createdTransaction;

  late Command0<Transaction> captureAndAnalyzeCommand;

  /// Initialize camera
  Future<void> initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        log('No cameras available');
        return;
      }

      // Use back camera for receipt scanning
      final camera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _cameraController!.initialize();
      _isCameraInitialized = true;
      notifyListeners();
    } on Exception catch (e) {
      log('Error initializing camera: $e');
    }
  }

  /// Capture photo and analyze with AI
  Future<Result<Transaction>> _captureAndAnalyze() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Result.error(Exception('Câmera não inicializada'));
    }

    try {
      // Capture image
      final image = await _cameraController!.takePicture();
      log('Image captured: ${image.path}');

      // Extract expense data from receipt using AI
      final extractResult = await _firebaseAiRepository
          .extractExpenseFromReceipt(image.path);

      switch (extractResult) {
        case Ok(:final value):
          final extracted = value;

          // Create transaction from extracted data
          final createResult = await _firebaseAiRepository
              .createTransactionFromExtractedExpense(extracted);

          switch (createResult) {
            case Ok(:final value):
              _createdTransaction = value;
              notifyListeners();
              return Result.ok(_createdTransaction!);

            case Error(:final error):
              return Result.error(error);
          }

        case Error(:final error):
          return Result.error(error);
      }
    } on Exception catch (e) {
      log('Error capturing and analyzing receipt: $e');
      return Result.error(e);
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }
}
