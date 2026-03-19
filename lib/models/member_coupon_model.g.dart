// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_coupon_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberCouponModel _$MemberCouponModelFromJson(Map<String, dynamic> json) =>
    MemberCouponModel(
      memberCouponId: json['memberCouponId'] as String,
      couponRuleId: json['couponRuleId'] as String,
      currentStatus: $enumDecode(
        _$MemberCouponStatusEnumMap,
        json['currentStatus'],
      ),
      syncAction: $enumDecode(_$SyncActionEnumMap, json['syncAction']),
      issuedAt: json['issuedAt'] as String,
      useStartAt: json['useStartAt'] as String,
      expiredAt: json['expiredAt'] as String?,
      usedAt: json['usedAt'] as String?,
      canceledAt: json['canceledAt'] as String?,
      revokedAt: json['revokedAt'] as String?,
      lastUpdatedAt: json['lastUpdatedAt'] as String,
      redemptionCredentials: (json['redemptionCredentials'] as List<dynamic>)
          .map(
            (e) =>
                RedemptionCredentialModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      exchangeUnits: (json['exchangeUnits'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MemberCouponModelToJson(MemberCouponModel instance) =>
    <String, dynamic>{
      'memberCouponId': instance.memberCouponId,
      'couponRuleId': instance.couponRuleId,
      'currentStatus': _$MemberCouponStatusEnumMap[instance.currentStatus]!,
      'syncAction': _$SyncActionEnumMap[instance.syncAction]!,
      'issuedAt': instance.issuedAt,
      'useStartAt': instance.useStartAt,
      'expiredAt': instance.expiredAt,
      'usedAt': instance.usedAt,
      'canceledAt': instance.canceledAt,
      'revokedAt': instance.revokedAt,
      'lastUpdatedAt': instance.lastUpdatedAt,
      'redemptionCredentials': instance.redemptionCredentials,
      'exchangeUnits': instance.exchangeUnits,
    };

const _$MemberCouponStatusEnumMap = {
  MemberCouponStatus.unavailable: 'UNAVAILABLE',
  MemberCouponStatus.active: 'ACTIVE',
  MemberCouponStatus.used: 'USED',
  MemberCouponStatus.expired: 'EXPIRED',
  MemberCouponStatus.revoked: 'REVOKED',
  MemberCouponStatus.holding: 'HOLDING',
  MemberCouponStatus.canceled: 'CANCELED',
};

const _$SyncActionEnumMap = {
  SyncAction.upsert: 'UPSERT',
  SyncAction.delete: 'DELETE',
};
