import 'package:flutter/material.dart';

class StepProgressIndicator extends StatelessWidget {
  final int currentStep;
  final List<String> labels;

  const StepProgressIndicator({
    super.key,
    required this.currentStep,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(labels.length * 2 - 1, (index) {
          if (index.isEven) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _ProgressDot(isActive: currentStep >= index ~/ 2),
                const SizedBox(height: 8), // 點與標籤的間距
                Align(
                  alignment: Alignment.center,
                    child: Text(
                      labels[index ~/ 2], // 獲取對應標籤
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Transform.translate(
                  offset: const Offset(0, -13), // 調整線段的垂直位置，負值向上移
                  child: _ProgressLine(isActive: currentStep >= (index + 1) ~/ 2),
                ),
              ),
            );
          }
        }),
      ),
    );
  }
}

class ProgressDots extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const ProgressDots({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps * 2 - 1, (index) {
        if (index.isEven) {
          return _ProgressDot(isActive: currentStep >= index ~/ 2);
        }
        return _ProgressLine(isActive: currentStep >= (index + 1) ~/ 2);
      }),
    );
  }
}

class ProgressLabels extends StatelessWidget {
  final List<String> labels;

  const ProgressLabels({
    super.key,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Colors.grey[600],
          fontSize: 12,
        );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: labels.map((label) => 
        Expanded(
          child: Text(
            label,
            style: textStyle,
            textAlign: TextAlign.center,
          ),
        ),
      ).toList(),
    );
  }
}

class _ProgressDot extends StatelessWidget {
  final bool isActive;
  
  const _ProgressDot({required this.isActive});

  @override
  Widget build(BuildContext context) {    
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Colors.black : Colors.grey[300],
        border: Border.all(
          color: isActive ? Colors.black : Colors.grey[400]!,
          width: 2,
        ),
      ),
      child: null,
    );
  }
}

class _ProgressLine extends StatelessWidget {
  final bool isActive;

  const _ProgressLine({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: isActive ? Colors.black : Colors.grey[300],
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }
} 