import 'package:json_annotation/json_annotation.dart';
import '/utils/timezone_helper.dart';

part 'otp_rate_limit_data.g.dart';

@JsonSerializable()
class OtpRateLimitData {
  final int count;
  final String lastResetDate;
  final String timezone;

  OtpRateLimitData({
    required this.count,
    required this.lastResetDate,
    required this.timezone,
  });

  /// 創建初始的限制數據
  factory OtpRateLimitData.fresh() {
    return OtpRateLimitData(
      count: 0,
      lastResetDate: TimezoneHelper.getTaiwanDateString(),
      timezone: TimezoneHelper.taiwanTimezone,
    );
  }

  factory OtpRateLimitData.fromJson(Map<String, dynamic> json) =>
      _$OtpRateLimitDataFromJson(json);

  Map<String, dynamic> toJson() => _$OtpRateLimitDataToJson(this);

  OtpRateLimitData copyWith({
    int? count,
    String? lastResetDate,
    String? timezone,
  }) {
    return OtpRateLimitData(
      count: count ?? this.count,
      lastResetDate: lastResetDate ?? this.lastResetDate,
      timezone: timezone ?? this.timezone,
    );
  }
}
