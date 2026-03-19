import 'package:json_annotation/json_annotation.dart';

part 'points_history_model.g.dart';

@JsonSerializable(includeIfNull: true)
class PointsHistory {
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "source_id")
  final int? sourceId;
  @JsonKey(name: "site_name")
  final String? siteName;
  @JsonKey(name: "alu_count")
  final int? aluCount;
  @JsonKey(name: "pet_count")
  final int? petCount;
  @JsonKey(name: "other_count")
  final int? otherCount;
  @JsonKey(name: "glass_count")
  final int? glassCount;
  @JsonKey(name: "hdpe_count")
  final int? hdpeCount;
  @JsonKey(name: "no_1_count")
  final int? no1Count;
  @JsonKey(name: "no_2_count")
  final int? no2Count;
  @JsonKey(name: "no_3_count")
  final int? no3Count;
  @JsonKey(name: "no_4_count")
  final int? no4Count;
  @JsonKey(name: "no_5_count")
  final int? no5Count;
  @JsonKey(name: "no_6_count")
  final int? no6Count;
  @JsonKey(name: "no_9v_count")
  final int? no9vCount;
  @JsonKey(name: "no_b_count")
  final int? noBCount;
  final int? points;
  @JsonKey(name: "transaction_at")
  final String? transactionAt;

  PointsHistory({
    this.id,
    this.sourceId,
    this.siteName,
    this.aluCount,
    this.petCount,
    this.otherCount,
    this.glassCount,
    this.hdpeCount,
    this.no1Count,
    this.no2Count,
    this.no3Count,
    this.no4Count,
    this.no5Count,
    this.no6Count,
    this.no9vCount,
    this.noBCount,
    this.points,
    this.transactionAt,
  });

  factory PointsHistory.fromJson(Map<String, dynamic> json) =>
      _$PointsHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$PointsHistoryToJson(this);

  // 方便判斷來源類型的getter
  String get sourceType {
    switch (sourceId) {
      case 1:
        return '投瓶機';
      case 2:
        return '投電池機';
      case 3:
        return '台塑補充站';
      case 4:
        return '員工投瓶獎勵';
      case 5:
        return '點數異常補點';
      default:
        return '未知來源';
    }
  }

  String get name {
    switch (sourceId) {
      case 1:
      case 2:
        return siteName ?? "未知機台";
      case 3:
        return '台塑便利家綠消費獎勵';
      case 4:
        return '員工投瓶獎勵';
      case 5:
        return '補點${siteName != null && siteName!.isNotEmpty ? " - $siteName" : ""}';
      default:
        return '未知來源';
    }
  }
}
