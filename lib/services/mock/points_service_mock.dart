import '/models/auth_data_model.dart';
import '/models/points_history_model.dart';
import '/models/points_log_model.dart';
import '/models/wallet_model.dart';
import '/models/recycling_stats_response.dart';
import '/services/interface/i_points_service.dart';

class PointsServiceMock implements IPointsService {
  // Mock wallet data
  static final WalletData mockWalletData = WalletData(
    memberId: "12345",
    wallets: [
      Wallet(
        currencyCode: 'ECOCO_POINT',
        currencyName: 'ECOCO點數',
        currentBalance: 1250,
        expiryDetails: ExpiryDetails(
          isExpiringSoon: true,
          nextExpiryAmount: 150,
          nextExpiryDate: '2025-12-31T23:59:59.000Z',
        ),
      ),
      Wallet(
        currencyCode: 'DAKA',
        currencyName: 'DAKA點數',
        currentBalance: 350,
        expiryDetails: ExpiryDetails(
          isExpiringSoon: false,
          nextExpiryAmount: 0,
          nextExpiryDate: null,
        ),
      ),
    ],
  );

  // Mock recycling statistics data
  static const RecyclingStatsResponse mockRecyclingStats = RecyclingStatsResponse(
    carbonMetrics: CarbonMetrics(
      totalCarbonReduction: 12345600, // 12345.6 KG in grams
      monthlyCarbonReduction: 156700, // 156.7 KG in grams
      annualCarbonReduction: 3456800, // 3456.8 KG in grams
    ),
    itemList: [
      RecyclingItem(
        itemCode: 'PET_BOTTLE',
        itemName: '寶特瓶',
        totalCount: 15678,
        countThisYear: 2845,
        countThisMonth: 245,
      ),
      RecyclingItem(
        itemCode: 'PP_CUP',
        itemName: 'PP塑膠杯',
        totalCount: 9234,
        countThisYear: 1568,
        countThisMonth: 128,
      ),
      RecyclingItem(
        itemCode: 'HDPE_BOTTLE',
        itemName: '牛奶瓶',
        totalCount: 5432,
        countThisYear: 967,
        countThisMonth: 89,
      ),
      RecyclingItem(
        itemCode: 'ALUMINUM_CAN',
        itemName: '鋁罐',
        totalCount: 11234,
        countThisYear: 1876,
        countThisMonth: 156,
      ),
      RecyclingItem(
        itemCode: 'BATTERY',
        itemName: '乾電池',
        totalCount: 2345,
        countThisYear: 423,
        countThisMonth: 34,
      ),
    ],
  );

