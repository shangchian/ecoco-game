import 'package:ecoco_app/constants/colors.dart';
import 'package:flutter/material.dart';
import '../../../../models/recycling_period_stats.dart';
import '../../../../ecoco_icons.dart';
import '../../../../pages/common/alerts/image_display_dialog.dart';

/// 遊戲化儀表板 Widget - 回收統計與減碳成果展示
class RecyclingStatisticsCard extends StatefulWidget {
  final RecyclingPeriodStats monthlyStats;
  final RecyclingPeriodStats yearlyStats;
  final RecyclingPeriodStats totalStats;
  final VoidCallback? onViewHistory;

  const RecyclingStatisticsCard({
    super.key,
    required this.monthlyStats,
    required this.yearlyStats,
    required this.totalStats,
    this.onViewHistory,
  });

  @override
  State<RecyclingStatisticsCard> createState() =>
      _RecyclingStatisticsCardState();
}

class _RecyclingStatisticsCardState extends State<RecyclingStatisticsCard> {
  // 當前選中的tab索引: 0=本月, 1=今年, 2=總累計
  int _selectedTabIndex = 0;

  // 配色方案
  static const Color _primaryBlue = Color(0xFF0000B3); // 寶藍色 (更亮飽和)
  static const Color _accentOrange = Color(0xFFFF5500); // 亮橘紅色
  static const Color _highlightYellow = AppColors.backgroundYellow; // 金黃色
  static const Color _neutralGrey = Color(0xFF808080); // 灰色
  static const Color _textDark = Color(0xFF333333); // 深灰色文字


  /// 根據當前選中的tab獲取對應的統計數據
  RecyclingPeriodStats get _currentStats {
    switch (_selectedTabIndex) {
      case 0:
        return widget.monthlyStats;
      case 1:
        return widget.yearlyStats;
      case 2:
        return widget.totalStats;
      default:
        return widget.monthlyStats;
    }
  }

  /// 根據當前選中的tab獲取對應的CO2減碳量
  double get _currentCO2 {
    switch (_selectedTabIndex) {
      case 0:
        return _currentStats.monthlyCO2;
      case 1:
        return _currentStats.yearlyCO2;
      case 2:
        return _currentStats.yearlyCO2;
      default:
        return _currentStats.monthlyCO2;
    }
  }

  /// 格式化數字加上千分位逗號 (例: 9999 → "9,999")
  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  /// 格式化CO2數值，保留1位小數並加上千分位
  /// 可用於公克或公斤，由調用者決定 (例: 12345.67 → "12,345.7")
  String _formatCO2(double value) {
    final intPart = value.floor();
    final decimalPart = ((value - intPart) * 10).round();
    final formattedInt = _formatNumber(intPart);
    return '$formattedInt.$decimalPart';
  }

  /// 根據CO2數值決定顯示單位和數值
  /// 傳入的value是公斤(KG)，當轉換為公克後 < 1000 時顯示公克，否則顯示公斤
  (double, String) _getCO2DisplayInfo(double valueInKG) {
    final grams = valueInKG * 1000;
    if (grams < 1000) {
      return (grams, '減碳量(公克)');
    } else {
      return (valueInKG, '減碳量(公斤)');
    }
  }

  /// 獲取tab標籤文字
  String _getTabLabel(int tabIndex, bool isSelected) {
    const String selectedPostfix = '投遞數';
    switch (tabIndex) {
      case 0:
        return '本月${isSelected ? selectedPostfix : ''}';
      case 1:
        return '今年${isSelected ? selectedPostfix : ''}';
      case 2:
        return '總計${isSelected ? selectedPostfix : ''}';
      default:
        return '';
    }
  }

