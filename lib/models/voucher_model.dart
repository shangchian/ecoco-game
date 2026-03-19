import 'package:json_annotation/json_annotation.dart';

part 'voucher_model.g.dart';

/// 票券類型
enum VoucherType {
  /// QR碼/條碼票券（店家掃描）
  @JsonValue('qr_code_pos')
  qrCodePos,

  /// 核銷碼票券（店家輸入）
  @JsonValue('verification_code')
  verificationCode,

  /// 核銷碼票券（店家輸入後顯示QR碼）
  @JsonValue('verification_code_with_qr_code')
  verificationCodeWithQRCode,

  /// 兌換碼票券（使用者可複製）
  @JsonValue('redemption_code')
  redemptionCode,

  /// QRCode 型票券（顯示說明後出示條碼）
  @JsonValue('ticket_with_qr_code')
  ticketWithQrCode,

  /// 現場型票券（僅顯示資訊）
  @JsonValue('ticket')
  ticket,
}

/// 票券狀態
enum VoucherStatus {
  /// 有效可用
  @JsonValue('active')
  active,

  /// 已使用
  @JsonValue('used')
  used,

  /// 已過期
  @JsonValue('expired')
  expired,
}

/// 票券基本資料模型
@JsonSerializable()
class VoucherModel {
  /// 票券 ID
  final String id;

  /// 票券類型
  final VoucherType type;

  /// 票券狀態
  final VoucherStatus status;

  /// 商家名稱
  final String merchantName;

  /// 票券說明（例如：「可折抵50元」）
  final String description;

  /// 折抵金額
  final int discountAmount;

  /// 建立時間
  final DateTime createdAt;

  /// 過期時間（null 表示無期限）
  final DateTime? expiresAt;

  /// 使用時間（null 表示尚未使用）
  final DateTime? usedAt;

  /// QR碼內容（qrCodePos 專用）
  final String? qrCodeData;

  /// 條碼內容（qrCodePos 專用）
  final String? barcodeData;

  /// 核銷碼（verificationCode 專用）
  final String? verificationCode;

  /// 兌換碼（redemptionCode 專用）
  final String? redemptionCode;

  /// 使用說明
  final String? usageInstructions;

  /// 關聯的 CouponRule ID（用於導航到詳細頁面）
  final String? couponRuleId;

  const VoucherModel({
    required this.id,
    required this.type,
    required this.status,
    required this.merchantName,
    required this.description,
    required this.discountAmount,
    required this.createdAt,
    this.expiresAt,
    this.usedAt,
    this.qrCodeData,
    this.barcodeData,
    this.verificationCode,
    this.redemptionCode,
    this.usageInstructions,
    this.couponRuleId,
  });

  factory VoucherModel.fromJson(Map<String, dynamic> json) =>
      _$VoucherModelFromJson(json);

  Map<String, dynamic> toJson() => _$VoucherModelToJson(this);

  VoucherModel copyWith({
    String? id,
    VoucherType? type,
    VoucherStatus? status,
    String? merchantName,
    String? description,
    int? discountAmount,
    DateTime? createdAt,
    DateTime? expiresAt,
    DateTime? usedAt,
    String? qrCodeData,
    String? barcodeData,
    String? verificationCode,
    String? redemptionCode,
    String? usageInstructions,
    String? couponRuleId,
  }) {
    return VoucherModel(
      id: id ?? this.id,
      type: type ?? this.type,
      status: status ?? this.status,
      merchantName: merchantName ?? this.merchantName,
      description: description ?? this.description,
      discountAmount: discountAmount ?? this.discountAmount,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      usedAt: usedAt ?? this.usedAt,
      qrCodeData: qrCodeData ?? this.qrCodeData,
      barcodeData: barcodeData ?? this.barcodeData,
      verificationCode: verificationCode ?? this.verificationCode,
      redemptionCode: redemptionCode ?? this.redemptionCode,
      usageInstructions: usageInstructions ?? this.usageInstructions,
      couponRuleId: couponRuleId ?? this.couponRuleId,
    );
  }

  /// 檢查票券是否已過期
  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  /// 檢查票券是否可用
  bool get isUsable {
    return status == VoucherStatus.active && !isExpired;
  }
}
