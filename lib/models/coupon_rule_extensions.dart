import 'coupon_rule.dart';
import 'merchant_reward_card_model.dart';
import 'voucher_model.dart';

/// 格式化數量與單位的顯示
/// 如果 displayUnit 是 $，放在數字前面
/// 否則放在數字後面
String formatQuantityWithUnit(int quantity, String displayUnit, {String defaultUnit = '組'}) {
  final unit = displayUnit.isEmpty ? defaultUnit : displayUnit;

  if (unit == '\$') {
    return '\$$quantity';
  }
  return '$quantity $unit';
}

/// Extension methods on CouponRule for UI-specific computed properties
extension CouponRuleUIExtension on CouponRule {

  /// Get formatted exchange rate display
  String get formattedExchangeRate {
    // Use pre-formatted text if available
    if (exchangeDisplayText.isNotEmpty) {
      return exchangeDisplayText;
    }

    // Fallback: Format from unit price
    return '$unitPrice點 = 1$displayUnit';
  }

  /// Check if this coupon should appear in featured section
  bool get isFeatured => isPremium && isActive && isInActivePeriod;

  /// Check if this coupon should appear in more offers section
  bool get isAvailable => isActive && isInActivePeriod;

  /// Map exchangeInputType to RewardExchangeType
  RewardExchangeType get rewardExchangeType {
    switch (exchangeInputType) {
      case ExchangeInputType.quantityBased:
        return RewardExchangeType.quantity;
      case ExchangeInputType.pointsConversion:
        return RewardExchangeType.points;
      case ExchangeInputType.amountDiscount:
        return RewardExchangeType.amount;
    }
  }

  /// Map assetRedeemType and exchangeFlowType to VoucherType
  /// This is a simplified mapping - adjust based on your business logic
  VoucherType? get voucherType {
    // For amount-based discounts, there's typically no voucher
    if (exchangeInputType == ExchangeInputType.amountDiscount) {
      return null;
    }

    // Map based on redemption type
    switch (assetRedeemType) {
      case AssetRedeemType.scanToRedeem:
        // QR code/POS based redemption
        return VoucherType.qrCodePos;
      case AssetRedeemType.copyCode:
        // Code-based redemption
        if (exchangeFlowType == ExchangeFlowType.branchCodeUsed ||
            exchangeFlowType == ExchangeFlowType.branchCodeUsedDisplay) {
          return VoucherType.verificationCodeWithQRCode;
        }
        return VoucherType.verificationCode;
      case AssetRedeemType.none:
        // Direct wallet or other flows
        return VoucherType.redemptionCode;
    }
  }
}
