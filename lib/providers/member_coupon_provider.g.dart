// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_coupon_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(memberCouponRepository)
final memberCouponRepositoryProvider = MemberCouponRepositoryProvider._();

final class MemberCouponRepositoryProvider
    extends
        $FunctionalProvider<
          MemberCouponRepository,
          MemberCouponRepository,
          MemberCouponRepository
        >
    with $Provider<MemberCouponRepository> {
  MemberCouponRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'memberCouponRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$memberCouponRepositoryHash();

  @$internal
  @override
  $ProviderElement<MemberCouponRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MemberCouponRepository create(Ref ref) {
    return memberCouponRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MemberCouponRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MemberCouponRepository>(value),
    );
  }
}

String _$memberCouponRepositoryHash() =>
    r'51e0cfd3eb9c31ddb4064e5038c47db57787a8a4';

@ProviderFor(activeMemberCoupons)
final activeMemberCouponsProvider = ActiveMemberCouponsProvider._();

final class ActiveMemberCouponsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MemberCouponModel>>,
          List<MemberCouponModel>,
          Stream<List<MemberCouponModel>>
        >
    with
        $FutureModifier<List<MemberCouponModel>>,
        $StreamProvider<List<MemberCouponModel>> {
  ActiveMemberCouponsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeMemberCouponsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeMemberCouponsHash();

  @$internal
  @override
  $StreamProviderElement<List<MemberCouponModel>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<MemberCouponModel>> create(Ref ref) {
    return activeMemberCoupons(ref);
  }
}

String _$activeMemberCouponsHash() =>
    r'37f03448d81e320eb1730b343d6f7713febab194';

@ProviderFor(historyMemberCoupons)
final historyMemberCouponsProvider = HistoryMemberCouponsProvider._();

final class HistoryMemberCouponsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MemberCouponModel>>,
          List<MemberCouponModel>,
          Stream<List<MemberCouponModel>>
        >
    with
        $FutureModifier<List<MemberCouponModel>>,
        $StreamProvider<List<MemberCouponModel>> {
  HistoryMemberCouponsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'historyMemberCouponsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$historyMemberCouponsHash();

  @$internal
  @override
  $StreamProviderElement<List<MemberCouponModel>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<MemberCouponModel>> create(Ref ref) {
    return historyMemberCoupons(ref);
  }
}

String _$historyMemberCouponsHash() =>
    r'26347092ac5742855a7b917546a78869d3fc3cd3';

/// Issue a coupon with automatic token management
///
/// [couponRuleId] - The coupon rule UID to exchange
/// [exchangeUnits] - Number of units to exchange (must be >= 1)
/// [branchCode] - Optional branch verification code entered by staff
///
/// Throws:
/// - [NotAuthenticatedException] if user is not logged in
/// - [TokenRefreshFailedException] if token refresh fails
/// - [ApiException] for API errors (e.g., code 400 for invalid branchCode)

@ProviderFor(issueCoupon)
final issueCouponProvider = IssueCouponFamily._();

/// Issue a coupon with automatic token management
///
/// [couponRuleId] - The coupon rule UID to exchange
/// [exchangeUnits] - Number of units to exchange (must be >= 1)
/// [branchCode] - Optional branch verification code entered by staff
///
/// Throws:
/// - [NotAuthenticatedException] if user is not logged in
/// - [TokenRefreshFailedException] if token refresh fails
/// - [ApiException] for API errors (e.g., code 400 for invalid branchCode)

