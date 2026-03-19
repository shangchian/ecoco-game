import 'package:json_annotation/json_annotation.dart';
import 'redemption_credential_model.dart';

part 'member_coupon_model.g.dart';

enum MemberCouponStatus {
  @JsonValue('UNAVAILABLE')
  unavailable,
  @JsonValue('ACTIVE')
  active,
  @JsonValue('USED')
  used,
  @JsonValue('EXPIRED')
  expired,
  @JsonValue('REVOKED')
  revoked,
  @JsonValue('HOLDING')
  holding,
  @JsonValue('CANCELED')
  canceled,
}

enum SyncAction {
  @JsonValue('UPSERT')
  upsert,
  @JsonValue('DELETE')
  delete,
}

@JsonSerializable()
class MemberCouponModel {
  final String memberCouponId;
  final String couponRuleId;
  final MemberCouponStatus currentStatus;
  final SyncAction syncAction;
  final String issuedAt;
  final String useStartAt;
  final String? expiredAt;
  final String? usedAt;
  final String? canceledAt;
  final String? revokedAt;
  final String lastUpdatedAt;
  final List<RedemptionCredentialModel> redemptionCredentials;
  final int? exchangeUnits;

  const MemberCouponModel({
    required this.memberCouponId,
    required this.couponRuleId,
    required this.currentStatus,
    required this.syncAction,
    required this.issuedAt,
    required this.useStartAt,
    this.expiredAt,
    this.usedAt,
    this.canceledAt,
    this.revokedAt,
    required this.lastUpdatedAt,
    required this.redemptionCredentials,
    this.exchangeUnits,
  });

  factory MemberCouponModel.fromJson(Map<String, dynamic> json) =>
      _$MemberCouponModelFromJson(json);

  Map<String, dynamic> toJson() => _$MemberCouponModelToJson(this);
}
