// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [AccountSecurityPage]
class AccountSecurityRoute extends PageRouteInfo<void> {
  const AccountSecurityRoute({List<PageRouteInfo>? children})
    : super(AccountSecurityRoute.name, initialChildren: children);

  static const String name = 'AccountSecurityRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AccountSecurityPage();
    },
  );
}

/// generated route for
/// [BattleScreen]
class BattleRoute extends PageRouteInfo<BattleRouteArgs> {
  BattleRoute({
    Key? key,
    required MonsterModel monster,
    List<PageRouteInfo>? children,
  }) : super(
         BattleRoute.name,
         args: BattleRouteArgs(key: key, monster: monster),
         initialChildren: children,
       );

  static const String name = 'BattleRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<BattleRouteArgs>();
      return BattleScreen(key: args.key, monster: args.monster);
    },
  );
}

class BattleRouteArgs {
  const BattleRouteArgs({this.key, required this.monster});

  final Key? key;

  final MonsterModel monster;

  @override
  String toString() {
    return 'BattleRouteArgs{key: $key, monster: $monster}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BattleRouteArgs) return false;
    return key == other.key && monster == other.monster;
  }

  @override
  int get hashCode => key.hashCode ^ monster.hashCode;
}

/// generated route for
/// [ChangePasswordPage]
class ChangePasswordRoute extends PageRouteInfo<void> {
  const ChangePasswordRoute({List<PageRouteInfo>? children})
    : super(ChangePasswordRoute.name, initialChildren: children);

  static const String name = 'ChangePasswordRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ChangePasswordPage();
    },
  );
}

/// generated route for
/// [DeleteAccountPage]
class DeleteAccountRoute extends PageRouteInfo<void> {
  const DeleteAccountRoute({List<PageRouteInfo>? children})
    : super(DeleteAccountRoute.name, initialChildren: children);

  static const String name = 'DeleteAccountRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DeleteAccountPage();
    },
  );
}

/// generated route for
/// [EditProfilePage]
class EditProfileRoute extends PageRouteInfo<void> {
  const EditProfileRoute({List<PageRouteInfo>? children})
    : super(EditProfileRoute.name, initialChildren: children);

  static const String name = 'EditProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const EditProfilePage();
    },
  );
}

/// generated route for
/// [FavoriteSitesPage]
class FavoriteSitesRoute extends PageRouteInfo<void> {
  const FavoriteSitesRoute({List<PageRouteInfo>? children})
    : super(FavoriteSitesRoute.name, initialChildren: children);

  static const String name = 'FavoriteSitesRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FavoriteSitesPage();
    },
  );
}

/// generated route for
/// [ForgetPasswordPage]
class ForgetPasswordRoute extends PageRouteInfo<void> {
  const ForgetPasswordRoute({List<PageRouteInfo>? children})
    : super(ForgetPasswordRoute.name, initialChildren: children);

  static const String name = 'ForgetPasswordRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ForgetPasswordPage();
    },
  );
}

/// generated route for
/// [GameHomeScreen]
class GameHomeRoute extends PageRouteInfo<void> {
  const GameHomeRoute({List<PageRouteInfo>? children})
    : super(GameHomeRoute.name, initialChildren: children);

  static const String name = 'GameHomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const GameHomeScreen();
    },
  );
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomePage();
    },
  );
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<LoginRouteArgs> {
  LoginRoute({
    Key? key,
    Future<void> Function(String, String)? onLoginSuccess,
    bool relogin = false,
    bool forceBiometric = false,
    String? phoneNumber,
    bool isLogout = false,
    List<PageRouteInfo>? children,
  }) : super(
         LoginRoute.name,
         args: LoginRouteArgs(
           key: key,
           onLoginSuccess: onLoginSuccess,
           relogin: relogin,
           forceBiometric: forceBiometric,
           phoneNumber: phoneNumber,
           isLogout: isLogout,
         ),
         initialChildren: children,
       );

  static const String name = 'LoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<LoginRouteArgs>(
        orElse: () => const LoginRouteArgs(),
      );
      return LoginPage(
        key: args.key,
        onLoginSuccess: args.onLoginSuccess,
        relogin: args.relogin,
        forceBiometric: args.forceBiometric,
        phoneNumber: args.phoneNumber,
        isLogout: args.isLogout,
      );
    },
  );
}

class LoginRouteArgs {
  const LoginRouteArgs({
    this.key,
    this.onLoginSuccess,
    this.relogin = false,
    this.forceBiometric = false,
    this.phoneNumber,
    this.isLogout = false,
  });

  final Key? key;

  final Future<void> Function(String, String)? onLoginSuccess;

  final bool relogin;

  final bool forceBiometric;

  final String? phoneNumber;

  final bool isLogout;

