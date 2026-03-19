/*import 'package:ecoco_app/constants/colors.dart';
import 'package:flutter/material.dart';
import '../models/merchant_reward_card_model.dart';
import '../ecoco_icons.dart';
import '../pages/common/alerts/quantity_reward_confirm_alert.dart';

/// 商家優惠兌換底部彈窗（張數型）
class MerchantRewardQuantityExchangeSheet extends StatefulWidget {
  final MerchantRewardCardModel reward;
  final double topAreaHeight; // 頂部區域高度（狀態欄 + AppBar + UserPointsHeader）
  final int userPoints; // 使用者當前點數

  const MerchantRewardQuantityExchangeSheet({
    super.key,
    required this.reward,
    required this.topAreaHeight,
    this.userPoints = 0,
  });

  /// 顯示底部彈窗的靜態方法
  static Future<void> show(
    BuildContext context,
    MerchantRewardCardModel reward, {
    required double topAreaHeight,
    int userPoints = 0,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      barrierColor: Colors.black.withValues(alpha: 0.5), // 半透明黑色遮罩
      builder: (context) => MerchantRewardQuantityExchangeSheet(
        reward: reward,
        topAreaHeight: topAreaHeight,
        userPoints: userPoints,
      ),
    );
  }

  @override
  State<MerchantRewardQuantityExchangeSheet> createState() =>
      _MerchantRewardQuantityExchangeSheetState();
}

class _MerchantRewardQuantityExchangeSheetState
    extends State<MerchantRewardQuantityExchangeSheet> {
  late PageController _pageController;
  int _currentPage = 0;
  int _selectedQuantity = 0; // 使用者選擇的組數
  int _requiredPoints = 0;
  String? _errorMessage;

  // 模擬圖片列表（實際應從 model 獲取）
  final List<String> _images = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    // 初始化圖片列表（至少包含背景圖）
    _images.add(widget.reward.backgroundImageUrl);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// 計算使用者最多可兌換的組數
  int _calculateMaxAvailableSets() {
    final pointsPerSet = widget.reward.pointsPerSet ?? 0;
    if (pointsPerSet <= 0) return 0;

    // 根據使用者點數計算最多可兌換組數
    final maxByPoints = widget.userPoints ~/ pointsPerSet;

    // 如果有商家限制的最大組數，取較小值
    final maxSetsAvailable = widget.reward.maxSetsAvailable;
    if (maxSetsAvailable != null) {
      return maxByPoints < maxSetsAvailable ? maxByPoints : maxSetsAvailable;
    }

    return maxByPoints;
  }

  /// 驗證選擇的組數並更新錯誤訊息
  void _validateQuantity() {
    if (_selectedQuantity == 0) {
      setState(() {
        _requiredPoints = 0;
        _errorMessage = null;
      });
      return;
    }

    final pointsPerSet = widget.reward.pointsPerSet ?? 0;
    final requiredPoints = _selectedQuantity * pointsPerSet;
    final maxAvailableSets = _calculateMaxAvailableSets();

    String? error;

    // 驗證邏輯
    if (_selectedQuantity > maxAvailableSets) {
      if (requiredPoints > widget.userPoints) {
        error = '當前點數不足，請重新輸入';
      } else {
        error = '超出可兌換組數，請重新輸入';
      }
    }

    // 模擬「不符合條件」的情況（例如：特定商家的特殊限制）
    // 這裡假設星巴克需要特殊條件
    if (widget.reward.merchantName.contains('星巴克') && _selectedQuantity > 0) {
      error = '不符合條件，請查看兌換說明';
    }

    setState(() {
      _requiredPoints = requiredPoints;
      _errorMessage = error;
    });
  }

  /// 增加組數
  void _incrementQuantity() {
    setState(() {
      _selectedQuantity++;
      _validateQuantity();
    });
  }

  /// 減少組數
  void _decrementQuantity() {
    if (_selectedQuantity > 0) {
      setState(() {
        _selectedQuantity--;
        _validateQuantity();
      });
    }
  }

  /// 處理確認兌換
  void _handleConfirmExchange() {
    // 顯示確認兌換 Alert
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return QuantityRewardConfirmAlert(
          requiredPoints: _requiredPoints,
          onConfirm: () {
            // TODO: 實作扣點邏輯

            // 關閉 alert
            Navigator.pop(dialogContext);

            // 關閉 exchange sheet
            Navigator.pop(context);
          },
          onCancel: () {
            // 單純關閉 alert
            Navigator.pop(dialogContext);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;

    // 計算彈窗高度（精確覆蓋到「公益商家標題區」）
    final sheetHeight = screenHeight - widget.topAreaHeight;

    return Container(
      height: sheetHeight,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          // 頂部標題欄
          _buildHeader(),

          // 可滾動內容區
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 商家資訊區
                  _buildMerchantInfo(),

                  // 兌換說明區
                  _buildExchangeDescription(),
                ],
              ),
            ),
          ),

          // 底部兌換操作區
          _buildExchangeActions(),
        ],
      ),
    );
  }

  /// 頂部標題欄
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: Color(0xFFF2F2F2),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 返回按鈕（左側）
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black87),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // 標題（中間）
          const Text(
            '查看優惠',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFF5000),
            ),
          ),
        ],
      ),
    );
  }

  /// 圖片輪播區
  Widget _buildImageCarousel() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF6B8E23), // 綠色背景（暫時）
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // 圖片輪播
          SizedBox(
            height: 200,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: _images.length,
              itemBuilder: (context, index) {
                return Image.network(
                  _images[index],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.white,
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 64,
                          color: Colors.white54,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // 輪播指示器
          if (_images.length > 1)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _images.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// 商家資訊區
  Widget _buildMerchantInfo() {
    return Container(
      color: const Color(0xFFF2F2F2),
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Container(
          margin: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 圖片輪播區
              _buildImageCarousel(),

              const SizedBox(height: 4),

              // 商家名稱
              Center(
                child: Text(
                  widget.reward.merchantName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),

              const SizedBox(height: 4),
              const Divider(height: 8, color: Color(0xFFE0E0E0)),

              // 兌換資訊行
              Row(
                children: [
                  // 兌換比例 Column
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                ECOCOIcons.ecocoSmileOutlined,
                                size: 28,
                                color: AppColors.primaryHighlightColor,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                widget.reward.exchangeRate,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  // 限制說明 Column（張數型顯示使用說明）
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.warning_amber_rounded,
                                size: 28,
                                color: Colors.red,
                              ),
                              SizedBox(width: 6),
                              Text(
                                '使用詳情如下',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 兌換說明區
  Widget _buildExchangeDescription() {
    return Container(
      color: const Color(0xFFF2F2F2),
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 標題行
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '兌換說明',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                InkWell(
                  onTap: () {
                    // TODO: 開啟操作指引
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: Color(0xFF0076A9),
                      ),
                      SizedBox(width: 4),
                      Text(
                        '操作指引',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF0076A9),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // 說明內容
            Text(
              widget.reward.exchangeDescription ??
                  '1. 無環保杯：使用ECOCO點數折抵5元，每杯折抵上限5元。\n\n2. 有環保杯：使用ECOCO點數折抵5元 + 環保杯5元 = 10元。',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 底部兌換操作區
  Widget _buildExchangeActions() {
    final maxAvailableSets = _calculateMaxAvailableSets();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 當前點數最多可兌換
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '當前點數最多可兌換',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  '$maxAvailableSets 組',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 本次兌換組數選擇器
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '本次兌換',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Row(
                  children: [
                    // 減少按鈕
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0076A9),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                        ),
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.remove,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: _decrementQuantity,
                      ),
                    ),
                    // 數量顯示
                    Container(
                      width: 60,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF0076A9)),
                      ),
                      child: Text(
                        '$_selectedQuantity',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0076A9),
                        ),
                      ),
                    ),
                    // 增加按鈕
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0076A9),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: _incrementQuantity,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '組',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // 錯誤訊息顯示
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    _errorMessage!,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFFF5000),
                    ),
                  ),
                ),
              ),
            if (_errorMessage == null && _selectedQuantity > 0)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    '點擊確認兌換即代表\n我同意電子序號一經兌換後，不退還點數',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFFF5000),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // 欲使用點數
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(
                      ECOCOIcons.ecocoSmileOutlined,
                      size: 18,
                      color: Colors.black87,
                    ),
                    SizedBox(width: 6),
                    Text(
                      '欲使用點數',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                Text(
                  '$_requiredPoints 點',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 確認兌換按鈕
            SizedBox(
              width: double.infinity,
              height: 36,
              child: ElevatedButton(
                onPressed: _selectedQuantity > 0 && _errorMessage == null
                    ? _handleConfirmExchange
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5000),
                  disabledBackgroundColor: const Color(0xFFE0E0E0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: const Text(
                  '確認兌換',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/