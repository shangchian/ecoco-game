import 'package:auto_route/auto_route.dart';
import 'package:ecoco_app/utils/error_messages.dart';
import 'package:ecoco_app/constants/colors.dart';
import 'package:ecoco_app/widgets/campaign_icon.dart';
import 'package:ecoco_app/widgets/coupon_redeem_icon.dart';
import 'package:ecoco_app/widgets/discard_icon.dart';
import 'package:ecoco_app/widgets/exchange_icon.dart';
import 'package:ecoco_app/widgets/exchange_out_icon.dart';
import 'package:ecoco_app/widgets/serial_icon.dart';
import 'package:ecoco_app/widgets/special_token_icon.dart';
import 'package:ecoco_app/widgets/system_cog_deduct.dart';
import 'package:ecoco_app/widgets/system_cog_icon.dart';
import '../../../widgets/ntp_coin_icon.dart';
import '/ecoco_icons.dart';
import '/models/points_log_model.dart';
import '/pages/common/alerts/points_info_dialog.dart';
import '/providers/wallet_provider.dart';
import '/providers/points_history_provider.dart';
import '/router/app_router.dart';
import '/widgets/battery_icon.dart';
import '/widgets/bottle_icon.dart';
import '/widgets/ecoco_points_badge.dart';
import '/widgets/fpg_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

enum FilterTab {
  all,     // 所有紀錄
  earned,  // 獲得紀錄
  used,    // 使用紀錄
}

@RoutePage()
class PointsHistoryPage extends ConsumerStatefulWidget {
  const PointsHistoryPage({super.key});

  @override
  ConsumerState<PointsHistoryPage> createState() => _PointsHistoryPageState();
}

class _PointsHistoryPageState extends ConsumerState<PointsHistoryPage> {
  FilterTab _selectedFilter = FilterTab.all;
  int? _expandedIndex;

  @override
  void initState() {
    super.initState();

    // Fetch initial data
    Future.microtask(() {
      ref.read(pointsHistoryProvider.notifier).fetchInitialData();
      ref.read(walletProvider.notifier).fetchWalletData();
    });
  }

  String _formatDateTime(String isoString) {
    try {
      final dt = DateTime.parse(isoString);
      final local = dt.toLocal();
      return DateFormat('yyyy-MM-dd HH:mm').format(local);
    } catch (e) {
      return isoString;
    }
  }

  String _formatExpiryDate(String? isoString) {
    if (isoString == null) return '';
    try {
      final dt = DateTime.parse(isoString);
      final local = dt.toLocal();
      return DateFormat('yyyy-MM-dd').format(local);
    } catch (e) {
      return isoString;
    }
  }