  @override
  String toString() {
    return 'LoginRouteArgs{key: $key, onLoginSuccess: $onLoginSuccess, relogin: $relogin, forceBiometric: $forceBiometric, phoneNumber: $phoneNumber, isLogout: $isLogout}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! LoginRouteArgs) return false;
    return key == other.key &&
        relogin == other.relogin &&
        forceBiometric == other.forceBiometric &&
        phoneNumber == other.phoneNumber &&
        isLogout == other.isLogout;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      relogin.hashCode ^
      forceBiometric.hashCode ^
      phoneNumber.hashCode ^
      isLogout.hashCode;
}

/// generated route for
/// [MainScreen]
class MainRoute extends PageRouteInfo<void> {
  const MainRoute({List<PageRouteInfo>? children})
    : super(MainRoute.name, initialChildren: children);

  static const String name = 'MainRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MainScreen();
    },
  );
}

/// generated route for
/// [MarkdownViewerPage]
class MarkdownViewerRoute extends PageRouteInfo<MarkdownViewerRouteArgs> {
  MarkdownViewerRoute({
    Key? key,
    required String title,
    String? tagText,
    String? contentTitle,
    String? url,
    String? localAssetPath,
    String? pageType,
    List<PageRouteInfo>? children,
  }) : super(
         MarkdownViewerRoute.name,
         args: MarkdownViewerRouteArgs(
           key: key,
           title: title,
           tagText: tagText,
           contentTitle: contentTitle,
           url: url,
           localAssetPath: localAssetPath,
           pageType: pageType,
         ),
         initialChildren: children,
       );

  static const String name = 'MarkdownViewerRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MarkdownViewerRouteArgs>();
      return MarkdownViewerPage(
        key: args.key,
        title: args.title,
        tagText: args.tagText,
        contentTitle: args.contentTitle,
        url: args.url,
        localAssetPath: args.localAssetPath,
        pageType: args.pageType,
      );
    },
  );
}

class MarkdownViewerRouteArgs {
  const MarkdownViewerRouteArgs({
    this.key,
    required this.title,
    this.tagText,
    this.contentTitle,
    this.url,
    this.localAssetPath,
    this.pageType,
  });

  final Key? key;

  final String title;

  final String? tagText;

  final String? contentTitle;

  final String? url;

  final String? localAssetPath;

  final String? pageType;

  @override
  String toString() {
    return 'MarkdownViewerRouteArgs{key: $key, title: $title, tagText: $tagText, contentTitle: $contentTitle, url: $url, localAssetPath: $localAssetPath, pageType: $pageType}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MarkdownViewerRouteArgs) return false;
    return key == other.key &&
        title == other.title &&
        tagText == other.tagText &&
        contentTitle == other.contentTitle &&
        url == other.url &&
        localAssetPath == other.localAssetPath &&
        pageType == other.pageType;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      title.hashCode ^
      tagText.hashCode ^
      contentTitle.hashCode ^
      url.hashCode ^
      localAssetPath.hashCode ^
      pageType.hashCode;
}

/// generated route for
/// [MerchantDetailByIdPage]
class MerchantDetailByIdRoute
    extends PageRouteInfo<MerchantDetailByIdRouteArgs> {
  MerchantDetailByIdRoute({
    Key? key,
    required String brandId,
    List<PageRouteInfo>? children,
  }) : super(
         MerchantDetailByIdRoute.name,
         args: MerchantDetailByIdRouteArgs(key: key, brandId: brandId),
         rawPathParams: {'brandId': brandId},
         initialChildren: children,
       );

  static const String name = 'MerchantDetailByIdRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<MerchantDetailByIdRouteArgs>(
        orElse: () => MerchantDetailByIdRouteArgs(
          brandId: pathParams.getString('brandId'),
        ),
      );
      return MerchantDetailByIdPage(key: args.key, brandId: args.brandId);
    },
  );
}

class MerchantDetailByIdRouteArgs {
  const MerchantDetailByIdRouteArgs({this.key, required this.brandId});

  final Key? key;

  final String brandId;

  @override
  String toString() {
    return 'MerchantDetailByIdRouteArgs{key: $key, brandId: $brandId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MerchantDetailByIdRouteArgs) return false;
    return key == other.key && brandId == other.brandId;
  }

  @override
  int get hashCode => key.hashCode ^ brandId.hashCode;
}

/// generated route for
/// [MerchantDetailPage]
class MerchantDetailRoute extends PageRouteInfo<MerchantDetailRouteArgs> {
  MerchantDetailRoute({
    Key? key,
    required Brand brand,
    List<PageRouteInfo>? children,
  }) : super(
         MerchantDetailRoute.name,
         args: MerchantDetailRouteArgs(key: key, brand: brand),
         initialChildren: children,
       );

  static const String name = 'MerchantDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MerchantDetailRouteArgs>();
      return MerchantDetailPage(key: args.key, brand: args.brand);
    },
  );
}