  // Mock points history data
  static final List<PointsHistory> _mockHistoryData = [
    PointsHistory(
      id: 1,
      sourceId: 1,
      siteName: '台北市政府投瓶機',
      aluCount: 5,
      petCount: 10,
      otherCount: 2,
      glassCount: 0,
      hdpeCount: 3,
      no1Count: null,
      no2Count: null,
      no3Count: null,
      no4Count: null,
      no5Count: null,
      no6Count: null,
      no9vCount: null,
      noBCount: null,
      points: 100,
      transactionAt: '2025-10-18 14:30:25',
    ),
    PointsHistory(
      id: 2,
      sourceId: 2,
      siteName: '信義區投電池機',
      aluCount: null,
      petCount: null,
      otherCount: null,
      glassCount: null,
      hdpeCount: null,
      no1Count: 5,
      no2Count: 3,
      no3Count: 8,
      no4Count: 2,
      no5Count: 10,
      no6Count: 0,
      no9vCount: 1,
      noBCount: 0,
      points: 145,
      transactionAt: '2025-10-17 10:15:42',
    ),
    PointsHistory(
      id: 3,
      sourceId: 3,
      siteName: null,
      aluCount: null,
      petCount: null,
      otherCount: null,
      glassCount: null,
      hdpeCount: null,
      no1Count: null,
      no2Count: null,
      no3Count: null,
      no4Count: null,
      no5Count: null,
      no6Count: null,
      no9vCount: null,
      noBCount: null,
      points: 50,
      transactionAt: '2025-10-16 16:45:10',
    ),
    PointsHistory(
      id: 4,
      sourceId: 1,
      siteName: '松山車站投瓶機',
      aluCount: 8,
      petCount: 15,
      otherCount: 0,
      glassCount: 2,
      hdpeCount: 5,
      no1Count: null,
      no2Count: null,
      no3Count: null,
      no4Count: null,
      no5Count: null,
      no6Count: null,
      no9vCount: null,
      noBCount: null,
      points: 150,
      transactionAt: '2025-10-15 09:20:33',
    ),
    PointsHistory(
      id: 5,
      sourceId: 4,
      siteName: null,
      aluCount: null,
      petCount: null,
      otherCount: null,
      glassCount: null,
      hdpeCount: null,
      no1Count: null,
      no2Count: null,
      no3Count: null,
      no4Count: null,
      no5Count: null,
      no6Count: null,
      no9vCount: null,
      noBCount: null,
      points: 200,
      transactionAt: '2025-10-14 11:05:18',
    ),
    PointsHistory(
      id: 6,
      sourceId: 1,
      siteName: '南港展覽館投瓶機',
      aluCount: 3,
      petCount: 8,
      otherCount: 1,
      glassCount: 0,
      hdpeCount: 2,
      no1Count: null,
      no2Count: null,
      no3Count: null,
      no4Count: null,
      no5Count: null,
      no6Count: null,
      no9vCount: null,
      noBCount: null,
      points: 70,
      transactionAt: '2025-10-13 15:30:45',
    ),
    PointsHistory(
      id: 7,
      sourceId: 5,
      siteName: '系統補點',
      aluCount: null,
      petCount: null,
      otherCount: null,
      glassCount: null,
      hdpeCount: null,
      no1Count: null,
      no2Count: null,
      no3Count: null,
      no4Count: null,
      no5Count: null,
      no6Count: null,
      no9vCount: null,
      noBCount: null,
      points: 100,
      transactionAt: '2025-10-12 13:22:11',
    ),
    PointsHistory(
      id: 8,
      sourceId: 2,
      siteName: '大安區投電池機',
      aluCount: null,
      petCount: null,
      otherCount: null,
      glassCount: null,
      hdpeCount: null,
      no1Count: 10,
      no2Count: 5,
      no3Count: 12,
      no4Count: 3,
      no5Count: 8,
      no6Count: 2,
      no9vCount: 0,
      noBCount: 1,
      points: 205,
      transactionAt: '2025-10-11 08:40:27',
    ),
    PointsHistory(
      id: 9,
      sourceId: 1,
      siteName: '中正紀念堂投瓶機',
      aluCount: 12,
      petCount: 20,
      otherCount: 5,
      glassCount: 3,
      hdpeCount: 8,
      no1Count: null,
      no2Count: null,
      no3Count: null,
      no4Count: null,
      no5Count: null,
      no6Count: null,
      no9vCount: null,
      noBCount: null,
      points: 240,
      transactionAt: '2025-10-10 17:55:39',
    ),
    PointsHistory(
      id: 10,
      sourceId: 1,
      siteName: '西門町投瓶機',
      aluCount: 2,
      petCount: 6,
      otherCount: 0,
      glassCount: 1,
      hdpeCount: 1,
      no1Count: null,
      no2Count: null,
      no3Count: null,
      no4Count: null,
      no5Count: null,
      no6Count: null,
      no9vCount: null,
      noBCount: null,
      points: 50,
      transactionAt: '2025-10-09 12:18:52',
    ),
    // Page 2 data
    PointsHistory(
      id: 11,
      sourceId: 3,
      siteName: null,
      aluCount: null,
      petCount: null,
      otherCount: null,
      glassCount: null,
      hdpeCount: null,
      no1Count: null,
      no2Count: null,
      no3Count: null,
      no4Count: null,
      no5Count: null,
      no6Count: null,
      no9vCount: null,
      noBCount: null,
      points: 30,
      transactionAt: '2025-10-08 14:25:16',
    ),
    PointsHistory(
      id: 12,
      sourceId: 1,
      siteName: '板橋車站投瓶機',
      aluCount: 6,
      petCount: 12,
      otherCount: 2,
      glassCount: 1,
      hdpeCount: 3,
      no1Count: null,
      no2Count: null,
      no3Count: null,
      no4Count: null,
      no5Count: null,
      no6Count: null,
      no9vCount: null,
      noBCount: null,
      points: 120,
      transactionAt: '2025-10-07 10:32:44',
    ),
    PointsHistory(
      id: 13,
      sourceId: 2,
      siteName: '中和區投電池機',
      aluCount: null,
      petCount: null,
      otherCount: null,
      glassCount: null,
      hdpeCount: null,
      no1Count: 8,
      no2Count: 4,
      no3Count: 10,
      no4Count: 1,
      no5Count: 6,
      no6Count: 0,
      no9vCount: 2,
      noBCount: 0,
      points: 155,
      transactionAt: '2025-10-06 16:48:21',
    ),
    PointsHistory(
      id: 14,
      sourceId: 1,
      siteName: '永和投瓶機',
      aluCount: 4,
      petCount: 9,
      otherCount: 1,
      glassCount: 0,
      hdpeCount: 2,
      no1Count: null,
      no2Count: null,
      no3Count: null,
      no4Count: null,
      no5Count: null,
      no6Count: null,
      no9vCount: null,
      noBCount: null,
      points: 80,
      transactionAt: '2025-10-05 09:15:37',
    ),
    PointsHistory(
      id: 15,
      sourceId: 4,
      siteName: null,
      aluCount: null,
      petCount: null,
      otherCount: null,
      glassCount: null,
      hdpeCount: null,
      no1Count: null,
      no2Count: null,
      no3Count: null,
      no4Count: null,
      no5Count: null,
      no6Count: null,
      no9vCount: null,
      noBCount: null,
      points: 150,
      transactionAt: '2025-10-04 13:42:09',
    ),
  ];

