import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:ecoco_app/constants/colors.dart';
import 'package:ecoco_app/ecoco_icons.dart';
import 'package:ecoco_app/widgets/notification_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/providers/auth_provider.dart';
import '/providers/profile_provider.dart';
import '/providers/wallet_provider.dart';
import '/providers/carousel_provider.dart';
import '/providers/notifications_data_provider.dart';
import '/providers/popup_modal_dismissed_provider.dart';
import '/providers/session_state_provider.dart';
import '/providers/app_mode_provider.dart';
import '/router/app_router.dart';
import 'home/widgets/user_info_card.dart';
import 'home/widgets/action_buttons_grid.dart';
import 'home/widgets/promotion_banner.dart';
import 'home/widgets/activity_section.dart';
import 'home/widgets/carousel_popup_modal.dart';
import '/utils/router_analytics_extension.dart';

@RoutePage()
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  bool _isCheckingPopup = false;
  Timer? _logoLongPressTimer;
  bool _showGameModeButton = false;

  Widget _buildNotificationButton() {
    final unreadCountsAsync = ref.watch(unreadNotificationCountsProvider);

    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: IconButton(
        icon: NotificationIcon(
          icon: ECOCOIcons.bell,
          size: 28,
          backgroundColor: AppColors.secondaryHighlightColor,
          hasNotification: unreadCountsAsync.maybeWhen(
            data: (counts) => counts.hasUnread,
            orElse: () => false,
          ),
        ),
        onPressed: () {
          context.router.pushThrottledWithTracking(NotificationsRoute());
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Show popup modal after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowPopupModal();
    });
  }
  
  @override
  void dispose() {
    _logoLongPressTimer?.cancel();
    super.dispose();
  }

  void _checkAndShowPopupModal() async {
    final sessionState = ref.read(sessionStateProvider);
    if (sessionState.hasShownHomePopup || _isCheckingPopup) return;
    _isCheckingPopup = true;

    try {
      // 檢查是否今日已勾選不再顯示
      final isDismissed = await ref.read(popupModalDismissedProvider.future);
      if (isDismissed) return;

      // 直接使用 repository 同步資料並取得 popup modals
      final repository = ref.read(carouselRepositoryProvider);
      await repository.syncCarousels();
      final modals = await repository.watchActivePopupModals().first;

      if (modals.isNotEmpty && mounted) {
        sessionState.hasShownHomePopup = true;
        CarouselPopupModal.show(
          context,
          modals,
          onDismissForToday: () {
            ref.read(popupModalDismissedProvider.notifier).dismissForToday();
          },
        );
      }
    } catch (e) {
      debugPrint('Failed to show popup modal: $e');
    } finally {
      _isCheckingPopup = false;
    }
  }

  Future<void> _onRefresh() async {
    final authData = ref.read(authProvider);
    if (authData != null) {
      await Future.wait([
        ref.read(profileProvider.notifier).fetchProfile(),
        ref.read(walletProvider.notifier).fetchWalletData(),
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: AppColors.secondaryHighlightColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 64,
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: GestureDetector(
          onTapDown: (_) {
            _logoLongPressTimer?.cancel();
            _logoLongPressTimer = Timer(const Duration(seconds: 3), () {
              setState(() {
                _showGameModeButton = !_showGameModeButton;
              });
              // 震動回饋提示 (可選)
              HapticFeedback.heavyImpact();
            });
          },
          onTapUp: (_) => _logoLongPressTimer?.cancel(),
          onTapCancel: () => _logoLongPressTimer?.cancel(),
          child: Image.asset(
            'assets/images/ecoco_logo_pure.png',
            height: 25,
            errorBuilder: (context, error, stackTrace) {
              return const Text(
                'ECOCO',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              );
            },
          ),
        ),
        actions: [
          if (_showGameModeButton)
            IconButton(
              icon: const Icon(Icons.sports_esports, color: Colors.white),
              onPressed: () => ref.read(appModeStateProvider.notifier).toggleMode(),
            ),
          _buildNotificationButton(),
        ],
      ),
      body: Container(
        color: AppColors.secondaryHighlightColor,
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          color: AppColors.primaryHighlightColor,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
              color: AppColors.greyBackground,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(14, 0, 18, 2),
                    height: 40,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppColors.secondaryHighlightColor,
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text("可可粉，歡迎回來！", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                    ),
                  ),
                  // User Info Card with dual-color background
                  Stack(
                    children: [
                      // Dual-color background
                      Column(
                        children: [
                          // Yellow background (top half)
                          Container(
                            height: 125,
                            decoration: const BoxDecoration(
                              color: AppColors.secondaryHighlightColor,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                            ),
                          ),
                          // White background (bottom half)
                          Container(
                            height: 35,
                            color: AppColors.greyBackground,
                          ),
                        ],
                      ),
                      // User Info Card on top
                      const UserInfoCard(),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Action Buttons Grid
                  const ActionButtonsGrid(),

                  const SizedBox(height: 24),

                  // Promotion Banner
                  const PromotionBanner(),

                  const SizedBox(height: 24),

                  // Activity Section
                  const ActivitySection(),

                  const SizedBox(height: 122),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