class MerchantDetailRouteArgs {
  const MerchantDetailRouteArgs({this.key, required this.brand});

  final Key? key;

  final Brand brand;

  @override
  String toString() {
    return 'MerchantDetailRouteArgs{key: $key, brand: $brand}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MerchantDetailRouteArgs) return false;
    return key == other.key && brand == other.brand;
  }

  @override
  int get hashCode => key.hashCode ^ brand.hashCode;
}

/// generated route for
/// [MerchantListPage]
class MerchantListRoute extends PageRouteInfo<void> {
  const MerchantListRoute({List<PageRouteInfo>? children})
    : super(MerchantListRoute.name, initialChildren: children);

  static const String name = 'MerchantListRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MerchantListPage();
    },
  );
}

/// generated route for
/// [MerchantRewardExchangeByIdPage]
class MerchantRewardExchangeByIdRoute
    extends PageRouteInfo<MerchantRewardExchangeByIdRouteArgs> {
  MerchantRewardExchangeByIdRoute({
    Key? key,
    required String couponRuleId,
    List<PageRouteInfo>? children,
  }) : super(
         MerchantRewardExchangeByIdRoute.name,
         args: MerchantRewardExchangeByIdRouteArgs(
           key: key,
           couponRuleId: couponRuleId,
         ),
         rawPathParams: {'couponRuleId': couponRuleId},
         initialChildren: children,
       );

  static const String name = 'MerchantRewardExchangeByIdRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<MerchantRewardExchangeByIdRouteArgs>(
        orElse: () => MerchantRewardExchangeByIdRouteArgs(
          couponRuleId: pathParams.getString('couponRuleId'),
        ),
      );
      return MerchantRewardExchangeByIdPage(
        key: args.key,
        couponRuleId: args.couponRuleId,
      );
    },
  );
}

class MerchantRewardExchangeByIdRouteArgs {
  const MerchantRewardExchangeByIdRouteArgs({
    this.key,
    required this.couponRuleId,
  });

  final Key? key;

  final String couponRuleId;

  @override
  String toString() {
    return 'MerchantRewardExchangeByIdRouteArgs{key: $key, couponRuleId: $couponRuleId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MerchantRewardExchangeByIdRouteArgs) return false;
    return key == other.key && couponRuleId == other.couponRuleId;
  }

  @override
  int get hashCode => key.hashCode ^ couponRuleId.hashCode;
}

/// generated route for
/// [MerchantRewardExchangeConfirmPage]
class MerchantRewardExchangeConfirmRoute
    extends PageRouteInfo<MerchantRewardExchangeConfirmRouteArgs> {
  MerchantRewardExchangeConfirmRoute({
    Key? key,
    required CouponRule couponRule,
    int userPoints = 0,
    int? maxExchangeableUnits,
    List<PageRouteInfo>? children,
  }) : super(
         MerchantRewardExchangeConfirmRoute.name,
         args: MerchantRewardExchangeConfirmRouteArgs(
           key: key,
           couponRule: couponRule,
           userPoints: userPoints,
           maxExchangeableUnits: maxExchangeableUnits,
         ),
         initialChildren: children,
       );

  static const String name = 'MerchantRewardExchangeConfirmRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MerchantRewardExchangeConfirmRouteArgs>();
      return MerchantRewardExchangeConfirmPage(
        key: args.key,
        couponRule: args.couponRule,
        userPoints: args.userPoints,
        maxExchangeableUnits: args.maxExchangeableUnits,
      );
    },
  );
}

class MerchantRewardExchangeConfirmRouteArgs {
  const MerchantRewardExchangeConfirmRouteArgs({
    this.key,
    required this.couponRule,
    this.userPoints = 0,
    this.maxExchangeableUnits,
  });

  final Key? key;

  final CouponRule couponRule;

  final int userPoints;

  final int? maxExchangeableUnits;

  @override
  String toString() {
    return 'MerchantRewardExchangeConfirmRouteArgs{key: $key, couponRule: $couponRule, userPoints: $userPoints, maxExchangeableUnits: $maxExchangeableUnits}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MerchantRewardExchangeConfirmRouteArgs) return false;
    return key == other.key &&
        couponRule == other.couponRule &&
        userPoints == other.userPoints &&
        maxExchangeableUnits == other.maxExchangeableUnits;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      couponRule.hashCode ^
      userPoints.hashCode ^
      maxExchangeableUnits.hashCode;
}

/// generated route for
/// [MerchantRewardExchangePage]
class MerchantRewardExchangeRoute
    extends PageRouteInfo<MerchantRewardExchangeRouteArgs> {
  MerchantRewardExchangeRoute({
    Key? key,
    required CouponRule couponRule,
    int userPoints = 0,
    List<PageRouteInfo>? children,
  }) : super(
         MerchantRewardExchangeRoute.name,
         args: MerchantRewardExchangeRouteArgs(
           key: key,
           couponRule: couponRule,
           userPoints: userPoints,
         ),
         initialChildren: children,
       );

  static const String name = 'MerchantRewardExchangeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MerchantRewardExchangeRouteArgs>();
      return MerchantRewardExchangePage(
        key: args.key,
        couponRule: args.couponRule,
        userPoints: args.userPoints,
      );
    },
  );
}

