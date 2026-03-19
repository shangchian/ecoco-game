// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'redemption_credential_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RedemptionCredentialModel _$RedemptionCredentialModelFromJson(
  Map<String, dynamic> json,
) => RedemptionCredentialModel(
  type: $enumDecode(_$CredentialTypeEnumMap, json['type']),
  title: json['title'] as String?,
  value: json['value'] as String?,
  showValue: json['showValue'] as bool,
);

Map<String, dynamic> _$RedemptionCredentialModelToJson(
  RedemptionCredentialModel instance,
) => <String, dynamic>{
  'type': _$CredentialTypeEnumMap[instance.type]!,
  'title': instance.title,
  'value': instance.value,
  'showValue': instance.showValue,
};

const _$CredentialTypeEnumMap = {
  CredentialType.barcode: 'BARCODE',
  CredentialType.qrCode: 'QR_CODE',
  CredentialType.textCode: 'TEXT_CODE',
};
