import 'package:json_annotation/json_annotation.dart';
//import 'coupon_rule.dart';
//import 'voucher_model.dart';

//part 'merchant_reward_card_model.g.dart';

/// 商家優惠兌換類型
enum RewardExchangeType {
  /// 金額型（使用者輸入折抵金額，直接折抵不產生票券）
  @JsonValue('amount')
  amount,

  /// 張數型（使用者選擇兌換組數，兌換後產生票券）
  @JsonValue('quantity')
  quantity,

  /// 點數換點數型（使用者選擇兌換點數，兌換後產生商家點數）
  @JsonValue('points')
  points,
}
/*
/// 商家優惠卡片資料模型
///
/// ⚠️ DEPRECATED: This model is deprecated and kept only for backward compatibility
/// with exchange sheet widgets. New code should use CouponRule directly.
/// TODO: Refactor exchange sheets to use CouponRule and remove this class.
@Deprecated('Use CouponRule directly instead. This model will be removed in a future version.')
@JsonSerializable()
class MerchantRewardCardModel {
  final String merchantName;
  final String? rewardName;
  final String backgroundImageUrl;
  final String rewardType;
  final String exchangeRate;
  final RewardExchangeType exchangeType;
  final VoucherType? voucherType;
  final ExchangeFlowType exchangeFlowType;
  final String? exchangeAlert;
  final int? pointsPerSet;
  final int? maxSetsAvailable;
  final int? vouchersPerSet;
  final int? discountPerVoucher;
  final String? exchangeDescription;

  const MerchantRewardCardModel({
    required this.merchantName,
    this.rewardName,
    required this.backgroundImageUrl,
    required this.rewardType,
    required this.exchangeRate,
    this.exchangeType = RewardExchangeType.amount,
    this.voucherType,
    this.exchangeFlowType = ExchangeFlowType.directlyAvailableWallet,
    this.exchangeAlert,
    this.pointsPerSet,
    this.maxSetsAvailable,
    this.vouchersPerSet,
    this.discountPerVoucher,
    this.exchangeDescription,
  });

  /// Create from CouponRule for backward compatibility
  factory MerchantRewardCardModel.fromCouponRule(CouponRule couponRule) {
    return MerchantRewardCardModel(
      merchantName: couponRule.brandName,
      rewardName: couponRule.title,
      backgroundImageUrl: couponRule.cardImageUrl ?? '',
      rewardType: couponRule.displayUnit,
      exchangeRate: couponRule.exchangeDisplayText.isNotEmpty
          ? couponRule.exchangeDisplayText
          : '${couponRule.unitPrice}點 = 1${couponRule.displayUnit}',
      exchangeType: couponRule.exchangeInputType == ExchangeInputType.quantityBased
          ? RewardExchangeType.quantity
          : RewardExchangeType.amount,
      voucherType: _mapVoucherType(couponRule),
      exchangeFlowType: couponRule.exchangeFlowType,
      exchangeAlert: couponRule.exchangeAlert,
      pointsPerSet: couponRule.unitPrice,
      maxSetsAvailable: couponRule.maxPerExchangeCount,
      vouchersPerSet: 1, // Default value
      discountPerVoucher: couponRule.unitPrice,
      exchangeDescription: couponRule.shortNotice,
    );
  }

  static VoucherType? _mapVoucherType(CouponRule couponRule) {
    switch (couponRule.assetRedeemType) {
      case AssetRedeemType.scanToRedeem:
        return VoucherType.qrCodePos;
      case AssetRedeemType.copyCode:
        if (couponRule.exchangeFlowType == ExchangeFlowType.branchCodeUsed ||
            couponRule.exchangeFlowType == ExchangeFlowType.branchCodeUsedDisplay) {
          return VoucherType.verificationCodeWithQRCode;
        }
        return VoucherType.verificationCode;
      case AssetRedeemType.none:
        return VoucherType.redemptionCode;
    }
  }

  factory MerchantRewardCardModel.fromJson(Map<String, dynamic> json) =>
      _$MerchantRewardCardModelFromJson(json);

  Map<String, dynamic> toJson() => _$MerchantRewardCardModelToJson(this);
}
*/