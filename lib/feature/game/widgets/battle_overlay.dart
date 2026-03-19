import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/monster_model.dart';
import '../providers/player_provider.dart';

class BattleOverlay extends ConsumerStatefulWidget {
  final MonsterModel monster;

  const BattleOverlay({super.key, required this.monster});

  @override
  ConsumerState<BattleOverlay> createState() => _BattleOverlayState();
}

class _BattleOverlayState extends ConsumerState<BattleOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _monsterScale;
  late Animation<Offset> _shakeAnimation;
  bool _isAttacking = false;
  String _combatLog = '進入戰鬥！代碼怪獸出現了。';

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _monsterScale = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.elasticOut),
    );

    _shakeAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.05, 0.0),
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.elasticIn));
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _attack() async {
    if (_isAttacking) return;
    setState(() {
      _isAttacking = true;
      _combatLog = '你對 ${widget.monster.name} 發動攻擊！';
    });

    await _animController.forward();
    await _animController.reverse();

    ref.read(playerProvider.notifier).addExp(5);
    
    setState(() {
      _isAttacking = false;
      _combatLog = '造成了 20 點傷害！';
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: isDark ? Colors.black.withAlpha(200) : Colors.white.withAlpha(230),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withAlpha(50),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'LV ${widget.monster.level} ${widget.monster.name}',
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                ScaleTransition(
                  scale: _monsterScale,
                  child: SlideTransition(
                    position: _shakeAnimation,
                    child: Container(
                      height: 180,
                      width: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.greenAccent.withAlpha(50),
                            blurRadius: 40,
                          ),
                        ],
                      ),
                      child: Image.asset(widget.monster.assetPath),
                    ),
                  ),
                ),
                const Spacer(),
                _buildProgressBar(
                  label: 'HP',
                  current: widget.monster.currentHp,
                  max: widget.monster.baseHp,
                  color: Colors.redAccent,
                  width: 220,
                  isDark: isDark,
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withAlpha(10) : Colors.black.withAlpha(5),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    _combatLog,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        label: '攻擊',
                        icon: Icons.flash_on,
                        color: Colors.orangeAccent,
                        onPressed: _attack,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _buildActionButton(
                        label: '撤退',
                        icon: Icons.close,
                        color: Colors.grey,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar({
    required String label,
    required int current,
    required int max,
    required Color color,
    required double width,
    required bool isDark,
  }) {
    double percent = (current / max).clamp(0.0, 1.0);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
        const SizedBox(width: 8),
        Stack(
          children: [
            Container(
              height: 12,
              width: width,
              decoration: BoxDecoration(
                color: isDark ? Colors.white10 : Colors.black.withAlpha(10),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 12,
              width: width * percent,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [BoxShadow(color: color.withAlpha(100), blurRadius: 4)],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 0,
      ),
    );
  }
}
