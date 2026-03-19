import 'package:flutter/material.dart';

class GameInventoryPage extends StatelessWidget {
  const GameInventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF121212) : Colors.grey.shade50;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      appBar: AppBar(
        title: Text('我的背包', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          _buildInventorySummary(isDark),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.8,
              ),
              itemCount: 8, // Mock item count
              itemBuilder: (context, index) {
                return _buildInventoryItem(index, cardColor, textColor, isDark);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInventorySummary(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryStat(isDark ? Colors.blue : Colors.blue.shade700, '物品數量', '24'),
          _buildSummaryStat(isDark ? Colors.orange : Colors.orange.shade700, '稀有度', 'B+'),
          _buildSummaryStat(isDark ? Colors.purple : Colors.purple.shade700, '背包空間', '24/50'),
        ],
      ),
    );
  }

  Widget _buildSummaryStat(Color color, String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  Widget _buildInventoryItem(int index, Color cardColor, Color textColor, bool isDark) {
    final itemNames = ['電子零件', '塑膠瓶', '舊電池', '碳纖維', '電路板', '廢銅線', '磁鐵', '電極片'];
    final itemColors = [
      Colors.blue, Colors.green, Colors.orange, Colors.purple, 
      Colors.red, Colors.yellow, Colors.cyan, Colors.indigo
    ];

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withAlpha(isDark ? 30 : 20)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: itemColors[index % itemColors.length].withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.token,
              color: itemColors[index % itemColors.length],
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            itemNames[index % itemNames.length],
            style: TextStyle(color: textColor, fontSize: 13, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 2),
          Text(
            'x${(index + 1) * 3}',
            style: const TextStyle(color: Colors.grey, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