  void _navigateToExchange() {
    final tabsRouter = context.router.root.innerRouterOf<TabsRouter>(MainRoute.name);
    if (tabsRouter != null) {
      tabsRouter.setActiveIndex(2); // Rewards tab is at index 2
      context.router.maybePop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context);
    final historyState = ref.watch(pointsHistoryProvider);
    final walletData = ref.watch(walletProvider);

    // Get filtered logs based on selected filter
    final displayLogs = _selectedFilter == FilterTab.all
        ? historyState.allLogs
        : _selectedFilter == FilterTab.earned
            ? historyState.earnedLogs
            : historyState.usedLogs;

    return Scaffold(
      backgroundColor: AppColors.greyBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.router.pop(),
        ),
        title: Text(appLocale?.pointsHistory ?? "點數歷程", style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: Color(0xFF333333),
        ),),
        backgroundColor: AppColors.secondaryHighlightColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 56,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.info,
              color: Colors.white,
              size: 28,
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 15,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            onPressed: () {
              PointsInfoDialog.show(context);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.primaryHighlightColor,
        onRefresh: () async {
          await Future.wait([
            ref.read(pointsHistoryProvider.notifier).refresh(),
            ref.read(walletProvider.notifier).fetchWalletData(),
          ]);
        },
        child: CustomScrollView(
          slivers: [
            // 點數餘額卡片
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/point_banner_bg.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left side: Points badge + Expiry
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          EcocoPointsBadge.large(
                            points: walletData?.ecocoWallet.currentBalance ?? 0,
                          ),
                          if (walletData?.ecocoWallet.expiryDetails.isExpiringSoon ?? false) ...[
                            SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.info,
                                  size: 18,
                                  color: AppColors.secondaryTextColor,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    '${walletData!.ecocoWallet.expiryDetails.nextExpiryAmount} 點即將於 ${_formatExpiryDate(walletData.ecocoWallet.expiryDetails.nextExpiryDate)} 到期',
                                    style: const TextStyle(
                                      color: AppColors.secondaryTextColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Right side: Exchange button
                    GestureDetector(
                      onTap: _navigateToExchange,
                      child: Image.asset(
                        'assets/images/redeem_square_btn.png',
                        width: 53,
                        height: 53,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 所有/獲得/使用記錄切換 (Sticky Header)
            SliverPersistentHeader(
              pinned: true,
              delegate: _FilterTabsDelegate(
                selectedFilter: _selectedFilter,
                onFilterChanged: (FilterTab tab) {
                  setState(() {
                    _selectedFilter = tab;
                    _expandedIndex = null;
                  });
                },
                allLabel: "所有紀錄",
                earnedLabel: appLocale?.pointsHistory2 ?? "獲得紀錄",
                usedLabel: appLocale?.pointsHistory3 ?? "使用紀錄",
              ),
            ),

            // Divider
            SliverToBoxAdapter(
              child: Divider(height: 2, thickness: 4, color: Color(0xFFF2F2F2)),
            ),

            // 交易記錄列表
            ..._buildLogsList(displayLogs, historyState),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildLogsList(List<PointLog> displayLogs, PointsHistoryState historyState) {
    // Loading state
    if (displayLogs.isEmpty && historyState.isLoading) {
      return [
        const SliverFillRemaining(
          child: Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryHighlightColor,
            ),
          ),
        ),
      ];
    }

    // Error state
    if (historyState.error != null && displayLogs.isEmpty) {
      return [
        SliverFillRemaining(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text('載入失敗', style: TextStyle(fontSize: 18)),
                const SizedBox(height: 8),
                Text(
                  ErrorMessages.getDisplayMessage(historyState.error!), 
                  style: const TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.read(pointsHistoryProvider.notifier).refresh(),
                  child: const Text('重試', style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),),
                ),
              ],
            ),
          ),
        ),
      ];
    }

    // Empty state
    if (displayLogs.isEmpty && !historyState.isLoading) {
      return [
        SliverFillRemaining(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.inbox, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  _selectedFilter == FilterTab.all
                      ? '尚無交易記錄'
                      : _selectedFilter == FilterTab.earned
                          ? '尚無獲得記錄'
                          : '尚無使用記錄',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ];
    }

    // List view with sliver
    return [
      DecoratedSliver(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        sliver: SliverPadding(
          padding: EdgeInsets.fromLTRB(
            16,
            0,
            16,
            0,
          ),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final log = displayLogs[index];
                return _buildLogItem(log, index);
              },
              childCount: displayLogs.length,
            ),
          ),
        ),
      ),
      SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
          child: _buildThreeMonthNotice(),
        ),
      ),
    ];
  }

  Widget _buildThreeMonthNotice() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Text(
          '僅顯示 近一年 資料',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.secondaryValueColor,
          ),
        ),
      ),
    );
  }

  Widget _buildLogItem(PointLog log, int index) {
    return Column(
      children: [
        Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
          ),
          child: ExpansionTile(
            key: ValueKey('expansion_tile_${index}_${_expandedIndex == index}'),
            initiallyExpanded: _expandedIndex == index,
            onExpansionChanged: (isExpanded) {
              setState(() {
                _expandedIndex = isExpanded ? index : null;
              });
            },
            shape: const Border(),
            collapsedShape: const Border(),
            collapsedBackgroundColor: Colors.white,
            backgroundColor: Colors.white,
            leading: _getTransactionIcon(log.iconTypeCode),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (log.currencyCode == 'NEW_TAIPAY_POINT') ...[
                Builder(
                  builder: (context) {
                    final labelColor = log.labelColor != null && log.labelColor!.isNotEmpty
                        ? Color(int.parse('FF${log.labelColor!.replaceAll('#', '')}', radix: 16))
                        : const Color(0xFF5CA9BA);
                    return Container(
                      margin: const EdgeInsets.only(bottom: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                        border: Border.all(color: labelColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        log.labelText ?? '加碼新北幣',
                        style: TextStyle(
                          color: labelColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  },
                ),
              ],
              Text(
                log.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              _formatDateTime(log.occurredAt),
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
              ),
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
                log.currencyCode == 'DAKA' ?
                      Icon(
                        ECOCOIcons.dakaCoin,
                        color: log.logType == LogType.used ? Color(0xFF333333):Color(0xFF00A82D),
                        size: 20,
                      ):
              Icon(
                ECOCOIcons.ecoco,
                color: log.logType == LogType.used ? Color(0xFF333333):Color(0xFFFF5000),
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                '${log.logType == LogType.used ? "-" : "+"}${log.pointsChange.abs()}',
                style: TextStyle(
                  color: log.logType == LogType.used ? Color(0xFF333333):log.currencyCode == 'DAKA' ? Color(0xFF00A82D):Color(0xFFFF5000),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 8),
              log.logType == LogType.used ?
                SizedBox(width: 20, height: 20):
                Icon(
                  _expandedIndex == index ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: AppColors.indicatorColor,
                  size: 20,
                ),
            ],
          ),
          tilePadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          childrenPadding: EdgeInsets.zero,
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: _getLogDetails(log),
          ),
        ),
        const Divider(
          height: 1,
          thickness: 0.5,
          color: Color(0xFFF2F2F2),
        ),
      ],
    );
  }

  Widget _getTransactionIcon(IconTypeCode iconTypeCode) {
    Widget icon;
    switch (iconTypeCode) {
      case IconTypeCode.bottle:
        icon = BottleIcon(isEnabled: true, size: 31);
        break;
      case IconTypeCode.battery:
        icon = BatteryIcon(isEnabled: true, size: 31);
        break;
      case IconTypeCode.fbc:
        icon = FPGIcon(isEnabled: true, size: 31);
        break;
      case IconTypeCode.specialToken:
        icon = SpecialTokenIcon(isEnabled: true, size: 31);
        break;
      case IconTypeCode.systemAdd:
        icon = SystemCogIcon(isEnabled: true, size: 31);
        break;
      case IconTypeCode.systemDeduct:
        icon = SystemCogDeductIcon(isEnabled: true, size: 31);
        break;
      case IconTypeCode.couponRedeem:
        icon = CouponRedeemIcon(isEnabled: true, size: 31);
        break;
      case IconTypeCode.couponRefund:
        icon = DiscardIcon(isEnabled: true, size: 31);
        break;
      case IconTypeCode.codeRedeem:
        icon = SerialIcon(isEnabled: true, size: 31);
        break;
      case IconTypeCode.campaign:
        icon = CampaignIcon(isEnabled: true, size: 31);
        break;
      case IconTypeCode.pointsExchangeIn:
        icon = ExchangeIcon(isEnabled: true, size: 31);
        break;
      case IconTypeCode.pointsExchangeOut:
        icon = ExchangeOutIcon(isEnabled: true, size: 31);
        break;
    }

    return SizedBox(
      width: 31,
      height: 60,
      child: Center(child: icon),
    );
  }

  List<Widget> _getLogDetails(PointLog log) {
    switch (log.detailType) {
      case DetailType.detailedList:
        final items = log.detailItems;
        if (items == null || items.isEmpty) return [];

        return [
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.88,
              child: CustomPaint(
                painter: DashedLinePainter(),
                size: const Size(double.infinity, 1),
              ),
            ),
          ),
          ...items.map((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        item.name,
                        style: const TextStyle(
                          color: Color(0xFF808080),
                          fontSize: 14),
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (item.quantity != null)
                        Text(
                          '× ${item.quantity}',
                          style: const TextStyle(
                            color: Color(0xFF808080),
                            fontSize: 14),
                        ),
                      const SizedBox(width: 16),
                      log.currencyCode == 'DAKA' ?
                      const Icon(
                        ECOCOIcons.dakaCoin,
                        color: Color(0xFF00A82D),
                        size: 16,
                      ):
                      const Icon(
                        ECOCOIcons.ecoco,
                        color: Color(0xFFFF5000),
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${item.points > 0 ? "+" : ""}${item.points}',
                        style: TextStyle(
                          color: log.currencyCode == 'DAKA' ? Color(0xFF00A82D):Color(0xFFFF5000),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
          if (log.currencyCode == 'NEW_TAIPAY_POINT') ...[
            Builder(
              builder: (context) {
                final totalQuantity = items.fold<int>(0, (sum, item) => sum + (item.quantity ?? 0));
                final totalPoints = items.fold<int>(0, (sum, item) => sum + item.points);
                final labelColor = log.labelColor != null && log.labelColor!.isNotEmpty
                    ? Color(int.parse('FF${log.labelColor!.replaceAll('#', '')}', radix: 16))
                    : const Color(0xFF5CA9BA);
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '總回收數',
                            style: TextStyle(
                              color: Color(0xFF808080),
                              fontSize: 14),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '× $totalQuantity',
                            style: const TextStyle(
                              color: Color(0xFF808080),
                              fontSize: 14),
                          ),
                          const SizedBox(width: 16),
                          NtpCoinIcon(
                            isEnabled: true,
                            size: 14,
                            filled: false,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '+$totalPoints',
                            style: TextStyle(
                              color: labelColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ];

      case DetailType.textDescription:
        final description = log.textDescription;
        if (description == null || description.isEmpty) return [];

        return [
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width -32,
              child: CustomPaint(
                painter: DashedLinePainter(),
                size: const Size(double.infinity, 1),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
            child: SizedBox(
              width: double.infinity,
              child: Text(
                description,
                textAlign: TextAlign.left,
                style: TextStyle(color: Colors.grey[700]),
              ),
            ),
          ),
        ];

      case DetailType.none:
        return [];
    }
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFFF2F2F2)
      ..strokeWidth = 2;

    const dashWidth = 5.0;
    const dashSpace = 3.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _FilterTabsDelegate extends SliverPersistentHeaderDelegate {
  final FilterTab selectedFilter;
  final Function(FilterTab) onFilterChanged;
  final String allLabel;
  final String earnedLabel;
  final String usedLabel;

  _FilterTabsDelegate({
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.allLabel,
    required this.earnedLabel,
    required this.usedLabel,
  });

  @override
  double get minExtent => 48.0;

  @override
  double get maxExtent => 48.0;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: Row(
          children: [
            _buildTab(FilterTab.all, allLabel, context),
            _buildTab(FilterTab.earned, earnedLabel, context),
            _buildTab(FilterTab.used, usedLabel, context),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(FilterTab tab, String label, BuildContext context) {
    final isSelected = selectedFilter == tab;
    return Expanded(
      child: GestureDetector(
        onTap: () => onFilterChanged(tab),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20),
              topRight: const Radius.circular(20)
            ),
            border: Border(
              bottom: BorderSide(
                color: Colors.grey.shade300,
                width: 1,
              ),
            ),
          ),
          child: Center(
            child: isSelected
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF5000),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(1.0),
                ),
                child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    )),
                  )
                : Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 5),
                    child: MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(1.0),
                ),
                child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.secondaryValueColor,
                      fontWeight: FontWeight.normal,
                      fontSize: 15,
                    ),
                  )),
                  ),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(_FilterTabsDelegate oldDelegate) {
    return oldDelegate.selectedFilter != selectedFilter;
  }
}
