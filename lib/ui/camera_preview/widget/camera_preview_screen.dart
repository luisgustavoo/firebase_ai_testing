import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:firebase_ai_testing/routing/routes.dart';
import 'package:firebase_ai_testing/ui/camera_preview/view_models/camera_preview_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CameraPreviewScreen extends StatefulWidget {
  const CameraPreviewScreen({
    required CameraPreviewViewModel viewModel,
    super.key,
  }) : _viewModel = viewModel;

  final CameraPreviewViewModel _viewModel;

  @override
  State<CameraPreviewScreen> createState() => _CameraPreviewScreenState();
}

class _CameraPreviewScreenState extends State<CameraPreviewScreen>
    with WidgetsBindingObserver {
  CameraController? controller;
  XFile? imageFile;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    widget._viewModel.sendImageToAi.addListener(_listener);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final cameras = await availableCameras();
      _initializeCameraController(cameras[0]);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCameraController(cameraController.description);
    }
  }

  void _listener() {
    final sendToApi = widget._viewModel.sendImageToAi;
    if (sendToApi.error) {
      sendToApi.clearResult();
      _showInSnackBar('Erro ao analisar imagem');
      return;
    }
    if (sendToApi.completed) {
      if (!mounted) {
        return;
      }
      context.pushNamed(
        Routes.expense,
        extra: widget._viewModel.expenseModel,
      );
    }
  }

  Future<void> _initializeCameraController(
    CameraDescription cameraDescription,
  ) async {
    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    controller = cameraController;
    cameraController.addListener(() {
      if (mounted) {
        setState(() {});
      }
      if (cameraController.value.hasError) {
        _showInSnackBar(
          'Camera error ${cameraController.value.errorDescription}',
        );
      }
    });
    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      _showErroMessage(e);
    }
    if (mounted) {
      setState(() {});
    }
  }

  void _showErroMessage(CameraException e) {
    switch (e.code) {
      case 'CameraAccessDenied':
        _showInSnackBar('You have denied camera access.');
      case 'CameraAccessDeniedWithoutPrompt':
        _showInSnackBar('Please go to Settings app to enable camera access.');
      case 'CameraAccessRestricted':
        _showInSnackBar('Camera access is restricted.');
      case 'AudioAccessDenied':
        _showInSnackBar('You have denied audio access.');
      case 'AudioAccessDeniedWithoutPrompt':
        _showInSnackBar('Please go to Settings app to enable audio access.');
      case 'AudioAccessRestricted':
        _showInSnackBar('Audio access is restricted.');
      default:
        _showCameraException(e);
    }
  }

  void _showInSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showCameraException(CameraException e) {
    _logError(e.code, e.description);
    _showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  void _logError(String code, String? message) {
    log('Error: $code${message == null ? '' : '\nError Message: $message'}');
  }

  Widget _cameraPreviewWidget() {
    final CameraController? cameraController = controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      return const CircularProgressIndicator();
    }
    return ListenableBuilder(
      listenable: widget._viewModel.sendImageToAi,
      builder: (context, child) {
        if (widget._viewModel.sendImageToAi.running) {
          return const CircularProgressIndicator();
        }
        return child!;
      },
      child: CameraPreview(
        controller!,
      ),
    );
  }

  Widget _captureControlRowWidget() {
    final CameraController? cameraController = controller;
    return IconButton(
      icon: const Icon(
        Icons.camera_alt,
        size: 50,
      ),
      color: Theme.of(context).primaryColor,
      onPressed:
          cameraController != null && cameraController.value.isInitialized
          ? _onTakePictureButtonPressed
          : null,
    );
  }

  void _onTakePictureButtonPressed() {
    _takePicture().then((XFile? file) {
      if (mounted) {
        setState(() {
          imageFile = file;
        });
        if (file != null) {
          // _showInSnackBar('Picture saved to ${file.path}');
          widget._viewModel.sendImageToAi.execute(file.path);
        }
      }
    });
  }

  Future<XFile?> _takePicture() async {
    final CameraController? cameraController = controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      _showInSnackBar('Error: select a camera first.');
      return null;
    }
    if (cameraController.value.isTakingPicture) {
      return null;
    }
    try {
      final XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Camera example')),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Center(child: _cameraPreviewWidget()),
            ),
          ),
          SafeArea(child: _captureControlRowWidget()),
        ],
      ),
    );
  }
}
