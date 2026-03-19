import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '/constants/colors.dart';

/// Full-screen overlay shown during app initialization
/// Displays a loading animation without detailed progress
class InitializationOverlay extends StatelessWidget {
  const InitializationOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Container(
        color: const Color.fromARGB(60, 0, 0, 0),
        child: Center(
          child: LoadingAnimationWidget.staggeredDotsWave(
            color: AppColors.primaryHighlightColor,
            size: 60,
          ),
        ),
      ),
    );
  }
}
