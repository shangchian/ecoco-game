import 'package:flutter/material.dart';
import '/constants/colors.dart';

class HighlightedPickerItem extends StatelessWidget {
  final String text;
  final int itemIndex;
  final int selectedIndex;
  final TextStyle? baseStyle;

  const HighlightedPickerItem({
    super.key,
    required this.text,
    required this.itemIndex,
    required this.selectedIndex,
    this.baseStyle,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = itemIndex == selectedIndex;
    final textStyle = (baseStyle ?? const TextStyle(fontSize: 16)).copyWith(
      color: isSelected ? AppColors.primaryHighlightColor : null,
    );

    return Center(
      child: Text(
        text,
        style: textStyle,
      ),
    );
  }
}
