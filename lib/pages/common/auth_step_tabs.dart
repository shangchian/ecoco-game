import 'package:flutter/material.dart';
import '/constants/colors.dart';

/// Custom tab-style step indicator for authentication flows
/// Shows horizontal tabs with active/inactive states
class AuthStepTabs extends StatelessWidget {
  const AuthStepTabs({
    super.key,
    required this.steps,
    required this.currentStep,
  });

  final List<String> steps;
  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal:24, vertical: 16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.tabBackground,
          borderRadius: BorderRadius.circular(100),
        ),
        padding: const EdgeInsets.all(4),
        child: Row(
          children: List.generate(steps.length * 2 - 1, (index) {
            // Odd indices are spacers
            if (index.isOdd) {
              return const SizedBox(width: 8);
            }

            final stepIndex = index ~/ 2;
            final isActive = stepIndex == currentStep;
            final isPassed = stepIndex < currentStep;

            return Expanded(
              child: _StepTab(
                label: steps[stepIndex],
                isActive: isActive,
                isPassed: isPassed,
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _StepTab extends StatelessWidget {
  const _StepTab({
    required this.label,
    required this.isActive,
    required this.isPassed,
  });

  final String label;
  final bool isActive;
  final bool isPassed;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isActive
        ? AppColors.loginButtonOrange
        : AppColors.tabBackground;

    final textColor = isActive ? Colors.white : AppColors.loginButtonGray;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 1),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