class MerchantRewardExchangeRouteArgs {
  const MerchantRewardExchangeRouteArgs({
    this.key,
    required this.couponRule,
    this.userPoints = 0,
  });

  final Key? key;

  final CouponRule couponRule;

  final int userPoints;

  @override
  String toString() {
    return 'MerchantRewardExchangeRouteArgs{key: $key, couponRule: $couponRule, userPoints: $userPoints}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MerchantRewardExchangeRouteArgs) return false;
    return key == other.key &&
        couponRule == other.couponRule &&
        userPoints == other.userPoints;
  }

  @override
  int get hashCode => key.hashCode ^ couponRule.hashCode ^ userPoints.hashCode;
}

/// generated route for
/// [MerchantRewardQrPosExchangePage]
class MerchantRewardQrPosExchangeRoute
    extends PageRouteInfo<MerchantRewardQrPosExchangeRouteArgs> {
  MerchantRewardQrPosExchangeRoute({
    Key? key,
    required MemberCouponWithRule memberCouponWithRule,
    required PrepareCouponResponse prepareResponse,
    List<PageRouteInfo>? children,
  }) : super(
         MerchantRewardQrPosExchangeRoute.name,
         args: MerchantRewardQrPosExchangeRouteArgs(
           key: key,
           memberCouponWithRule: memberCouponWithRule,
           prepareResponse: prepareResponse,
         ),
         initialChildren: children,
       );

  static const String name = 'MerchantRewardQrPosExchangeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MerchantRewardQrPosExchangeRouteArgs>();
      return MerchantRewardQrPosExchangePage(
        key: args.key,
        memberCouponWithRule: args.memberCouponWithRule,
        prepareResponse: args.prepareResponse,
      );
    },
  );
}

class MerchantRewardQrPosExchangeRouteArgs {
  const MerchantRewardQrPosExchangeRouteArgs({
    this.key,
    required this.memberCouponWithRule,
    required this.prepareResponse,
  });

  final Key? key;

  final MemberCouponWithRule memberCouponWithRule;

  final PrepareCouponResponse prepareResponse;

  @override
  String toString() {
    return 'MerchantRewardQrPosExchangeRouteArgs{key: $key, memberCouponWithRule: $memberCouponWithRule, prepareResponse: $prepareResponse}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MerchantRewardQrPosExchangeRouteArgs) return false;
    return key == other.key &&
        memberCouponWithRule == other.memberCouponWithRule &&
        prepareResponse == other.prepareResponse;
  }

  @override
  int get hashCode =>
      key.hashCode ^ memberCouponWithRule.hashCode ^ prepareResponse.hashCode;
}

/// generated route for
/// [MerchantRewardRedemptionCodePage]
class MerchantRewardRedemptionCodeRoute
    extends PageRouteInfo<MerchantRewardRedemptionCodeRouteArgs> {
  MerchantRewardRedemptionCodeRoute({
    Key? key,
    required CouponRule couponRule,
    required String memberCouponId,
    int userPoints = 0,
    VoucherStatus initialStatus = VoucherStatus.active,
    List<PageRouteInfo>? children,
  }) : super(
         MerchantRewardRedemptionCodeRoute.name,
         args: MerchantRewardRedemptionCodeRouteArgs(
           key: key,
           couponRule: couponRule,
           memberCouponId: memberCouponId,
           userPoints: userPoints,
           initialStatus: initialStatus,
         ),
         initialChildren: children,
       );

  static const String name = 'MerchantRewardRedemptionCodeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MerchantRewardRedemptionCodeRouteArgs>();
      return MerchantRewardRedemptionCodePage(
        key: args.key,
        couponRule: args.couponRule,
        memberCouponId: args.memberCouponId,
        userPoints: args.userPoints,
        initialStatus: args.initialStatus,
      );
    },
  );
}

class MerchantRewardRedemptionCodeRouteArgs {
  const MerchantRewardRedemptionCodeRouteArgs({
    this.key,
    required this.couponRule,
    required this.memberCouponId,
    this.userPoints = 0,
    this.initialStatus = VoucherStatus.active,
  });

  final Key? key;

  final CouponRule couponRule;

  final String memberCouponId;

  final int userPoints;

  final VoucherStatus initialStatus;

