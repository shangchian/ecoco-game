import 'package:ecoco_app/constants/colors.dart';
import 'package:flutter/material.dart';

/// 圓形 Checkbox 元件
///
/// 提供類似 Radio Button 的視覺效果：
/// - 未選取：外圈細框（灰色邊框 + 白色背景）
/// - 已選取：外圈細框 + 填滿背景色 + 白色勾選圖示
///
/// 使用範例：
/// ```dart
/// CircularCheckbox(
///   value: isChecked,
///   onChanged: (newValue) {
///     setState(() {
///       isChecked = newValue ?? false;
///     });
///   },
/// )
/// ```
class CircularCheckbox extends StatelessWidget {
  /// 是否選中
  final bool value;

  /// 值改變時的回調函數
  final ValueChanged<bool>? onChanged;

  /// Checkbox 的大小（直徑）
  final double size;

  /// 選中時的顏色（外框和內圓顏色）
  final Color? activeColor;

  /// 未選中時的邊框顏色
  final Color? inactiveColor;

  /// 內部實心圓的顏色（如果不指定，則使用 activeColor）
  final Color? checkColor;

  /// 是否啟用（false 時無法點擊且顯示為灰色）
  final bool enabled;

  /// 邊框寬度
  final double borderWidth;

  const CircularCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.size = 24.0,
    this.activeColor,
    this.inactiveColor,
    this.checkColor,
    this.enabled = true,
    this.borderWidth = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    // 決定顏色
    final Color effectiveActiveColor =
        activeColor ?? AppColors.orangeBackground; // 預設橘色
    final Color effectiveInactiveColor =
        inactiveColor ?? Colors.grey.shade400;

    // 根據狀態決定邊框顏色
    final Color borderColor = !enabled
        ? Colors.grey.shade300
        : (value ? effectiveActiveColor : effectiveInactiveColor);

    // 背景顏色
    final Color backgroundColor = !enabled
        ? Colors.grey.shade100
        : (value ? effectiveActiveColor : Colors.white);

    return GestureDetector(
      onTap: enabled && onChanged != null ? () => onChanged!(!value) : null,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
          border: Border.all(
            color: borderColor,
            width: borderWidth,
          ),
        ),
        child: value
            ? Icon(
                Icons.check,
                color: enabled ? Colors.white : Colors.grey.shade400,
                size: size * 0.65,
              )
            : null,
      ),
    );
  }
}
