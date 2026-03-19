import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../models/shop_product_model.dart';
import '../providers/game_wallet_provider.dart';
import '../providers/iap_provider.dart';

class GameShopPage extends ConsumerWidget {
  const GameShopPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF121212) : Colors.grey.shade50;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subtitleColor = isDark ? Colors.white54 : Colors.black54;

    final walletState = ref.watch(gameWalletProvider);
    final products = ref.watch(iAPManagerProvider);

    final String ecocoPointsStr = walletState.when(
      data: (wallet) => NumberFormat('#,###').format(wallet.ecocoPoints),
      loading: () => '...',
      error: (_, _) => '0',
    );
    final String gameGoldStr = walletState.when(
      data: (wallet) => NumberFormat('#,###').format(wallet.gameGold),
      loading: () => '...',
      error: (_, _) => '0',
    );

    final ecocoProducts = products.where((p) => p.currencyType == ProductCurrencyType.ecocoPoint).toList();
    final iapProducts = products.where((p) => p.currencyType == ProductCurrencyType.iap).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('ECOCO 商城', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBalanceHeader(isDark, ecocoPointsStr, gameGoldStr),
            const SizedBox(height: 24),
            _buildSectionTitle('環保點數兌換', Icons.eco, textColor),
            _buildProductList(ecocoProducts, cardColor, textColor, subtitleColor, ref),
            const SizedBox(height: 24),
            _buildSectionTitle('能量補給站 (IAP)', Icons.bolt, textColor),
            _buildProductList(iapProducts, cardColor, textColor, subtitleColor, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceHeader(bool isDark, String ecocoPoints, String gameGold) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark 
            ? [const Color(0xFF2E7D32), const Color(0xFF1B5E20)]
            : [const Color(0xFF4CAF50), const Color(0xFF2E7D32)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 50 : 20),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildBalanceItem('ECOCO 點數', ecocoPoints, Icons.stars),
          Container(width: 1, height: 40, color: Colors.white24),
          _buildBalanceItem('遊戲金幣', gameGold, Icons.monetization_on),
        ],
      ),
    );
  }

  Widget _buildBalanceItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white70, size: 16),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: Colors.green, size: 20),
          const SizedBox(width: 8),
          Text(title, style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildProductList(List<ShopProductModel> products, Color cardColor, Color textColor, Color subtitleColor, WidgetRef ref) {
    if (products.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('目前無可購買之商品', style: TextStyle(color: subtitleColor)),
        ),
      );
    }
    
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final product = products[index];
        final String btnLabel = product.currencyType == ProductCurrencyType.ecocoPoint 
            ? '兌換' 
            : (product.iapPriceString ?? '購買');
        final Color iconBgColor = product.currencyType == ProductCurrencyType.ecocoPoint
            ? Colors.green.withValues(alpha: 0.1)
            : Colors.blue.withValues(alpha: 0.1);
            
        return _buildShopItem(
          product.title,
          product.description,
          iconBgColor,
          btnLabel,
          cardColor,
          textColor,
          subtitleColor,
          () => ref.read(iAPManagerProvider.notifier).buyProduct(product),
        );
      },
    );
  }

  Widget _buildShopItem(
    String title, 
    String subtitle, 
    Color iconBgColor, 
    String btnLabel,
    Color cardColor,
    Color textColor,
    Color subtitleColor,
    VoidCallback onPressed,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.inventory_2, color: Colors.green.shade700),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
                Text(subtitle, style: TextStyle(color: subtitleColor, fontSize: 12)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              elevation: 0,
              minimumSize: const Size(80, 36),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            ),
            child: Text(btnLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
