import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:ecoco_app/providers/favorite_sites_provider.dart';
import '/pages/main/sites/favorite_sites_list_view.dart';
import '/providers/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/constants/colors.dart';

@RoutePage()
class FavoriteSitesPage extends ConsumerStatefulWidget {
  const FavoriteSitesPage({super.key});

  @override
  ConsumerState<FavoriteSitesPage> createState() => _FavoriteSitesPageState();
}

class _FavoriteSitesPageState extends ConsumerState<FavoriteSitesPage>
    with WidgetsBindingObserver {
  bool _isLoading = false;
  Timer? _refreshTimer;

  void _setLoading(bool loading) {
    if (mounted) {
      setState(() {
        _isLoading = loading;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startAutoRefresh();
  }

  void _startAutoRefresh() {
    _refreshTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) {
        ref.read(favoriteSitesProvider.notifier).refresh();
      }
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // User returned from settings - refresh permission status
      ref.read(userLocationProvider.notifier).refreshPermissionStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.greyBackground,
        appBar: AppBar(
          backgroundColor: AppColors.secondaryHighlightColor,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 56,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: const Text(
            '常用站點',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Color(0xFF333333),
            ),
          ),
        ),
        body: Stack(
          children: [
            FavoriteSitesListView(onLoadingChanged: _setLoading),
            if (_isLoading)
              Container(
                color: Colors.black.withValues(alpha: 0.3),
                child: const Center(
                  child: CircularProgressIndicator(
                    // 需要動態變色：才用 valueColor，設計用來做「顏色動畫」的（例如從紅色漸變到藍色）。
                    // valueColor: AlwaysStoppedAnimation<Color>(
                    //   AppColors.primaryHighlightColor,
                    // ),
                    color: AppColors.primaryHighlightColor,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
