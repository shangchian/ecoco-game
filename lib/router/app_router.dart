import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:ecoco_app/models/verify_otp_response_model.dart';
import '../feature/game/models/monster_model.dart';
import '../models/voucher_model.dart';
import '/pages/main/profile/points_history_page.dart';
import '/router/auth_guard.dart';
import '/pages/splash_page.dart';
import '/pages/login_page.dart';
import '/pages/main/main_screen.dart';
import '/pages/main/home_page.dart';
import '/feature/game/pages/game_home_screen.dart';
import '/feature/game/pages/battle_screen.dart';
import '/pages/main/profile/profile_page.dart';
import '/pages/main/rewards_page.dart';
import '/pages/main/rewards/merchant_reward_exchange_page.dart';
import '/pages/main/rewards/merchant_reward_exchange_confirm_page.dart';
import '/pages/main/rewards/merchant_reward_qr_pos_exchange_page.dart';
import '/pages/main/rewards/merchant_reward_verification_code_qr_exchange_page.dart';
import '/pages/main/rewards/merchant_reward_verification_code_input_page.dart';
import '/pages/main/rewards/merchant_reward_redemption_code_page.dart';
import '/pages/main/rewards/merchant_reward_ticket_qr_info_page.dart';
import '/pages/main/rewards/merchant_reward_ticket_info_page.dart';
import '/pages/main/rewards/voucher_wallet_page.dart';
import '/pages/main/rewards/voucher_used_info_page.dart';
import '/pages/main/sites/site_page.dart';
import '/pages/main/sites/favorite_sites_page.dart';
import '/pages/merchant/merchant_detail_page.dart';
import '/pages/merchant/merchant_detail_by_id_page.dart';
import '/pages/merchant/merchant_list_page.dart';
import '/pages/main/rewards/merchant_reward_exchange_by_id_page.dart';
import '/pages/common/markdown_viewer_page.dart';
import '/pages/register/register_page.dart';
import '/pages/forget_password/forget_password_page.dart';
import '/pages/main/profile/edit_profile_page.dart';
import '/pages/main/profile/account_security_page.dart';
import '/pages/main/profile/delete_account_page.dart';
import '/pages/main/profile/change_password_page.dart';
import '/pages/main/profile/point_transfer/point_transfer_page.dart';
import '/pages/main/profile/point_transfer/point_transfer_confirm_page.dart';
import '/pages/main/profile/notification_settings_page.dart';
import '/pages/main/notifications/notifications_page.dart';
import '/pages/main/profile/permission_management_page.dart';
import '/pages/main/profile/rights_page.dart';
import '/pages/main/profile/version_page.dart';
import '/models/brand_model.dart';
import '/models/coupon_rule.dart';
import '/models/member_coupon_with_rule.dart';
import '/models/prepare_coupon_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

part 'app_router.gr.dart';

final appRouterProvider =
    Provider((ref) => AppRouter(authGuard: AuthGuard(ref)));

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  AuthGuard authGuard;

  AppRouter({required this.authGuard});

  @override
  RouteType get defaultRouteType => RouteType.material();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, initial: true),
        AutoRoute(page: LoginRoute.page),
        AutoRoute(page: RegisterRoute.page),
        AutoRoute(page: ForgetPasswordRoute.page),
        AutoRoute(page: EditProfileRoute.page, guards: [authGuard]),
        AutoRoute(
          page: MainRoute.page,
          guards: [authGuard],
          children: [
            AutoRoute(page: HomeRoute.page),
            AutoRoute(page: SiteRoute.page),
            AutoRoute(page: RewardsRoute.page),
            AutoRoute(page: ProfileRoute.page),
          ],
        ),
        AutoRoute(page: AccountSecurityRoute.page),
        AutoRoute(page: DeleteAccountRoute.page),
        AutoRoute(page: ChangePasswordRoute.page),
        AutoRoute(page: PointTransferRoute.page),
        AutoRoute(page: PointTransferConfirmRoute.page),
        AutoRoute(page: NotificationSettingsRoute.page),
        AutoRoute(page: NotificationsRoute.page, guards: [authGuard]),
        AutoRoute(page: PermissionManagementRoute.page),
        AutoRoute(page: RightsRoute.page),
        AutoRoute(page: PointsHistoryRoute.page),
        AutoRoute(page: VersionRoute.page),
        AutoRoute(page: MerchantRewardExchangeRoute.page),
        AutoRoute(page: MerchantRewardExchangeConfirmRoute.page),
        AutoRoute(page: MerchantRewardQrPosExchangeRoute.page),
        AutoRoute(page: MerchantRewardVerificationCodeQrExchangeRoute.page),
        AutoRoute(page: MerchantRewardVerificationCodeInputRoute.page),
        AutoRoute(page: MerchantRewardRedemptionCodeRoute.page),
        AutoRoute(page: MerchantRewardTicketQrInfoRoute.page),
        AutoRoute(page: MerchantRewardTicketInfoRoute.page),
        AutoRoute(page: VoucherWalletRoute.page),
        AutoRoute(page: VoucherUsedInfoRoute.page),
        AutoRoute(page: FavoriteSitesRoute.page),
        AutoRoute(page: MerchantDetailRoute.page),
        AutoRoute(page: MerchantDetailByIdRoute.page),
        AutoRoute(page: MerchantListRoute.page),
        AutoRoute(page: MerchantRewardExchangeByIdRoute.page),
        AutoRoute(page: MarkdownViewerRoute.page),
        AutoRoute(page: GameHomeRoute.page, guards: [authGuard]),
        AutoRoute(page: BattleRoute.page, guards: [authGuard]),
      ];
}
