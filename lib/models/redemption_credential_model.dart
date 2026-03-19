import 'package:json_annotation/json_annotation.dart';

part 'redemption_credential_model.g.dart';

enum CredentialType {
  @JsonValue('BARCODE')
  barcode,
  @JsonValue('QR_CODE')
  qrCode,
  @JsonValue('TEXT_CODE')
  textCode,
}

@JsonSerializable()
class RedemptionCredentialModel {
  final CredentialType type;
  final String? title;
  final String? value;
  final bool showValue;

  const RedemptionCredentialModel({
    required this.type,
    this.title,
    this.value,
    required this.showValue,
  });

  factory RedemptionCredentialModel.fromJson(Map<String, dynamic> json) =>
      _$RedemptionCredentialModelFromJson(json);

  Map<String, dynamic> toJson() => _$RedemptionCredentialModelToJson(this);
}
