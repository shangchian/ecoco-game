import 'package:flutter/material.dart';

class GameShopPage extends StatelessWidget {
  const GameShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF121212) : Colors.grey.shade50;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subtitleColor = isDark ? Colors.white54 : Colors.black54;

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
            _buildBalanceHeader(isDark),
            const SizedBox(height: 24),
            _buildSectionTitle('環保點數兌換', Icons.eco, textColor),
            _buildPointsExchangeList(cardColor, textColor, subtitleColor),
            const SizedBox(height: 24),
            _buildSectionTitle('能量補給站 (IAP)', Icons.bolt, textColor),
            _buildIapList(cardColor, textColor, subtitleColor),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceHeader(bool isDark) {
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
          _buildBalanceItem('ECOCO 點數', '1,250', Icons.stars),
          Container(width: 1, height: 40, color: Colors.white24),
          _buildBalanceItem('遊戲金幣', '50,000', Icons.monetization_on),
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

  Widget _buildPointsExchangeList(Color cardColor, Color textColor, Color subtitleColor) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final amounts = [1000, 5000, 10000];
        final costs = [10, 45, 80];
        return _buildShopItem(
          '遊戲金幣 x${amounts[index]}',
          '消耗 ${costs[index]} 點 ECOCO',
          Colors.green.withValues(alpha: 0.1),
          '兌換',
          cardColor,
          textColor,
          subtitleColor,
        );
      },
    );
  }

  Widget _buildIapList(Color cardColor, Color textColor, Color subtitleColor) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 2,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final titles = ['新手資源包', '大師補給箱'];
        final prices = ['NT\$30', 'NT\$150'];
        return _buildShopItem(
          titles[index],
          '內含大量金幣與稀有素材',
          Colors.blue.withValues(alpha: 0.1),
          prices[index],
          cardColor,
          textColor,
          subtitleColor,
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
            onPressed: () {},
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