  @override
  String toString() {
    return 'MerchantRewardRedemptionCodeRouteArgs{key: $key, couponRule: $couponRule, memberCouponId: $memberCouponId, userPoints: $userPoints, initialStatus: $initialStatus}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MerchantRewardRedemptionCodeRouteArgs) return false;
    return key == other.key &&
        couponRule == other.couponRule &&
        memberCouponId == other.memberCouponId &&
        userPoints == other.userPoints &&
        initialStatus == other.initialStatus;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      couponRule.hashCode ^
      memberCouponId.hashCode ^
      userPoints.hashCode ^
      initialStatus.hashCode;
}

/// generated route for
/// [MerchantRewardTicketInfoPage]
class MerchantRewardTicketInfoRoute
    extends PageRouteInfo<MerchantRewardTicketInfoRouteArgs> {
  MerchantRewardTicketInfoRoute({
    Key? key,
    required CouponRule couponRule,
    int userPoints = 0,
    List<PageRouteInfo>? children,
  }) : super(
         MerchantRewardTicketInfoRoute.name,
         args: MerchantRewardTicketInfoRouteArgs(
           key: key,
           couponRule: couponRule,
           userPoints: userPoints,
         ),
         initialChildren: children,
       );

  static const String name = 'MerchantRewardTicketInfoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MerchantRewardTicketInfoRouteArgs>();
      return MerchantRewardTicketInfoPage(
        key: args.key,
        couponRule: args.couponRule,
        userPoints: args.userPoints,
      );
    },
  );
}

class MerchantRewardTicketInfoRouteArgs {
  const MerchantRewardTicketInfoRouteArgs({
    this.key,
    required this.couponRule,
    this.userPoints = 0,
  });

  final Key? key;

  final CouponRule couponRule;

  final int userPoints;

  @override
  String toString() {
    return 'MerchantRewardTicketInfoRouteArgs{key: $key, couponRule: $couponRule, userPoints: $userPoints}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MerchantRewardTicketInfoRouteArgs) return false;
    return key == other.key &&
        couponRule == other.couponRule &&
        userPoints == other.userPoints;
  }

  @override
  int get hashCode => key.hashCode ^ couponRule.hashCode ^ userPoints.hashCode;
}

/// generated route for
/// [MerchantRewardTicketQrInfoPage]
class MerchantRewardTicketQrInfoRoute
    extends PageRouteInfo<MerchantRewardTicketQrInfoRouteArgs> {
  MerchantRewardTicketQrInfoRoute({
    Key? key,
    required CouponRule couponRule,
    required String memberCouponId,
    int userPoints = 0,
    VoucherStatus initialStatus = VoucherStatus.active,
    List<PageRouteInfo>? children,
  }) : super(
         MerchantRewardTicketQrInfoRoute.name,
         args: MerchantRewardTicketQrInfoRouteArgs(
           key: key,
           couponRule: couponRule,
           memberCouponId: memberCouponId,
           userPoints: userPoints,
           initialStatus: initialStatus,
         ),
         initialChildren: children,
       );

  static const String name = 'MerchantRewardTicketQrInfoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MerchantRewardTicketQrInfoRouteArgs>();
      return MerchantRewardTicketQrInfoPage(
        key: args.key,
        couponRule: args.couponRule,
        memberCouponId: args.memberCouponId,
        userPoints: args.userPoints,
        initialStatus: args.initialStatus,
      );
    },
  );
}

class MerchantRewardTicketQrInfoRouteArgs {
  const MerchantRewardTicketQrInfoRouteArgs({
    this.key,
    required this.couponRule,
    required this.memberCouponId,
    this.userPoints = 0,
    this.initialStatus = VoucherStatus.active,
  });

  final Key? key;

  final CouponRule couponRule;

  final String memberCouponId;

  final int userPoints;

  final VoucherStatus initialStatus;

  @override
  String toString() {
    return 'MerchantRewardTicketQrInfoRouteArgs{key: $key, couponRule: $couponRule, memberCouponId: $memberCouponId, userPoints: $userPoints, initialStatus: $initialStatus}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MerchantRewardTicketQrInfoRouteArgs) return false;
    return key == other.key &&
        couponRule == other.couponRule &&
        memberCouponId == other.memberCouponId &&
        userPoints == other.userPoints &&
        initialStatus == other.initialStatus;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      couponRule.hashCode ^
      memberCouponId.hashCode ^
      userPoints.hashCode ^
      initialStatus.hashCode;
}

/// generated route for
/// [MerchantRewardVerificationCodeInputPage]
class MerchantRewardVerificationCodeInputRoute
    extends PageRouteInfo<MerchantRewardVerificationCodeInputRouteArgs> {
  MerchantRewardVerificationCodeInputRoute({
    Key? key,
    required CouponRule couponRule,
    int userPoints = 0,
    int exchangeQuantity = 0,
    int requiredPoints = 0,
    List<PageRouteInfo>? children,
  }) : super(
         MerchantRewardVerificationCodeInputRoute.name,
         args: MerchantRewardVerificationCodeInputRouteArgs(
           key: key,
           couponRule: couponRule,
           userPoints: userPoints,
           exchangeQuantity: exchangeQuantity,
           requiredPoints: requiredPoints,
         ),
         initialChildren: children,
       );

  static const String name = 'MerchantRewardVerificationCodeInputRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MerchantRewardVerificationCodeInputRouteArgs>();
      return MerchantRewardVerificationCodeInputPage(
        key: args.key,
        couponRule: args.couponRule,
        userPoints: args.userPoints,
        exchangeQuantity: args.exchangeQuantity,
        requiredPoints: args.requiredPoints,
      );
    },
  );
}