  /// 構建資料夾風格的Tab按鈕
  Widget _buildFolderTab(int index) {
    final isSelected = _selectedTabIndex == index;
    final label = _getTabLabel(index, isSelected);

    final tabContent = GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
        height: 52,
        margin: (isSelected && index == 0)
            ? const EdgeInsets.only(right: 2)
            : null,
        decoration: BoxDecoration(
          color: isSelected ? _primaryBlue : _neutralGrey,
          border: Border(
            top: BorderSide(
              color: isSelected && index == 0 ? _primaryBlue : _highlightYellow,
              width: 2,
            ),
            left: BorderSide(
              color: isSelected && index == 0 ? _primaryBlue : _highlightYellow,
              width: 2,
            ),
            right: BorderSide(
              color: isSelected && index == 0 ? _primaryBlue : _highlightYellow,
              width: 2,
            ),
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        alignment: Alignment.center,
        child: Transform.translate(
          offset: const Offset(0, -10),
          child: MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(1.0)),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? _highlightYellow : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );

    // 為 index=0 且選中的標籤添加假的黃色右邊框
    if (isSelected && index == 0) {
      return Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 30,
              decoration: const BoxDecoration(
                color: _highlightYellow,
                borderRadius: BorderRadius.only(topRight: Radius.circular(20)),
              ),
            ),
          ),
          tabContent,
        ],
      );
    }

    return tabContent;
  }

  /// 構建回收項目列表的單一項目
  Widget _buildRecyclingItem({
    required IconData iconData,
    required String label,
    required int count,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(iconData, size: 20, color: _textDark),
              const SizedBox(width: 6),
              MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: TextScaler.linear(1.0)),
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    color: _textDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                _formatNumber(count),
                style: const TextStyle(
                  fontSize: 18,
                  color: _accentOrange,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final stats = _currentStats;

    return Container(
      decoration: const BoxDecoration(
        //color: _primaryBlue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // 頂部資料夾式標籤列
          LayoutBuilder(
            builder: (context, constraints) {
              const overlap = 20.0; // 重疊的像素
              final totalWidth = constraints.maxWidth;
              final tabWidth = (totalWidth + 2 * overlap) / 3; // 計算每個 Tab 的寬度

              // 構建三個 Tab 的 Widget 列表，選中的 Tab 最後繪製以顯示在最上層
              final tabs = <Widget>[];
              // 根據選中的 tab 位置決定加入順序
              if (_selectedTabIndex == 0) {
                // 選中 tab0：從右到左加入未選中的 (tab2 → tab1)
                for (int i = 2; i >= 0; i--) {
                  if (i != _selectedTabIndex) {
                    tabs.add(
                      Positioned(
                        left: i * (tabWidth - overlap),
                        child: SizedBox(
                          width: tabWidth,
                          child: _buildFolderTab(i),
                        ),
                      ),
                    );
                  }
                }
              } else {
                // 選中 tab1 或 tab2：從左到右加入未選中的
                for (int i = 0; i < 3; i++) {
                  if (i != _selectedTabIndex) {
                    tabs.add(
                      Positioned(
                        left: i * (tabWidth - overlap),
                        child: SizedBox(
                          width: tabWidth,
                          child: _buildFolderTab(i),
                        ),
                      ),
                    );
                  }
                }
              }
              // 最後添加選中的 Tab,確保它在最上層
              tabs.add(
                Positioned(
                  left: _selectedTabIndex * (tabWidth - overlap),
                  child: SizedBox(
                    width: tabWidth,
                    child: _buildFolderTab(_selectedTabIndex),
                  ),
                ),
              );

              return SizedBox(height: 52, child: Stack(children: tabs));
            },
          ),

          // 主要內容面板 (白色卡片) 與 底部連結區
          Transform.translate(
            offset: const Offset(0, -20),
            child: Stack(
              children: [
                // 底部連結區 - 使用 Positioned 將其固定在 Stack 底部
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: widget.onViewHistory,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(0, 14, 0, 4),
                      decoration: const BoxDecoration(
                        color: _primaryBlue,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Center(
                        child: MediaQuery(
                          data: MediaQuery.of(
                            context,
                          ).copyWith(textScaler: TextScaler.linear(1.0)),
                          child: Text(
                            '查看點數歷程 >>>',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: _highlightYellow,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // 白色統計卡片 - 放在後面以獲得更高的 z-index
                Padding(
                  // 預留底部空間給「查看點數歷程」按鈕
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: _primaryBlue, width: 2),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        children: [
                          // CO2 背景浮水印
                          Positioned(
                            right: 0,
                            top: 40,
                            bottom: 0,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(13),
                              ),
                              child: Opacity(
                                opacity: 0.7,
                                child: Image.asset(
                                  'assets/images/background_co2.png',
                                  fit: BoxFit.contain,
                                  height: double.infinity,
                                ),
                              ),
                            ),
                          ),

                          // 內容層
                          Column(
                            children: [
                              const SizedBox(height: 12),

                              // 5個回收項目列表
                              _buildRecyclingItem(
                                iconData: ECOCOIcons.bottleStatus,
                                label: '寶特瓶',
                                count: stats.petCount,
                              ),
                              _buildRecyclingItem(
                                iconData: ECOCOIcons.cupStatus,
                                label: 'PP塑膠杯',
                                count: stats.ppCupCount,
                              ),
                              _buildRecyclingItem(
                                iconData: ECOCOIcons.milkBottleStatus,
                                label: '牛奶瓶',
                                count: stats.milkBottleCount,
                              ),
                              _buildRecyclingItem(
                                iconData: ECOCOIcons.aluCanStatus,
                                label: '鋁罐',
                                count: stats.aluCanCount,
                              ),
                              _buildRecyclingItem(
                                iconData: ECOCOIcons.batteryStatus,
                                label: '乾電池',
                                count: stats.batteryCount,
                              ),

                              // 分隔線
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 4,
                                ),
                                child: Divider(
                                  color: Colors.grey[300],
                                  thickness: 1,
                                  height: 1,
                                ),
                              ),

                              // 底部減碳量統計
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  50,
                                  8,
                                  50,
                                  16,
                                ),
                                child: Builder(
                                  builder: (context) {
                                    final (co2Value, co2Unit) =
                                        _getCO2DisplayInfo(_currentCO2);
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                ImageDisplayDialog.show(context,
                                                    imagePath:
                                                        'assets/images/recycling_statistics_manual.webp');
                                              },
                                              child: const Icon(
                                                ECOCOIcons
                                                    .infoCircledBlue,
                                                size: 16,
                                                color: Color(0xFF0076A9),
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            MediaQuery(
                                              data: MediaQuery.of(context)
                                                  .copyWith(
                                                    textScaler:
                                                        TextScaler.linear(1.0),
                                                  ),
                                              child: Text(
                                                co2Unit,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  color: _textDark,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Flexible(
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: _formatCO2(co2Value),
                                                    style: const TextStyle(
                                                      fontSize: 22,
                                                      color: _accentOrange,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),

                              const SizedBox(height: 8),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
