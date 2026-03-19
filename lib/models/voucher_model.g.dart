// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voucher_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VoucherModel _$VoucherModelFromJson(Map<String, dynamic> json) => VoucherModel(
  id: json['id'] as String,
  type: $enumDecode(_$VoucherTypeEnumMap, json['type']),
  status: $enumDecode(_$VoucherStatusEnumMap, json['status']),
  merchantName: json['merchantName'] as String,
  description: json['description'] as String,
  discountAmount: (json['discountAmount'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  expiresAt: json['expiresAt'] == null
      ? null
      : DateTime.parse(json['expiresAt'] as String),
  usedAt: json['usedAt'] == null
      ? null
      : DateTime.parse(json['usedAt'] as String),
  qrCodeData: json['qrCodeData'] as String?,
  barcodeData: json['barcodeData'] as String?,
  verificationCode: json['verificationCode'] as String?,
  redemptionCode: json['redemptionCode'] as String?,
  usageInstructions: json['usageInstructions'] as String?,
  couponRuleId: json['couponRuleId'] as String?,
);

Map<String, dynamic> _$VoucherModelToJson(VoucherModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$VoucherTypeEnumMap[instance.type]!,
      'status': _$VoucherStatusEnumMap[instance.status]!,
      'merchantName': instance.merchantName,
      'description': instance.description,
      'discountAmount': instance.discountAmount,
      'createdAt': instance.createdAt.toIso8601String(),
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'usedAt': instance.usedAt?.toIso8601String(),
      'qrCodeData': instance.qrCodeData,
      'barcodeData': instance.barcodeData,
      'verificationCode': instance.verificationCode,
      'redemptionCode': instance.redemptionCode,
      'usageInstructions': instance.usageInstructions,
      'couponRuleId': instance.couponRuleId,
    };

const _$VoucherTypeEnumMap = {
  VoucherType.qrCodePos: 'qr_code_pos',
  VoucherType.verificationCode: 'verification_code',
  VoucherType.verificationCodeWithQRCode: 'verification_code_with_qr_code',
  VoucherType.redemptionCode: 'redemption_code',
  VoucherType.ticketWithQrCode: 'ticket_with_qr_code',
  VoucherType.ticket: 'ticket',
};

const _$VoucherStatusEnumMap = {
  VoucherStatus.active: 'active',
  VoucherStatus.used: 'used',
  VoucherStatus.expired: 'expired',
};