  // Simulate network delay
  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<List<PointsHistory>> getPointsHistory(
    AuthData authData, {
    int page = 1,
  }) async {
    await _simulateNetworkDelay();

    // Validate token
    if (authData.accessToken.isEmpty) {
      throw Exception('Invalid token');
    }

    // Ensure page starts from 1
    if (page < 1) page = 1;

    // Pagination logic - 10 items per page
    const itemsPerPage = 10;
    final startIndex = (page - 1) * itemsPerPage;
    final endIndex = startIndex + itemsPerPage;

    // Return empty list if out of range
    if (startIndex >= _mockHistoryData.length) {
      return [];
    }

    // Return paginated data
    final actualEndIndex = endIndex > _mockHistoryData.length
        ? _mockHistoryData.length
        : endIndex;

    return _mockHistoryData.sublist(startIndex, actualEndIndex);
  }

  @override
  Future<WalletData> getMemberPoints({String? currencyCode}) async {
    await _simulateNetworkDelay();

    // Validate token
    // if (token.isEmpty) {
    //   throw Exception('Invalid token');
    // }

    // Filter by currency code if specified
    if (currencyCode != null) {
      final filteredWallets = mockWalletData.wallets
          .where((w) => w.currencyCode == currencyCode)
          .toList();
      return WalletData(
        memberId: mockWalletData.memberId,
        wallets: filteredWallets,
      );
    }

    return mockWalletData;
  }

  @override
  Future<RecyclingStatsResponse> getRecyclingStats() async {
    await _simulateNetworkDelay();

    // Validate token
    // if (token.isEmpty) {
    //   throw Exception('Invalid token');
    // }

    return mockRecyclingStats;
  }

