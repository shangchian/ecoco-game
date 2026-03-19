import 'package:ecoco_app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'ecoco_icon.dart';

/// ECOCO 點數徽章元件
/// 用於顯示使用者的 ECOCO 點數，支援三種樣式變體
class EcocoPointsBadge extends StatelessWidget {
  /// 點數值
  final int points;

  /// 樣式變體
  /// - 'detailed': 詳細樣式（帶陰影、顯示「點」字、使用實心圖示）- 用於 UserPointsHeader
  /// - 'compact': 簡潔樣式（無陰影、不顯示「點」字、使用描邊圖示）- 用於 AppBar
  /// - 'large': 大號樣式（無背景、大尺寸、顯示「點」字）- 用於 PointsHistoryPage
  final EcocoPointsBadgeVariant variant;

  /// 是否顯示「點」字後綴（僅在 detailed 變體時有效）
  final bool showSuffix;

  /// 外部邊距
  final EdgeInsetsGeometry? margin;

  const EcocoPointsBadge({
    super.key,
    required this.points,
    this.variant = EcocoPointsBadgeVariant.compact,
    this.showSuffix = true,
    this.margin,
  });

  /// 詳細樣式 - 用於 UserPointsHeader
  const EcocoPointsBadge.detailed({
    super.key,
    required this.points,
    this.margin,
  }) : variant = EcocoPointsBadgeVariant.detailed,
       showSuffix = true;

  /// 簡潔樣式 - 用於 AppBar
  const EcocoPointsBadge.compact({super.key, required this.points, this.margin})
    : variant = EcocoPointsBadgeVariant.compact,
      showSuffix = false;

  /// 大號樣式 - 用於 PointsHistoryPage
  const EcocoPointsBadge.large({super.key, required this.points, this.margin})
    : variant = EcocoPointsBadgeVariant.large,
      showSuffix = true;

  @override
  Widget build(BuildContext context) {
    final isDetailed = variant == EcocoPointsBadgeVariant.detailed;
    final isLarge = variant == EcocoPointsBadgeVariant.large;

    // 禁用系統字體縮放，保持固定樣式
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
      child: _buildContent(isDetailed, isLarge),
    );
  }

  Widget _buildContent(bool isDetailed, bool isLarge) {
    // Large 變體：無背景容器，直接返回 Row
    if (isLarge) {
      return Container(
        margin:
            const EdgeInsets.only(right: 16),
        padding: EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 0,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.transparent,
            width: 1,
          ),
          color: Colors.white,
          borderRadius: BorderRadius.circular(isDetailed ? 24 : 20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 圖示
            EcocoIcon(
              size: 28,
              color: AppColors.primaryHighlightColor,
            ),

            SizedBox(width:2),

            // 點數數字
            Flexible(child: FittedBox(fit: BoxFit.scaleDown, child: Text(
              "${points.toString()} 點",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.secondaryValueColor,
                textBaseline: TextBaseline.alphabetic,
                height: 1.2,
              ),
            ))),
          ],
        ),
      );
    }

    return Container(
      height: 30,
      margin:
          margin ??
          (isDetailed
              ? const EdgeInsets.only(right: 16)
              : const EdgeInsets.only(right: 16)),
      padding: EdgeInsets.symmetric(
        horizontal: isDetailed ? 4 : 8,
        vertical: isDetailed ? 0 : 0,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: isDetailed ? Colors.transparent : Colors.black,
          width: 1,
        ),
        color: isDetailed ? Colors.white : AppColors.backgroundYellow,
        borderRadius: BorderRadius.circular(isDetailed ? 24 : 20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 圖示
          EcocoIcon(
            size: 20,
            color: isDetailed
                ? AppColors.primaryHighlightColor
                : Colors.black,
          ),

          SizedBox(width: 10),

          // 點數數字
          Text(
            points.toString(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: isDetailed
                  ? Color(0xFF808080)
                  : Colors.black,
              height: 1.2,
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
    );
  }
}

/// ECOCO 點數徽章樣式變體
enum EcocoPointsBadgeVariant {
  /// 詳細樣式（帶陰影、顯示「點」字、使用實心圖示）
  detailed,

  /// 簡潔樣式（無陰影、不顯示「點」字、使用描邊圖示）
  compact,

  /// 大號樣式（無背景、大尺寸、顯示「點」字）
  large,
}
