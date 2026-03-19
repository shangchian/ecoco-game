// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'points_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PointsHistory _$PointsHistoryFromJson(Map<String, dynamic> json) =>
    PointsHistory(
      id: (json['id'] as num?)?.toInt(),
      sourceId: (json['source_id'] as num?)?.toInt(),
      siteName: json['site_name'] as String?,
      aluCount: (json['alu_count'] as num?)?.toInt(),
      petCount: (json['pet_count'] as num?)?.toInt(),
      otherCount: (json['other_count'] as num?)?.toInt(),
      glassCount: (json['glass_count'] as num?)?.toInt(),
      hdpeCount: (json['hdpe_count'] as num?)?.toInt(),
      no1Count: (json['no_1_count'] as num?)?.toInt(),
      no2Count: (json['no_2_count'] as num?)?.toInt(),
      no3Count: (json['no_3_count'] as num?)?.toInt(),
      no4Count: (json['no_4_count'] as num?)?.toInt(),
      no5Count: (json['no_5_count'] as num?)?.toInt(),
      no6Count: (json['no_6_count'] as num?)?.toInt(),
      no9vCount: (json['no_9v_count'] as num?)?.toInt(),
      noBCount: (json['no_b_count'] as num?)?.toInt(),
      points: (json['points'] as num?)?.toInt(),
      transactionAt: json['transaction_at'] as String?,
    );

Map<String, dynamic> _$PointsHistoryToJson(PointsHistory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'source_id': instance.sourceId,
      'site_name': instance.siteName,
      'alu_count': instance.aluCount,
      'pet_count': instance.petCount,
      'other_count': instance.otherCount,
      'glass_count': instance.glassCount,
      'hdpe_count': instance.hdpeCount,
      'no_1_count': instance.no1Count,
      'no_2_count': instance.no2Count,
      'no_3_count': instance.no3Count,
      'no_4_count': instance.no4Count,
      'no_5_count': instance.no5Count,
      'no_6_count': instance.no6Count,
      'no_9v_count': instance.no9vCount,
      'no_b_count': instance.noBCount,
      'points': instance.points,
      'transaction_at': instance.transactionAt,
    };
