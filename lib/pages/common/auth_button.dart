import 'package:flutter/material.dart';
import '/constants/colors.dart';

/// Reusable button component for authentication pages
/// Provides consistent styling with orange (enabled) and gray (disabled) states
class AuthButton extends StatelessWidget {
  const AuthButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.isEnabled = true,
    this.isFullWidth = true,
  });

  final VoidCallback? onPressed;
  final String label;
  final bool isEnabled;
  final bool isFullWidth;

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed = isEnabled ? onPressed : null;

    final button = ElevatedButton(
      onPressed: effectiveOnPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isEnabled
            ? AppColors.loginButtonOrange
            : AppColors.loginButtonGray,
        disabledBackgroundColor: AppColors.loginButtonGray,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 0,
        minimumSize: isFullWidth ? const Size(double.infinity, 30) : null,
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    return isFullWidth
        ? SizedBox(
            width: double.infinity,
            child: button,
          )
        : button;
  }
}