class MerchantRewardVerificationCodeInputRouteArgs {
  const MerchantRewardVerificationCodeInputRouteArgs({
    this.key,
    required this.couponRule,
    this.userPoints = 0,
    this.exchangeQuantity = 0,
    this.requiredPoints = 0,
  });

  final Key? key;

  final CouponRule couponRule;

  final int userPoints;

  final int exchangeQuantity;

  final int requiredPoints;

  @override
  String toString() {
    return 'MerchantRewardVerificationCodeInputRouteArgs{key: $key, couponRule: $couponRule, userPoints: $userPoints, exchangeQuantity: $exchangeQuantity, requiredPoints: $requiredPoints}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MerchantRewardVerificationCodeInputRouteArgs) return false;
    return key == other.key &&
        couponRule == other.couponRule &&
        userPoints == other.userPoints &&
        exchangeQuantity == other.exchangeQuantity &&
        requiredPoints == other.requiredPoints;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      couponRule.hashCode ^
      userPoints.hashCode ^
      exchangeQuantity.hashCode ^
      requiredPoints.hashCode;
}

/// generated route for
/// [MerchantRewardVerificationCodeQrExchangePage]
class MerchantRewardVerificationCodeQrExchangeRoute
    extends PageRouteInfo<MerchantRewardVerificationCodeQrExchangeRouteArgs> {
  MerchantRewardVerificationCodeQrExchangeRoute({
    Key? key,
    required List<MemberCouponWithRule> memberCouponsWithRules,
    required CouponRule couponRule,
    List<PageRouteInfo>? children,
  }) : super(
         MerchantRewardVerificationCodeQrExchangeRoute.name,
         args: MerchantRewardVerificationCodeQrExchangeRouteArgs(
           key: key,
           memberCouponsWithRules: memberCouponsWithRules,
           couponRule: couponRule,
         ),
         initialChildren: children,
       );

  static const String name = 'MerchantRewardVerificationCodeQrExchangeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data
          .argsAs<MerchantRewardVerificationCodeQrExchangeRouteArgs>();
      return MerchantRewardVerificationCodeQrExchangePage(
        key: args.key,
        memberCouponsWithRules: args.memberCouponsWithRules,
        couponRule: args.couponRule,
      );
    },
  );
}

class MerchantRewardVerificationCodeQrExchangeRouteArgs {
  const MerchantRewardVerificationCodeQrExchangeRouteArgs({
    this.key,
    required this.memberCouponsWithRules,
    required this.couponRule,
  });

  final Key? key;

  final List<MemberCouponWithRule> memberCouponsWithRules;

  final CouponRule couponRule;

  @override
  String toString() {
    return 'MerchantRewardVerificationCodeQrExchangeRouteArgs{key: $key, memberCouponsWithRules: $memberCouponsWithRules, couponRule: $couponRule}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MerchantRewardVerificationCodeQrExchangeRouteArgs)
      return false;
    return key == other.key &&
        const ListEquality<MemberCouponWithRule>().equals(
          memberCouponsWithRules,
          other.memberCouponsWithRules,
        ) &&
        couponRule == other.couponRule;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      const ListEquality<MemberCouponWithRule>().hash(memberCouponsWithRules) ^
      couponRule.hashCode;
}

/// generated route for
/// [NotificationSettingsPage]
class NotificationSettingsRoute extends PageRouteInfo<void> {
  const NotificationSettingsRoute({List<PageRouteInfo>? children})
    : super(NotificationSettingsRoute.name, initialChildren: children);

  static const String name = 'NotificationSettingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const NotificationSettingsPage();
    },
  );
}

/// generated route for
/// [NotificationsPage]
class NotificationsRoute extends PageRouteInfo<NotificationsRouteArgs> {
  NotificationsRoute({Key? key, String? tab, List<PageRouteInfo>? children})
    : super(
        NotificationsRoute.name,
        args: NotificationsRouteArgs(key: key, tab: tab),
        rawQueryParams: {'tab': tab},
        initialChildren: children,
      );

  static const String name = 'NotificationsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final queryParams = data.queryParams;
      final args = data.argsAs<NotificationsRouteArgs>(
        orElse: () => NotificationsRouteArgs(tab: queryParams.optString('tab')),
      );
      return NotificationsPage(key: args.key, tab: args.tab);
    },
  );
}

