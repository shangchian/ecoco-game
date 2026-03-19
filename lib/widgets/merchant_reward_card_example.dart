import 'package:flutter/material.dart';
import '/utils/snackbar_helper.dart';
import 'merchant_reward_card.dart';

/// 商家優惠卡片使用範例
///
/// 這個檔案展示了如何使用 MerchantRewardCard 元件的多種badge組合
class MerchantRewardCardExample extends StatelessWidget {
  const MerchantRewardCardExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('商家優惠卡片範例'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          // 範例 1: 正常狀態（無徽章）
          MerchantRewardCard(
            merchantName: '一般優惠',
            backgroundImageUrl:
                'https://via.placeholder.com/400x180/6B8E23/FFFFFF?text=Normal',
            rewardType: '兌換券',
            exchangeRate: '50點 = 1組',
            onTap: () {
              _showSnackBar(context, '點擊了正常狀態卡片');
            },
          ),

          // 範例 2: NEW 徽章
          MerchantRewardCard(
            merchantName: '新上線優惠',
            backgroundImageUrl:
                'https://via.placeholder.com/400x180/FF6B35/FFFFFF?text=NEW',
            rewardType: '兌換券',
            exchangeRate: '50點 = 1組',
            showNewBadge: true,
            onTap: () {
              _showSnackBar(context, '點擊了 NEW 卡片');
            },
          ),

          // 範例 3: 促銷標籤徽章
          MerchantRewardCard(
            merchantName: '期間限定優惠',
            backgroundImageUrl:
                'https://via.placeholder.com/400x180/FF5722/FFFFFF?text=Limited',
            rewardType: '折抵現金',
            exchangeRate: '2點 = \$1',
            promoLabel: '期間限定',
            onTap: () {
              _showSnackBar(context, '點擊了期間限定卡片');
            },
          ),

          // 範例 4: 已兌換完畢（灰階效果）
          MerchantRewardCard(
            merchantName: '已售罄優惠',
            backgroundImageUrl:
                'https://via.placeholder.com/400x180/FFCE00/FFFFFF?text=Sold+Out',
            rewardType: '兌換券',
            exchangeRate: '50點 = 1組',
            showSoldOutBadge: true,
            onTap: () {
              _showSnackBar(context, '此優惠已兌換完畢');
            },
          ),

          // 範例 5: 促銷標籤 + NEW（多重徽章）
          MerchantRewardCard(
            merchantName: '新上線期間限定',
            backgroundImageUrl:
                'https://via.placeholder.com/400x180/4682B4/FFFFFF?text=Multi+Badge',
            rewardType: '特別優惠',
            exchangeRate: '100點 = 1份',
            promoLabel: '雙十二限定',
            showNewBadge: true,
            onTap: () {
              _showSnackBar(context, '點擊了多重徽章卡片');
            },
          ),

          // 範例 6: 全部徽章（NEW + 促銷標籤 + SOLD_OUT）
          MerchantRewardCard(
            merchantName: '全部徽章展示',
            backgroundImageUrl:
                'https://via.placeholder.com/400x180/8B4513/FFFFFF?text=All+Badges',
            rewardType: '兌換券',
            exchangeRate: '50點 = 1組',
            promoLabel: '超值優惠',
            showNewBadge: true,
            showSoldOutBadge: true,
            onTap: () {
              _showSnackBar(context, '點擊了全部徽章卡片');
            },
          ),

          // 範例 7: 促銷標籤長度測試（超過6字會截斷）
          MerchantRewardCard(
            merchantName: '促銷標籤長度測試',
            backgroundImageUrl:
                'https://via.placeholder.com/400x180/9370DB/FFFFFF?text=Long+Label',
            rewardType: '兌換券',
            exchangeRate: '50點 = 1組',
            promoLabel: '這是一個很長的促銷標籤',
            onTap: () {
              _showSnackBar(context, '標籤會自動截斷至6個字');
            },
          ),

          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              '範例說明：\n\n'
              '1. 第一張：正常狀態，無徽章\n'
              '2. 第二張：NEW 徽章（右上角）\n'
              '3. 第三張：促銷標籤徽章（左下角）\n'
              '4. 第四張：已兌換完畢，顯示中央覆蓋圖並套用灰階效果\n'
              '5. 第五張：NEW + 促銷標籤（多重徽章）\n'
              '6. 第六張：所有徽章同時顯示\n'
              '7. 第七張：促銷標籤長度測試（超過6字會截斷）\n\n'
              '所有卡片皆可點擊，點擊後會觸發自訂的 callback 函數',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    SnackBarHelper.show(context, message, duration: const Duration(seconds: 3));
  }
}