  @override
  Future<PointsHistoryResponse> getMemberPointsHistory({
    int page = 1,
    int limit = 100,
    String? updatedSince,
  }) async {
    await _simulateNetworkDelay();

    // Validate token
    // if (token.isEmpty) {
    //   throw Exception('Invalid token');
    // }

    // Ensure page starts from 1
    if (page < 1) page = 1;

    // Generate mock point logs
    final now = DateTime.now();
    final mockLogs = <PointLog>[];

    // Generate logs for the requested page
    final startIndex = (page - 1) * limit;
    final itemsToGenerate = limit > 20 ? 20 : limit; // Limit mock data generation

    for (int i = 0; i < itemsToGenerate; i++) {
      final index = startIndex + i;
      final isEarned = index % 3 != 0; // Every 3rd item is USED
      final iconTypes = [
        IconTypeCode.bottle,
        IconTypeCode.battery,
        IconTypeCode.fbc,
        IconTypeCode.systemAdd,
        IconTypeCode.couponRedeem,
        IconTypeCode.campaign,
      ];
      final iconType = iconTypes[index % iconTypes.length];

      // Create mock details based on icon type
      Map<String, dynamic>? details;
      DetailType detailType;

      if (isEarned && (iconType == IconTypeCode.bottle || iconType == IconTypeCode.battery)) {
        detailType = DetailType.detailedList;
        if (iconType == IconTypeCode.bottle) {
          details = {
            'items': [
              {'name': '寶特瓶', 'quantity': 10 + (index % 5), 'points': 20},
              {'name': 'PP塑膠杯', 'quantity': 5 + (index % 3), 'points': 10},
              {'name': '牛奶瓶', 'quantity': 3 + (index % 2), 'points': 15},
              {'name': '鋁罐', 'quantity': 8 + (index % 4), 'points': 16},
            ]
          };
        } else {
          details = {
            'items': [
              {'name': '1號/2號電池', 'quantity': 5 + (index % 3), 'points': 10},
              {'name': '3號~6號電池', 'quantity': 10 + (index % 5), 'points': 5},
              {'name': '9V電池', 'quantity': 1, 'points': 10},
            ]
          };
        }
      } else if (iconType == IconTypeCode.systemAdd) {
        detailType = DetailType.textDescription;
        details = {'description': '客服進件編號 Z${12345 + index},補發遺漏點數'};
      } else {
        detailType = DetailType.none;
        details = null;
      }

      final pointsChange = isEarned ? (50 + (index % 150)) : -(20 + (index % 80));
      final occurredAt = now.subtract(Duration(days: index)).toUtc().toIso8601String();

      mockLogs.add(PointLog(
        logId: '${1000000 + index}',
        logType: isEarned ? LogType.earned : LogType.used,
        iconTypeCode: iconType,
        currencyCode: 'ECOCO_POINT',
        title: _getMockTitle(iconType, index),
        pointsChange: pointsChange,
        occurredAt: occurredAt,
        detailType: detailType,
        detailsRaw: details,
        lastUpdatedAt: occurredAt,
      ));
    }

    return PointsHistoryResponse(pointLogs: mockLogs);
  }

  String _getMockTitle(IconTypeCode iconType, int index) {
    switch (iconType) {
      case IconTypeCode.bottle:
        final stations = ['ECOCO崇學站', 'ECOCO台北車站', 'ECOCO信義區', 'ECOCO南港站'];
        return stations[index % stations.length];
      case IconTypeCode.battery:
        final stations = ['台北市投電池機', '新北市投電池機', '大安區投電池機'];
        return stations[index % stations.length];
      case IconTypeCode.fbc:
        return '台塑DAKA超點';
      case IconTypeCode.systemAdd:
        return '【系統補點】ECOCO崇學站';
      case IconTypeCode.systemDeduct:
        return '系統修正';
      case IconTypeCode.couponRedeem:
        return '兌換全家50元電子折價券';
      case IconTypeCode.couponRefund:
        return '優惠券註銷退點';
      case IconTypeCode.codeRedeem:
        return '序號兌換點數';
      case IconTypeCode.campaign:
        return '環保拚經濟號召活動';
      case IconTypeCode.pointsExchangeIn:
        return '點數轉入';
      case IconTypeCode.pointsExchangeOut:
        return '點數轉出';
      case IconTypeCode.specialToken:
        return '特殊幣投遞';
    }
  }
}