class NotificationsRouteArgs {
  const NotificationsRouteArgs({this.key, this.tab});

  final Key? key;

  final String? tab;

  @override
  String toString() {
    return 'NotificationsRouteArgs{key: $key, tab: $tab}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! NotificationsRouteArgs) return false;
    return key == other.key && tab == other.tab;
  }

  @override
  int get hashCode => key.hashCode ^ tab.hashCode;
}

/// generated route for
/// [PermissionManagementPage]
class PermissionManagementRoute extends PageRouteInfo<void> {
  const PermissionManagementRoute({List<PageRouteInfo>? children})
    : super(PermissionManagementRoute.name, initialChildren: children);

  static const String name = 'PermissionManagementRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PermissionManagementPage();
    },
  );
}

/// generated route for
/// [PointTransferConfirmPage]
class PointTransferConfirmRoute extends PageRouteInfo<void> {
  const PointTransferConfirmRoute({List<PageRouteInfo>? children})
    : super(PointTransferConfirmRoute.name, initialChildren: children);

  static const String name = 'PointTransferConfirmRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PointTransferConfirmPage();
    },
  );
}

/// generated route for
/// [PointTransferPage]
class PointTransferRoute extends PageRouteInfo<void> {
  const PointTransferRoute({List<PageRouteInfo>? children})
    : super(PointTransferRoute.name, initialChildren: children);

  static const String name = 'PointTransferRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PointTransferPage();
    },
  );
}

/// generated route for
/// [PointsHistoryPage]
class PointsHistoryRoute extends PageRouteInfo<void> {
  const PointsHistoryRoute({List<PageRouteInfo>? children})
    : super(PointsHistoryRoute.name, initialChildren: children);

  static const String name = 'PointsHistoryRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PointsHistoryPage();
    },
  );
}

/// generated route for
/// [ProfilePage]
class ProfileRoute extends PageRouteInfo<ProfileRouteArgs> {
  ProfileRoute({
    Key? key,
    required dynamic Function(bool) onLoadingChanged,
    List<PageRouteInfo>? children,
  }) : super(
         ProfileRoute.name,
         args: ProfileRouteArgs(key: key, onLoadingChanged: onLoadingChanged),
         initialChildren: children,
       );

  static const String name = 'ProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ProfileRouteArgs>();
      return ProfilePage(
        key: args.key,
        onLoadingChanged: args.onLoadingChanged,
      );
    },
  );
}

class ProfileRouteArgs {
  const ProfileRouteArgs({this.key, required this.onLoadingChanged});

  final Key? key;

  final dynamic Function(bool) onLoadingChanged;

  @override
  String toString() {
    return 'ProfileRouteArgs{key: $key, onLoadingChanged: $onLoadingChanged}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ProfileRouteArgs) return false;
    return key == other.key;
  }

  @override
  int get hashCode => key.hashCode;
}

/// generated route for
/// [RegisterPage]
class RegisterRoute extends PageRouteInfo<RegisterRouteArgs> {
  RegisterRoute({
    Key? key,
    VerifyOtpResponse? initialTokens,
    int? initialStep,
    String? initialPassword,
    String? initialPhone,
    List<PageRouteInfo>? children,
  }) : super(
         RegisterRoute.name,
         args: RegisterRouteArgs(
           key: key,
           initialTokens: initialTokens,
           initialStep: initialStep,
           initialPassword: initialPassword,
           initialPhone: initialPhone,
         ),
         initialChildren: children,
       );

  static const String name = 'RegisterRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<RegisterRouteArgs>(
        orElse: () => const RegisterRouteArgs(),
      );
      return RegisterPage(
        key: args.key,
        initialTokens: args.initialTokens,
        initialStep: args.initialStep,
        initialPassword: args.initialPassword,
        initialPhone: args.initialPhone,
      );
    },
  );
}

class RegisterRouteArgs {
  const RegisterRouteArgs({
    this.key,
    this.initialTokens,
    this.initialStep,
    this.initialPassword,
    this.initialPhone,
  });

  final Key? key;

  final VerifyOtpResponse? initialTokens;

  final int? initialStep;

  final String? initialPassword;

  final String? initialPhone;

  @override
  String toString() {
    return 'RegisterRouteArgs{key: $key, initialTokens: $initialTokens, initialStep: $initialStep, initialPassword: $initialPassword, initialPhone: $initialPhone}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! RegisterRouteArgs) return false;
    return key == other.key &&
        initialTokens == other.initialTokens &&
        initialStep == other.initialStep &&
        initialPassword == other.initialPassword &&
        initialPhone == other.initialPhone;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      initialTokens.hashCode ^
      initialStep.hashCode ^
      initialPassword.hashCode ^
      initialPhone.hashCode;
}

/// generated route for
/// [RewardsPage]
class RewardsRoute extends PageRouteInfo<void> {
  const RewardsRoute({List<PageRouteInfo>? children})
    : super(RewardsRoute.name, initialChildren: children);

