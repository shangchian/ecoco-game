import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/app_mode_provider.dart';
import '../../../providers/location_provider.dart';
import '/utils/system_ui_style_helper.dart';
import 'game_map_page.dart';
import 'game_inventory_page.dart';
import 'game_shop_page.dart';
import 'game_tasks_page.dart';

@RoutePage()
class GameHomeScreen extends ConsumerStatefulWidget {
  const GameHomeScreen({super.key});

  @override
  ConsumerState<GameHomeScreen> createState() => _GameHomeScreenState();
}

class _GameHomeScreenState extends ConsumerState<GameHomeScreen> {
  bool _hasAcquiredFirstLocation = false;
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const GameMapPage(),
    const GameInventoryPage(),
    const GameShopPage(),
    const GameTasksPage(),
  ];

  @override
  void initState() {
    super.initState();
    // Trigger location fetch as soon as we enter game mode
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userLocationProvider.notifier).getUserLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final locationState = ref.watch(userLocationProvider);
    
    // Check if we hit a "ready" state for the first time
    if (!_hasAcquiredFirstLocation) {
      final bool isReady = locationState.permissionStatus != LocationPermissionStatus.notDetermined && 
                           !locationState.isChecking;
      if (isReady) {
        _hasAcquiredFirstLocation = true;
      }
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark 
          ? SystemUiStyleHelper.gameStyle 
          : SystemUiStyleHelper.gameLightStyle,
      child: Scaffold(
        backgroundColor: isDark 
            ? const Color(0xFF121212) 
            : Colors.white,
        body: Stack(
          children: [
            // Once we have a location, we show the navigatable content
            if (_hasAcquiredFirstLocation)
              _pages[_currentIndex]
            else
              _buildLoadingOverlay(isDark),
          ],
        ),
        bottomNavigationBar: _hasAcquiredFirstLocation ? BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
          selectedItemColor: isDark ? Colors.greenAccent : Colors.green,
          unselectedItemColor: isDark ? Colors.white54 : Colors.black54,
          elevation: 8,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.map), label: '探索'),
            BottomNavigationBarItem(icon: Icon(Icons.inventory_2), label: '背包'),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: '商城'),
            BottomNavigationBarItem(icon: Icon(Icons.assignment), label: '任務'),
          ],
        ) : null,
        floatingActionButton: _hasAcquiredFirstLocation && _currentIndex == 3 ? Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: FloatingActionButton.extended(
            onPressed: () => ref.read(appModeStateProvider.notifier).toggleMode(),
            label: const Text('💡 回到一般模式', style: TextStyle(fontWeight: FontWeight.bold)),
            icon: const Icon(Icons.exit_to_app),
            backgroundColor: isDark ? Colors.orangeAccent.withValues(alpha: 0.9) : Colors.orangeAccent,
            foregroundColor: Colors.black,
            elevation: 4,
          ),
        ) : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Widget _buildLoadingOverlay(bool isDark) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark 
            ? [const Color(0xFF121212), const Color(0xFF1A1A1A)]
            : [Colors.white, Colors.grey.shade100],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.greenAccent),
          ),
          const SizedBox(height: 24),
          Text(
            '正在搜尋附近的回收怪獸...',
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
