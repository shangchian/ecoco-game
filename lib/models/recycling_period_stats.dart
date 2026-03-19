import 'recycling_stats_response.dart';

/// 時間週期枚舉
enum StatsPeriod { monthly, yearly, total }

/// 回收統計數據模型 - 用於不同時間週期的統計
class RecyclingPeriodStats {
  final int petCount; // 寶特瓶
  final int ppCupCount; // PP塑膠杯
  final int milkBottleCount; // 牛奶瓶
  final int aluCanCount; // 鋁罐
  final int batteryCount; // 乾電池
  final double yearlyCO2; // 年累計減碳量 (KG)
  final double monthlyCO2; // 月累計減碳量 (KG)

  const RecyclingPeriodStats({
    required this.petCount,
    required this.ppCupCount,
    required this.milkBottleCount,
    required this.aluCanCount,
    required this.batteryCount,
    required this.yearlyCO2,
    required this.monthlyCO2,
  });

  /// 計算總投瓶數
  int get totalCount =>
      petCount + ppCupCount + milkBottleCount + aluCanCount + batteryCount;

  /// 從 API 回應建立特定時間週期的統計數據
  factory RecyclingPeriodStats.fromApiResponse(
    RecyclingStatsResponse response,
    StatsPeriod period,
  ) {
    // 從 itemList 中提取各項目的數量
    int petCount = 0, ppCupCount = 0, milkBottleCount = 0;
    int aluCanCount = 0, batteryCount = 0;

    for (final item in response.itemList) {
      final count = _getCountForPeriod(item, period);
      switch (item.itemCode) {
        case 'PET_BOTTLE':
          petCount = count;
        case 'PP_CUP':
          ppCupCount = count;
        case 'HDPE_BOTTLE':
          milkBottleCount = count;
        case 'ALUMINUM_CAN':
          aluCanCount = count;
        case 'BATTERY':
          batteryCount = count;
      }
    }

    // 根據時間週期選擇對應的 CO2 數據
    final co2Metrics = response.carbonMetrics;
    final (monthlyCO2, yearlyCO2) = switch (period) {
      StatsPeriod.monthly => (
          co2Metrics.monthlyCO2KG,
          co2Metrics.monthlyCO2KG
        ),
      StatsPeriod.yearly => (co2Metrics.annualCO2KG, co2Metrics.annualCO2KG),
      StatsPeriod.total => (co2Metrics.monthlyCO2KG, co2Metrics.totalCO2KG),
    };

    return RecyclingPeriodStats(
      petCount: petCount,
      ppCupCount: ppCupCount,
      milkBottleCount: milkBottleCount,
      aluCanCount: aluCanCount,
      batteryCount: batteryCount,
      monthlyCO2: monthlyCO2,
      yearlyCO2: yearlyCO2,
    );
  }

  /// 根據時間週期從 RecyclingItem 中提取對應的數量
  static int _getCountForPeriod(RecyclingItem item, StatsPeriod period) {
    return switch (period) {
      StatsPeriod.monthly => item.countThisMonth ?? 0,
      StatsPeriod.yearly => item.countThisYear ?? 0,
      StatsPeriod.total => item.totalCount,
    };
  }
}

/// Mock 數據 - 本月投瓶數
RecyclingPeriodStats getMockMonthlyStats() {
  return const RecyclingPeriodStats(
    petCount: 0,
    ppCupCount: 0,
    milkBottleCount: 0,
    aluCanCount: 0,
    batteryCount: 0,
    yearlyCO2: 0,
    monthlyCO2: 0,
  );
}

/// Mock 數據 - 今年投瓶數
RecyclingPeriodStats getMockYearlyStats() {
  return const RecyclingPeriodStats(
    petCount: 0,
    ppCupCount: 0,
    milkBottleCount: 0,
    aluCanCount: 0,
    batteryCount: 0,
    yearlyCO2: 0,
    monthlyCO2: 0,
  );
}

/// Mock 數據 - 總累計投瓶數
RecyclingPeriodStats getMockTotalStats() {
  return const RecyclingPeriodStats(
    petCount: 0,
    ppCupCount: 0,
    milkBottleCount: 0,
    aluCanCount: 0,
    batteryCount: 0,
    yearlyCO2: 0,
    monthlyCO2: 0,
  );
}