  static const String name = 'RewardsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RewardsPage();
    },
  );
}

/// generated route for
/// [RightsPage]
class RightsRoute extends PageRouteInfo<void> {
  const RightsRoute({List<PageRouteInfo>? children})
    : super(RightsRoute.name, initialChildren: children);

  static const String name = 'RightsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RightsPage();
    },
  );
}

/// generated route for
/// [SitePage]
class SiteRoute extends PageRouteInfo<SiteRouteArgs> {
  SiteRoute({
    Key? key,
    required dynamic Function(bool) onLoadingChanged,
    List<PageRouteInfo>? children,
  }) : super(
         SiteRoute.name,
         args: SiteRouteArgs(key: key, onLoadingChanged: onLoadingChanged),
         initialChildren: children,
       );

  static const String name = 'SiteRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SiteRouteArgs>();
      return SitePage(key: args.key, onLoadingChanged: args.onLoadingChanged);
    },
  );
}

class SiteRouteArgs {
  const SiteRouteArgs({this.key, required this.onLoadingChanged});

  final Key? key;

  final dynamic Function(bool) onLoadingChanged;

  @override
  String toString() {
    return 'SiteRouteArgs{key: $key, onLoadingChanged: $onLoadingChanged}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SiteRouteArgs) return false;
    return key == other.key;
  }

  @override
  int get hashCode => key.hashCode;
}

/// generated route for
/// [SplashPage]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SplashPage();
    },
  );
}

/// generated route for
/// [VersionPage]
class VersionRoute extends PageRouteInfo<void> {
  const VersionRoute({List<PageRouteInfo>? children})
    : super(VersionRoute.name, initialChildren: children);

  static const String name = 'VersionRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const VersionPage();
    },
  );
}

/// generated route for
/// [VoucherUsedInfoPage]
class VoucherUsedInfoRoute extends PageRouteInfo<VoucherUsedInfoRouteArgs> {
  VoucherUsedInfoRoute({
    Key? key,
    required CouponRule couponRule,
    required MemberCouponWithRule memberCouponWithRule,
    List<PageRouteInfo>? children,
  }) : super(
         VoucherUsedInfoRoute.name,
         args: VoucherUsedInfoRouteArgs(
           key: key,
           couponRule: couponRule,
           memberCouponWithRule: memberCouponWithRule,
         ),
         initialChildren: children,
       );

  static const String name = 'VoucherUsedInfoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<VoucherUsedInfoRouteArgs>();
      return VoucherUsedInfoPage(
        key: args.key,
        couponRule: args.couponRule,
        memberCouponWithRule: args.memberCouponWithRule,
      );
    },
  );
}

class VoucherUsedInfoRouteArgs {
  const VoucherUsedInfoRouteArgs({
    this.key,
    required this.couponRule,
    required this.memberCouponWithRule,
  });

  final Key? key;

  final CouponRule couponRule;

  final MemberCouponWithRule memberCouponWithRule;

  @override
  String toString() {
    return 'VoucherUsedInfoRouteArgs{key: $key, couponRule: $couponRule, memberCouponWithRule: $memberCouponWithRule}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! VoucherUsedInfoRouteArgs) return false;
    return key == other.key &&
        couponRule == other.couponRule &&
        memberCouponWithRule == other.memberCouponWithRule;
  }

  @override
  int get hashCode =>
      key.hashCode ^ couponRule.hashCode ^ memberCouponWithRule.hashCode;
}

/// generated route for
/// [VoucherWalletPage]
class VoucherWalletRoute extends PageRouteInfo<VoucherWalletRouteArgs> {
  VoucherWalletRoute({
    Key? key,
    VoucherStatus? initialStatus,
    List<PageRouteInfo>? children,
  }) : super(
         VoucherWalletRoute.name,
         args: VoucherWalletRouteArgs(key: key, initialStatus: initialStatus),
         initialChildren: children,
       );

  static const String name = 'VoucherWalletRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<VoucherWalletRouteArgs>(
        orElse: () => const VoucherWalletRouteArgs(),
      );
      return VoucherWalletPage(
        key: args.key,
        initialStatus: args.initialStatus,
      );
    },
  );
}

class VoucherWalletRouteArgs {
  const VoucherWalletRouteArgs({this.key, this.initialStatus});

  final Key? key;

  final VoucherStatus? initialStatus;

  @override
  String toString() {
    return 'VoucherWalletRouteArgs{key: $key, initialStatus: $initialStatus}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! VoucherWalletRouteArgs) return false;
    return key == other.key && initialStatus == other.initialStatus;
  }

  @override
  int get hashCode => key.hashCode ^ initialStatus.hashCode;
}
