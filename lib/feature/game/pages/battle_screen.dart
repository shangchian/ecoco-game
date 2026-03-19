import 'dart:ui';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/monster_model.dart';
import '../providers/player_provider.dart';
import '/utils/system_ui_style_helper.dart';
import 'package:flutter/services.dart';

@RoutePage()
class BattleScreen extends ConsumerStatefulWidget {
  final MonsterModel monster;

  const BattleScreen({super.key, required this.monster});

  @override
  ConsumerState<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends ConsumerState<BattleScreen> with SingleTickerProviderStateMixin {
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

    // Animate monster getting hit
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
    final player = ref.watch(playerProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark 
          ? SystemUiStyleHelper.gameStyle 
          : SystemUiStyleHelper.gameLightStyle,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDark 
                ? [const Color(0xFF0F0F0F), const Color(0xFF1A1A1A), const Color(0xFF0F0F0F)]
                : [Colors.white, Colors.grey.shade100, Colors.white],
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                // 1. Top Section: Monster Area
                Positioned(
                  top: 60,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      Text(
                        'LV ${widget.monster.level} ${widget.monster.name}',
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black87,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ScaleTransition(
                        scale: _monsterScale,
                        child: SlideTransition(
                          position: _shakeAnimation,
                          child: Container(
                            height: 200,
                            width: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.greenAccent.withValues(alpha: 0.2),
                                  blurRadius: 40,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                            child: Image.asset(widget.monster.assetPath),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildProgressBar(
                        label: 'HP',
                        current: widget.monster.currentHp,
                        max: widget.monster.baseHp,
                        color: Colors.redAccent,
                        width: 200,
                      ),
                    ],
                  ),
                ),

                // 2. Middle Section: Combat Log
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.5,
                  left: 20,
                  right: 20,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          _combatLog,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black87, 
                            fontSize: 16
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // 3. Bottom Section: Player Stats & Actions
                Positioned(
                  bottom: 40,
                  left: 24,
                  right: 24,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildPlayerStat('LV ${player.level}', Colors.amber),
                          _buildProgressBar(
                            label: 'HP',
                            current: player.currentHp,
                            max: player.maxHp,
                            color: Colors.greenAccent,
                            width: 150,
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Expanded(
                            child: _buildGlassButton(
                              label: '普通攻擊',
                              icon: Icons.flash_on,
                              color: Colors.orangeAccent,
                              onPressed: _attack,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: _buildGlassButton(
                              label: '撤退',
                              icon: Icons.run_circle,
                              color: Colors.grey,
                              onPressed: () => context.router.pop(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
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
    double width = 200,
  }) {
    double percent = (current / max).clamp(0.0, 1.0);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
        ),
        const SizedBox(width: 8),
        Stack(
          children: [
            Container(
              height: 10,
              width: width,
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 10,
              width: width * percent,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 4),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPlayerStat(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildGlassButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(15),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              border: Border.all(color: color.withValues(alpha: 0.3)),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(color: color, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