final class IssueCouponProvider
    extends
        $FunctionalProvider<
          AsyncValue<IssueCouponResponse>,
          IssueCouponResponse,
          FutureOr<IssueCouponResponse>
        >
    with
        $FutureModifier<IssueCouponResponse>,
        $FutureProvider<IssueCouponResponse> {
  /// Issue a coupon with automatic token management
  ///
  /// [couponRuleId] - The coupon rule UID to exchange
  /// [exchangeUnits] - Number of units to exchange (must be >= 1)
  /// [branchCode] - Optional branch verification code entered by staff
  ///
  /// Throws:
  /// - [NotAuthenticatedException] if user is not logged in
  /// - [TokenRefreshFailedException] if token refresh fails
  /// - [ApiException] for API errors (e.g., code 400 for invalid branchCode)
  IssueCouponProvider._({
    required IssueCouponFamily super.from,
    required ({String couponRuleId, int exchangeUnits, String? branchCode})
    super.argument,
  }) : super(
         retry: null,
         name: r'issueCouponProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$issueCouponHash();

  @override
  String toString() {
    return r'issueCouponProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<IssueCouponResponse> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<IssueCouponResponse> create(Ref ref) {
    final argument =
        this.argument
            as ({String couponRuleId, int exchangeUnits, String? branchCode});
    return issueCoupon(
      ref,
      couponRuleId: argument.couponRuleId,
      exchangeUnits: argument.exchangeUnits,
      branchCode: argument.branchCode,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is IssueCouponProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$issueCouponHash() => r'37be5a166b0e156fcc62e8d22eb1f69f059b01ac';

/// Issue a coupon with automatic token management
///
/// [couponRuleId] - The coupon rule UID to exchange
/// [exchangeUnits] - Number of units to exchange (must be >= 1)
/// [branchCode] - Optional branch verification code entered by staff
///
/// Throws:
/// - [NotAuthenticatedException] if user is not logged in
/// - [TokenRefreshFailedException] if token refresh fails
/// - [ApiException] for API errors (e.g., code 400 for invalid branchCode)

final class IssueCouponFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<IssueCouponResponse>,
          ({String couponRuleId, int exchangeUnits, String? branchCode})
        > {
  IssueCouponFamily._()
    : super(
        retry: null,
        name: r'issueCouponProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Issue a coupon with automatic token management
  ///
  /// [couponRuleId] - The coupon rule UID to exchange
  /// [exchangeUnits] - Number of units to exchange (must be >= 1)
  /// [branchCode] - Optional branch verification code entered by staff
  ///
  /// Throws:
  /// - [NotAuthenticatedException] if user is not logged in
  /// - [TokenRefreshFailedException] if token refresh fails
  /// - [ApiException] for API errors (e.g., code 400 for invalid branchCode)

  IssueCouponProvider call({
    required String couponRuleId,
    required int exchangeUnits,
    String? branchCode,
  }) => IssueCouponProvider._(
    argument: (
      couponRuleId: couponRuleId,
      exchangeUnits: exchangeUnits,
      branchCode: branchCode,
    ),
    from: this,
  );

  @override
  String toString() => r'issueCouponProvider';
}

/// Sync member coupons from server to local database

@ProviderFor(syncMemberCouponsAction)
final syncMemberCouponsActionProvider = SyncMemberCouponsActionProvider._();

/// Sync member coupons from server to local database

final class SyncMemberCouponsActionProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Sync member coupons from server to local database
  SyncMemberCouponsActionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncMemberCouponsActionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncMemberCouponsActionHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return syncMemberCouponsAction(ref);
  }
}

String _$syncMemberCouponsActionHash() =>
    r'a0e2ff3a9c54c48b884a4ba2185a5d3754600f01';

/// Get member coupons with rules by IDs (for display after issue)
/// Note: keepAlive is required to prevent disposal during async operations

@ProviderFor(memberCouponsWithRulesById)
final memberCouponsWithRulesByIdProvider = MemberCouponsWithRulesByIdFamily._();

/// Get member coupons with rules by IDs (for display after issue)
/// Note: keepAlive is required to prevent disposal during async operations

final class MemberCouponsWithRulesByIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MemberCouponWithRule>>,
          List<MemberCouponWithRule>,
          FutureOr<List<MemberCouponWithRule>>
        >
    with
        $FutureModifier<List<MemberCouponWithRule>>,
        $FutureProvider<List<MemberCouponWithRule>> {
  /// Get member coupons with rules by IDs (for display after issue)
  /// Note: keepAlive is required to prevent disposal during async operations
  MemberCouponsWithRulesByIdProvider._({
    required MemberCouponsWithRulesByIdFamily super.from,
    required List<String> super.argument,
  }) : super(
         retry: null,
         name: r'memberCouponsWithRulesByIdProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$memberCouponsWithRulesByIdHash();

  @override
  String toString() {
    return r'memberCouponsWithRulesByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<MemberCouponWithRule>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<MemberCouponWithRule>> create(Ref ref) {
    final argument = this.argument as List<String>;
    return memberCouponsWithRulesById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MemberCouponsWithRulesByIdProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$memberCouponsWithRulesByIdHash() =>
    r'84455785fcdee9da26166fcaf536d9903dd0c4f8';

/// Get member coupons with rules by IDs (for display after issue)
/// Note: keepAlive is required to prevent disposal during async operations

final class MemberCouponsWithRulesByIdFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<MemberCouponWithRule>>,
          List<String>
        > {
  MemberCouponsWithRulesByIdFamily._()
    : super(
        retry: null,
        name: r'memberCouponsWithRulesByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  /// Get member coupons with rules by IDs (for display after issue)
  /// Note: keepAlive is required to prevent disposal during async operations

  MemberCouponsWithRulesByIdProvider call(List<String> ids) =>
      MemberCouponsWithRulesByIdProvider._(argument: ids, from: this);

  @override
  String toString() => r'memberCouponsWithRulesByIdProvider';
}

/// Prepare a coupon for POS redemption (creates HOLDING status coupon)
///
/// [couponRuleId] - The coupon rule UID to exchange
/// [exchangeUnits] - Number of units to exchange (must be >= 1)
///
/// Returns prepared coupon information including memberCouponId
/// The HOLDING status coupon has a 5-minute validity period
///
/// Throws:
/// - [NotAuthenticatedException] if user is not logged in
/// - [TokenRefreshFailedException] if token refresh fails
/// - [ApiException] for API errors (e.g., code 30006 for insufficient points)

@ProviderFor(prepareCoupon)
final prepareCouponProvider = PrepareCouponFamily._();

/// Prepare a coupon for POS redemption (creates HOLDING status coupon)
///
/// [couponRuleId] - The coupon rule UID to exchange
/// [exchangeUnits] - Number of units to exchange (must be >= 1)
///
/// Returns prepared coupon information including memberCouponId
/// The HOLDING status coupon has a 5-minute validity period
///
/// Throws:
/// - [NotAuthenticatedException] if user is not logged in
/// - [TokenRefreshFailedException] if token refresh fails
/// - [ApiException] for API errors (e.g., code 30006 for insufficient points)

final class PrepareCouponProvider
    extends
        $FunctionalProvider<
          AsyncValue<PrepareCouponResponse>,
          PrepareCouponResponse,
          FutureOr<PrepareCouponResponse>
        >
    with
        $FutureModifier<PrepareCouponResponse>,
        $FutureProvider<PrepareCouponResponse> {
  /// Prepare a coupon for POS redemption (creates HOLDING status coupon)
  ///
  /// [couponRuleId] - The coupon rule UID to exchange
  /// [exchangeUnits] - Number of units to exchange (must be >= 1)
  ///
  /// Returns prepared coupon information including memberCouponId
  /// The HOLDING status coupon has a 5-minute validity period
  ///
  /// Throws:
  /// - [NotAuthenticatedException] if user is not logged in
  /// - [TokenRefreshFailedException] if token refresh fails
  /// - [ApiException] for API errors (e.g., code 30006 for insufficient points)
  PrepareCouponProvider._({
    required PrepareCouponFamily super.from,
    required ({String couponRuleId, int exchangeUnits}) super.argument,
  }) : super(
         retry: null,
         name: r'prepareCouponProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$prepareCouponHash();

  @override
  String toString() {
    return r'prepareCouponProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<PrepareCouponResponse> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PrepareCouponResponse> create(Ref ref) {
    final argument =
        this.argument as ({String couponRuleId, int exchangeUnits});
    return prepareCoupon(
      ref,
      couponRuleId: argument.couponRuleId,
      exchangeUnits: argument.exchangeUnits,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PrepareCouponProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$prepareCouponHash() => r'f9ad57b617b68cb282d374e0f1dbac9fc827e95f';

/// Prepare a coupon for POS redemption (creates HOLDING status coupon)
///
/// [couponRuleId] - The coupon rule UID to exchange
/// [exchangeUnits] - Number of units to exchange (must be >= 1)
///
/// Returns prepared coupon information including memberCouponId
/// The HOLDING status coupon has a 5-minute validity period
///
/// Throws:
/// - [NotAuthenticatedException] if user is not logged in
/// - [TokenRefreshFailedException] if token refresh fails
/// - [ApiException] for API errors (e.g., code 30006 for insufficient points)

final class PrepareCouponFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<PrepareCouponResponse>,
          ({String couponRuleId, int exchangeUnits})
        > {
  PrepareCouponFamily._()
    : super(
        retry: null,
        name: r'prepareCouponProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Prepare a coupon for POS redemption (creates HOLDING status coupon)
  ///
  /// [couponRuleId] - The coupon rule UID to exchange
  /// [exchangeUnits] - Number of units to exchange (must be >= 1)
  ///
  /// Returns prepared coupon information including memberCouponId
  /// The HOLDING status coupon has a 5-minute validity period
  ///
  /// Throws:
  /// - [NotAuthenticatedException] if user is not logged in
  /// - [TokenRefreshFailedException] if token refresh fails
  /// - [ApiException] for API errors (e.g., code 30006 for insufficient points)

  PrepareCouponProvider call({
    required String couponRuleId,
    required int exchangeUnits,
  }) => PrepareCouponProvider._(
    argument: (couponRuleId: couponRuleId, exchangeUnits: exchangeUnits),
    from: this,
  );

  @override
  String toString() => r'prepareCouponProvider';
}

/// Cancel a HOLDING status coupon
///
/// [memberCouponId] - The member coupon UID to cancel
///
/// Returns cancel confirmation including refunded points
/// Only HOLDING status coupons can be canceled
///
/// Throws:
/// - [NotAuthenticatedException] if user is not logged in
/// - [TokenRefreshFailedException] if token refresh fails
/// - [ApiException] for API errors (e.g., code 30017 for already canceled)

@ProviderFor(cancelCoupon)
final cancelCouponProvider = CancelCouponFamily._();

/// Cancel a HOLDING status coupon
///
/// [memberCouponId] - The member coupon UID to cancel
///
/// Returns cancel confirmation including refunded points
/// Only HOLDING status coupons can be canceled
///
/// Throws:
/// - [NotAuthenticatedException] if user is not logged in
/// - [TokenRefreshFailedException] if token refresh fails
/// - [ApiException] for API errors (e.g., code 30017 for already canceled)

final class CancelCouponProvider
    extends
        $FunctionalProvider<
          AsyncValue<CancelCouponResponse>,
          CancelCouponResponse,
          FutureOr<CancelCouponResponse>
        >
    with
        $FutureModifier<CancelCouponResponse>,
        $FutureProvider<CancelCouponResponse> {
  /// Cancel a HOLDING status coupon
  ///
  /// [memberCouponId] - The member coupon UID to cancel
  ///
  /// Returns cancel confirmation including refunded points
  /// Only HOLDING status coupons can be canceled
  ///
  /// Throws:
  /// - [NotAuthenticatedException] if user is not logged in
  /// - [TokenRefreshFailedException] if token refresh fails
  /// - [ApiException] for API errors (e.g., code 30017 for already canceled)
  CancelCouponProvider._({
    required CancelCouponFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'cancelCouponProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$cancelCouponHash();

  @override
  String toString() {
    return r'cancelCouponProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<CancelCouponResponse> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<CancelCouponResponse> create(Ref ref) {
    final argument = this.argument as String;
    return cancelCoupon(ref, memberCouponId: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CancelCouponProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$cancelCouponHash() => r'3441e08e0632f338bf027129fcd423fc6171a881';

/// Cancel a HOLDING status coupon
///
/// [memberCouponId] - The member coupon UID to cancel
///
/// Returns cancel confirmation including refunded points
/// Only HOLDING status coupons can be canceled
///
/// Throws:
/// - [NotAuthenticatedException] if user is not logged in
/// - [TokenRefreshFailedException] if token refresh fails
/// - [ApiException] for API errors (e.g., code 30017 for already canceled)

final class CancelCouponFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<CancelCouponResponse>, String> {
  CancelCouponFamily._()
    : super(
        retry: null,
        name: r'cancelCouponProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Cancel a HOLDING status coupon
  ///
  /// [memberCouponId] - The member coupon UID to cancel
  ///
  /// Returns cancel confirmation including refunded points
  /// Only HOLDING status coupons can be canceled
  ///
  /// Throws:
  /// - [NotAuthenticatedException] if user is not logged in
  /// - [TokenRefreshFailedException] if token refresh fails
  /// - [ApiException] for API errors (e.g., code 30017 for already canceled)

  CancelCouponProvider call({required String memberCouponId}) =>
      CancelCouponProvider._(argument: memberCouponId, from: this);

  @override
  String toString() => r'cancelCouponProvider';
}

/// Get current status of a member coupon for polling
///
/// [memberCouponId] - The member coupon UID to check
///
/// Returns current status information for POS flow status confirmation
/// Used for polling during POS redemption to detect silent notification updates
///
/// Throws:
/// - [NotAuthenticatedException] if user is not logged in
/// - [TokenRefreshFailedException] if token refresh fails
/// - [ApiException] for API errors (e.g., code 10010 for coupon not found)

@ProviderFor(getMemberCouponStatus)
final getMemberCouponStatusProvider = GetMemberCouponStatusFamily._();

/// Get current status of a member coupon for polling
///
/// [memberCouponId] - The member coupon UID to check
///
/// Returns current status information for POS flow status confirmation
/// Used for polling during POS redemption to detect silent notification updates
///
/// Throws:
/// - [NotAuthenticatedException] if user is not logged in
/// - [TokenRefreshFailedException] if token refresh fails
/// - [ApiException] for API errors (e.g., code 10010 for coupon not found)

final class GetMemberCouponStatusProvider
    extends
        $FunctionalProvider<
          AsyncValue<MemberCouponStatusResponse>,
          MemberCouponStatusResponse,
          FutureOr<MemberCouponStatusResponse>
        >
    with
        $FutureModifier<MemberCouponStatusResponse>,
        $FutureProvider<MemberCouponStatusResponse> {
  /// Get current status of a member coupon for polling
  ///
  /// [memberCouponId] - The member coupon UID to check
  ///
  /// Returns current status information for POS flow status confirmation
  /// Used for polling during POS redemption to detect silent notification updates
  ///
  /// Throws:
  /// - [NotAuthenticatedException] if user is not logged in
  /// - [TokenRefreshFailedException] if token refresh fails
  /// - [ApiException] for API errors (e.g., code 10010 for coupon not found)
  GetMemberCouponStatusProvider._({
    required GetMemberCouponStatusFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'getMemberCouponStatusProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getMemberCouponStatusHash();

  @override
  String toString() {
    return r'getMemberCouponStatusProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<MemberCouponStatusResponse> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<MemberCouponStatusResponse> create(Ref ref) {
    final argument = this.argument as String;
    return getMemberCouponStatus(ref, memberCouponId: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GetMemberCouponStatusProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getMemberCouponStatusHash() =>
    r'3518355d2d29dfb69c5172cdce76078811025752';

/// Get current status of a member coupon for polling
///
/// [memberCouponId] - The member coupon UID to check
///
/// Returns current status information for POS flow status confirmation
/// Used for polling during POS redemption to detect silent notification updates
///
/// Throws:
/// - [NotAuthenticatedException] if user is not logged in
/// - [TokenRefreshFailedException] if token refresh fails
/// - [ApiException] for API errors (e.g., code 10010 for coupon not found)

final class GetMemberCouponStatusFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<MemberCouponStatusResponse>,
          String
        > {
  GetMemberCouponStatusFamily._()
    : super(
        retry: null,
        name: r'getMemberCouponStatusProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Get current status of a member coupon for polling
  ///
  /// [memberCouponId] - The member coupon UID to check
  ///
  /// Returns current status information for POS flow status confirmation
  /// Used for polling during POS redemption to detect silent notification updates
  ///
  /// Throws:
  /// - [NotAuthenticatedException] if user is not logged in
  /// - [TokenRefreshFailedException] if token refresh fails
  /// - [ApiException] for API errors (e.g., code 10010 for coupon not found)

  GetMemberCouponStatusProvider call({required String memberCouponId}) =>
      GetMemberCouponStatusProvider._(argument: memberCouponId, from: this);

  @override
  String toString() => r'getMemberCouponStatusProvider';
}

/// Finalize coupon usage (mark as USED)
///
/// [memberCouponId] - The member coupon UID to finalize
///
/// Returns finalize confirmation with updated status
/// Used for verification code flow where staff confirms usage
///
/// Throws:
/// - [NotAuthenticatedException] if user is not logged in
/// - [TokenRefreshFailedException] if token refresh fails
/// - [ApiException] for API errors

@ProviderFor(finalizeCoupon)
final finalizeCouponProvider = FinalizeCouponFamily._();

/// Finalize coupon usage (mark as USED)
///
/// [memberCouponId] - The member coupon UID to finalize
///
/// Returns finalize confirmation with updated status
/// Used for verification code flow where staff confirms usage
///
/// Throws:
/// - [NotAuthenticatedException] if user is not logged in
/// - [TokenRefreshFailedException] if token refresh fails
/// - [ApiException] for API errors

final class FinalizeCouponProvider
    extends
        $FunctionalProvider<
          AsyncValue<FinalizeCouponResponse>,
          FinalizeCouponResponse,
          FutureOr<FinalizeCouponResponse>
        >
    with
        $FutureModifier<FinalizeCouponResponse>,
        $FutureProvider<FinalizeCouponResponse> {
  /// Finalize coupon usage (mark as USED)
  ///
  /// [memberCouponId] - The member coupon UID to finalize
  ///
  /// Returns finalize confirmation with updated status
  /// Used for verification code flow where staff confirms usage
  ///
  /// Throws:
  /// - [NotAuthenticatedException] if user is not logged in
  /// - [TokenRefreshFailedException] if token refresh fails
  /// - [ApiException] for API errors
  FinalizeCouponProvider._({
    required FinalizeCouponFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'finalizeCouponProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$finalizeCouponHash();

  @override
  String toString() {
    return r'finalizeCouponProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<FinalizeCouponResponse> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<FinalizeCouponResponse> create(Ref ref) {
    final argument = this.argument as String;
    return finalizeCoupon(ref, memberCouponId: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is FinalizeCouponProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$finalizeCouponHash() => r'7fe8f904cdabe34bbe78f7236edf135bf1a14f41';

/// Finalize coupon usage (mark as USED)
///
/// [memberCouponId] - The member coupon UID to finalize
///
/// Returns finalize confirmation with updated status
/// Used for verification code flow where staff confirms usage
///
/// Throws:
/// - [NotAuthenticatedException] if user is not logged in
/// - [TokenRefreshFailedException] if token refresh fails
/// - [ApiException] for API errors

final class FinalizeCouponFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<FinalizeCouponResponse>, String> {
  FinalizeCouponFamily._()
    : super(
        retry: null,
        name: r'finalizeCouponProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Finalize coupon usage (mark as USED)
  ///
  /// [memberCouponId] - The member coupon UID to finalize
  ///
  /// Returns finalize confirmation with updated status
  /// Used for verification code flow where staff confirms usage
  ///
  /// Throws:
  /// - [NotAuthenticatedException] if user is not logged in
  /// - [TokenRefreshFailedException] if token refresh fails
  /// - [ApiException] for API errors

  FinalizeCouponProvider call({required String memberCouponId}) =>
      FinalizeCouponProvider._(argument: memberCouponId, from: this);

  @override
  String toString() => r'finalizeCouponProvider';
}

/// Update local coupon status (for POS polling)

@ProviderFor(updateLocalCouponStatus)
final updateLocalCouponStatusProvider = UpdateLocalCouponStatusFamily._();

/// Update local coupon status (for POS polling)

final class UpdateLocalCouponStatusProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Update local coupon status (for POS polling)
  UpdateLocalCouponStatusProvider._({
    required UpdateLocalCouponStatusFamily super.from,
    required ({String memberCouponId, String status, DateTime? usedAt})
    super.argument,
  }) : super(
         retry: null,
         name: r'updateLocalCouponStatusProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$updateLocalCouponStatusHash();

  @override
  String toString() {
    return r'updateLocalCouponStatusProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    final argument =
        this.argument
            as ({String memberCouponId, String status, DateTime? usedAt});
    return updateLocalCouponStatus(
      ref,
      memberCouponId: argument.memberCouponId,
      status: argument.status,
      usedAt: argument.usedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UpdateLocalCouponStatusProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$updateLocalCouponStatusHash() =>
    r'92436fd981f3d09b15c033076d24c90045ca65d6';

/// Update local coupon status (for POS polling)

final class UpdateLocalCouponStatusFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<void>,
          ({String memberCouponId, String status, DateTime? usedAt})
        > {
  UpdateLocalCouponStatusFamily._()
    : super(
        retry: null,
        name: r'updateLocalCouponStatusProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Update local coupon status (for POS polling)

  UpdateLocalCouponStatusProvider call({
    required String memberCouponId,
    required String status,
    DateTime? usedAt,
  }) => UpdateLocalCouponStatusProvider._(
    argument: (memberCouponId: memberCouponId, status: status, usedAt: usedAt),
    from: this,
  );

  @override
  String toString() => r'updateLocalCouponStatusProvider';
}
