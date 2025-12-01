import 'package:camera/camera.dart';
import 'package:firebase_ai_testing/ui/receipt_scanner/view_models/receipt_scanner_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ReceiptScannerScreen extends StatefulWidget {
  const ReceiptScannerScreen({
    required this.viewModel,
    super.key,
  });

  final ReceiptScannerViewModel viewModel;

  @override
  State<ReceiptScannerScreen> createState() => _ReceiptScannerScreenState();
}

class _ReceiptScannerScreenState extends State<ReceiptScannerScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.initializeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear Recibo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, child) {
          if (!widget.viewModel.isCameraInitialized) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Stack(
            children: [
              // Camera preview
              Positioned.fill(
                child: CameraPreview(widget.viewModel.cameraController!),
              ),

              // Overlay with instructions
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: const Text(
                    'Posicione o recibo dentro do quadro',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              // Frame overlay
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.6,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              // Capture button
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Center(
                  child: widget.viewModel.captureAndAnalyzeCommand.running
                      ? const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(
                              color: Colors.white,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Analisando recibo...',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        )
                      : FloatingActionButton.large(
                          onPressed: _captureReceipt,
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          child: const Icon(
                            Icons.camera_alt,
                            size: 32,
                          ),
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _captureReceipt() async {
    await widget.viewModel.captureAndAnalyzeCommand.execute();

    if (!mounted) {
      return;
    }

    // Check command result
    if (widget.viewModel.captureAndAnalyzeCommand.completed) {
      final transaction = widget.viewModel.createdTransaction;
      if (transaction != null) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Despesa criada: ${transaction.description ?? "Sem descrição"} - R\$ ${transaction.amount.toStringAsFixed(2)}',
            ),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate back to transactions screen
        context.go('/transactions');
      }
    } else if (widget.viewModel.captureAndAnalyzeCommand.error) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao processar recibo. Tente novamente.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
