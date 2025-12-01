import 'package:flutter/material.dart';

/// Loading indicator widget with Material 3 styling
///
/// Displays a circular progress indicator centered on the screen.
/// Uses Material 3 design guidelines for consistent appearance.
class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
