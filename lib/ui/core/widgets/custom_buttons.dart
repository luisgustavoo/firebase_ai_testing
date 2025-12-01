import 'package:flutter/material.dart';

/// Custom filled button widget
///
/// Wrapper around FilledButton with consistent styling.
/// Uses Material 3 design guidelines.
class CustomFilledButton extends StatelessWidget {
  const CustomFilledButton({
    required this.onPressed,
    required this.child,
    this.icon,
    super.key,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    if (icon != null) {
      return FilledButton.icon(
        onPressed: onPressed,
        icon: icon,
        label: child,
      );
    }

    return FilledButton(
      onPressed: onPressed,
      child: child,
    );
  }
}

/// Custom outlined button widget
///
/// Wrapper around OutlinedButton with consistent styling.
/// Uses Material 3 design guidelines.
class CustomOutlinedButton extends StatelessWidget {
  const CustomOutlinedButton({
    required this.onPressed,
    required this.child,
    this.icon,
    super.key,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    if (icon != null) {
      return OutlinedButton.icon(
        onPressed: onPressed,
        icon: icon,
        label: child,
      );
    }

    return OutlinedButton(
      onPressed: onPressed,
      child: child,
    );
  }
}

/// Custom text button widget
///
/// Wrapper around TextButton with consistent styling.
/// Uses Material 3 design guidelines.
class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    required this.onPressed,
    required this.child,
    this.icon,
    super.key,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    if (icon != null) {
      return TextButton.icon(
        onPressed: onPressed,
        icon: icon,
        label: child,
      );
    }

    return TextButton(
      onPressed: onPressed,
      child: child,
    );
  }
}
