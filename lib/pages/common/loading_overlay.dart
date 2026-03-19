import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '/constants/colors.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(60, 0, 0, 0),
      child: Center(
        child: LoadingAnimationWidget.staggeredDotsWave(
          color: AppColors.primaryHighlightColor,
          size: 60,
        ),
      ),
    );
  }
}
