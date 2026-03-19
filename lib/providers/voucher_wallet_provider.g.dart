// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voucher_wallet_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 票券夾選中的狀態篩選

@ProviderFor(SelectedVoucherStatus)
final selectedVoucherStatusProvider = SelectedVoucherStatusProvider._();

/// 票券夾選中的狀態篩選
final class SelectedVoucherStatusProvider
    extends $NotifierProvider<SelectedVoucherStatus, VoucherStatus> {
  /// 票券夾選中的狀態篩選
  SelectedVoucherStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedVoucherStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedVoucherStatusHash();

  @$internal
  @override
  SelectedVoucherStatus create() => SelectedVoucherStatus();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VoucherStatus value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VoucherStatus>(value),
    );
  }
}

String _$selectedVoucherStatusHash() =>
    r'6daacab549f5cf98afb9ca3a51dfd5168fd2beee';

/// 票券夾選中的狀態篩選

abstract class _$SelectedVoucherStatus extends $Notifier<VoucherStatus> {
  VoucherStatus build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<VoucherStatus, VoucherStatus>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<VoucherStatus, VoucherStatus>,
              VoucherStatus,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Active coupons with CouponRule data

@ProviderFor(activeCouponsWithRules)
final activeCouponsWithRulesProvider = ActiveCouponsWithRulesProvider._();

/// Active coupons with CouponRule data

final class ActiveCouponsWithRulesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MemberCouponWithRule>>,
          List<MemberCouponWithRule>,
          Stream<List<MemberCouponWithRule>>
        >
    with
        $FutureModifier<List<MemberCouponWithRule>>,
        $StreamProvider<List<MemberCouponWithRule>> {
  /// Active coupons with CouponRule data
  ActiveCouponsWithRulesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeCouponsWithRulesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeCouponsWithRulesHash();

  @$internal
  @override
  $StreamProviderElement<List<MemberCouponWithRule>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<MemberCouponWithRule>> create(Ref ref) {
    return activeCouponsWithRules(ref);
  }
}

String _$activeCouponsWithRulesHash() =>
    r'e2b512ef76f64344d3050c8726c1f5493adacb9d';

/// Used coupons with CouponRule data

@ProviderFor(usedCouponsWithRules)
final usedCouponsWithRulesProvider = UsedCouponsWithRulesProvider._();

/// Used coupons with CouponRule data

final class UsedCouponsWithRulesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MemberCouponWithRule>>,
          List<MemberCouponWithRule>,
          Stream<List<MemberCouponWithRule>>
        >
    with
        $FutureModifier<List<MemberCouponWithRule>>,
        $StreamProvider<List<MemberCouponWithRule>> {
  /// Used coupons with CouponRule data
  UsedCouponsWithRulesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'usedCouponsWithRulesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$usedCouponsWithRulesHash();

  @$internal
  @override
  $StreamProviderElement<List<MemberCouponWithRule>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<MemberCouponWithRule>> create(Ref ref) {
    return usedCouponsWithRules(ref);
  }
}

String _$usedCouponsWithRulesHash() =>
    r'ce953eb18b232fde50bf5f2d08fdb3c3faddf08e';

/// Expired coupons with CouponRule data

@ProviderFor(expiredCouponsWithRules)
final expiredCouponsWithRulesProvider = ExpiredCouponsWithRulesProvider._();

/// Expired coupons with CouponRule data

final class ExpiredCouponsWithRulesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MemberCouponWithRule>>,
          List<MemberCouponWithRule>,
          Stream<List<MemberCouponWithRule>>
        >
    with
        $FutureModifier<List<MemberCouponWithRule>>,
        $StreamProvider<List<MemberCouponWithRule>> {
  /// Expired coupons with CouponRule data
  ExpiredCouponsWithRulesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'expiredCouponsWithRulesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$expiredCouponsWithRulesHash();

  @$internal
  @override
  $StreamProviderElement<List<MemberCouponWithRule>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<MemberCouponWithRule>> create(Ref ref) {
    return expiredCouponsWithRules(ref);
  }
}

String _$expiredCouponsWithRulesHash() =>
    r'3ca4ae703277a42d40ffb5f58343ccc7e4ea58a6';

/// Expiring soon count for active tab (7 days window)

@ProviderFor(expiringSoonCount)
final expiringSoonCountProvider = ExpiringSoonCountProvider._();

/// Expiring soon count for active tab (7 days window)

final class ExpiringSoonCountProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// Expiring soon count for active tab (7 days window)
  ExpiringSoonCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'expiringSoonCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$expiringSoonCountHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return expiringSoonCount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$expiringSoonCountHash() => r'495c549903a4cd7c37a660c7736f39da65c328e5';
