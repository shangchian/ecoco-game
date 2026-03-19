// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coupon_rules_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Coupon rules repository provider

@ProviderFor(couponRulesRepository)
final couponRulesRepositoryProvider = CouponRulesRepositoryProvider._();

/// Coupon rules repository provider

final class CouponRulesRepositoryProvider
    extends
        $FunctionalProvider<
          CouponRulesRepository,
          CouponRulesRepository,
          CouponRulesRepository
        >
    with $Provider<CouponRulesRepository> {
  /// Coupon rules repository provider
  CouponRulesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'couponRulesRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$couponRulesRepositoryHash();

  @$internal
  @override
  $ProviderElement<CouponRulesRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CouponRulesRepository create(Ref ref) {
    return couponRulesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CouponRulesRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CouponRulesRepository>(value),
    );
  }
}

String _$couponRulesRepositoryHash() =>
    r'69ab50efaf02dad66c8fa88b5359e98420ffd0b2';

/// Watch all coupon rules (including inactive)

@ProviderFor(allCouponRules)
final allCouponRulesProvider = AllCouponRulesProvider._();

/// Watch all coupon rules (including inactive)

final class AllCouponRulesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CouponRule>>,
          List<CouponRule>,
          Stream<List<CouponRule>>
        >
    with $FutureModifier<List<CouponRule>>, $StreamProvider<List<CouponRule>> {
  /// Watch all coupon rules (including inactive)
  AllCouponRulesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allCouponRulesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allCouponRulesHash();

  @$internal
  @override
  $StreamProviderElement<List<CouponRule>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<CouponRule>> create(Ref ref) {
    return allCouponRules(ref);
  }
}

String _$allCouponRulesHash() => r'03a157683a69cd04f50f4a9e076a386fa957b866';

/// Watch only active coupon rules (sorted by sortOrder)

@ProviderFor(activeCouponRules)
final activeCouponRulesProvider = ActiveCouponRulesProvider._();

/// Watch only active coupon rules (sorted by sortOrder)

final class ActiveCouponRulesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CouponRule>>,
          List<CouponRule>,
          Stream<List<CouponRule>>
        >
    with $FutureModifier<List<CouponRule>>, $StreamProvider<List<CouponRule>> {
  /// Watch only active coupon rules (sorted by sortOrder)
  ActiveCouponRulesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeCouponRulesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeCouponRulesHash();

  @$internal
  @override
  $StreamProviderElement<List<CouponRule>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<CouponRule>> create(Ref ref) {
    return activeCouponRules(ref);
  }
}

String _$activeCouponRulesHash() => r'b762e56a21df4784226520e80d536f0e252236a9';

/// Watch coupon rules by category (family provider)

@ProviderFor(couponRulesByCategory)
final couponRulesByCategoryProvider = CouponRulesByCategoryFamily._();

/// Watch coupon rules by category (family provider)

final class CouponRulesByCategoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CouponRule>>,
          List<CouponRule>,
          Stream<List<CouponRule>>
        >
    with $FutureModifier<List<CouponRule>>, $StreamProvider<List<CouponRule>> {
  /// Watch coupon rules by category (family provider)
  CouponRulesByCategoryProvider._({
    required CouponRulesByCategoryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'couponRulesByCategoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$couponRulesByCategoryHash();

  @override
  String toString() {
    return r'couponRulesByCategoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<CouponRule>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<CouponRule>> create(Ref ref) {
    final argument = this.argument as String;
    return couponRulesByCategory(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CouponRulesByCategoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$couponRulesByCategoryHash() =>
    r'94e344a57e286b1aeef2993f5310f79eff2db8f8';

/// Watch coupon rules by category (family provider)

final class CouponRulesByCategoryFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<CouponRule>>, String> {
  CouponRulesByCategoryFamily._()
    : super(
        retry: null,
        name: r'couponRulesByCategoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Watch coupon rules by category (family provider)

  CouponRulesByCategoryProvider call(String categoryCode) =>
      CouponRulesByCategoryProvider._(argument: categoryCode, from: this);

  @override
  String toString() => r'couponRulesByCategoryProvider';
}

/// Watch coupon rules by brand (family provider)

@ProviderFor(couponRulesByBrand)
final couponRulesByBrandProvider = CouponRulesByBrandFamily._();

/// Watch coupon rules by brand (family provider)

final class CouponRulesByBrandProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CouponRule>>,
          List<CouponRule>,
          Stream<List<CouponRule>>
        >
    with $FutureModifier<List<CouponRule>>, $StreamProvider<List<CouponRule>> {
  /// Watch coupon rules by brand (family provider)
  CouponRulesByBrandProvider._({
    required CouponRulesByBrandFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'couponRulesByBrandProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$couponRulesByBrandHash();

  @override
  String toString() {
    return r'couponRulesByBrandProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<CouponRule>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<CouponRule>> create(Ref ref) {
    final argument = this.argument as String;
    return couponRulesByBrand(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CouponRulesByBrandProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$couponRulesByBrandHash() =>
    r'ba68f569e21da1a6f3d14aa5400fb9d16ca7d0a3';

/// Watch coupon rules by brand (family provider)

final class CouponRulesByBrandFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<CouponRule>>, String> {
  CouponRulesByBrandFamily._()
    : super(
        retry: null,
        name: r'couponRulesByBrandProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Watch coupon rules by brand (family provider)

  CouponRulesByBrandProvider call(String brandId) =>
      CouponRulesByBrandProvider._(argument: brandId, from: this);

  @override
  String toString() => r'couponRulesByBrandProvider';
}

/// Get a single coupon rule by ID (family provider)

@ProviderFor(couponRuleById)
final couponRuleByIdProvider = CouponRuleByIdFamily._();

/// Get a single coupon rule by ID (family provider)

final class CouponRuleByIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<CouponRule?>,
          CouponRule?,
          FutureOr<CouponRule?>
        >
    with $FutureModifier<CouponRule?>, $FutureProvider<CouponRule?> {
  /// Get a single coupon rule by ID (family provider)
  CouponRuleByIdProvider._({
    required CouponRuleByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'couponRuleByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$couponRuleByIdHash();

  @override
  String toString() {
    return r'couponRuleByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<CouponRule?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<CouponRule?> create(Ref ref) {
    final argument = this.argument as String;
    return couponRuleById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CouponRuleByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$couponRuleByIdHash() => r'b6d04550dada2846bf26b53bf8d1b410cff277a7';

/// Get a single coupon rule by ID (family provider)

final class CouponRuleByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<CouponRule?>, String> {
  CouponRuleByIdFamily._()
    : super(
        retry: null,
        name: r'couponRuleByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Get a single coupon rule by ID (family provider)

  CouponRuleByIdProvider call(String id) =>
      CouponRuleByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'couponRuleByIdProvider';
}

/// Watch active coupon rules WITH display status (only those with active status)

@ProviderFor(activeCouponRulesWithStatus)
final activeCouponRulesWithStatusProvider =
    ActiveCouponRulesWithStatusProvider._();

/// Watch active coupon rules WITH display status (only those with active status)

final class ActiveCouponRulesWithStatusProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CouponRule>>,
          List<CouponRule>,
          Stream<List<CouponRule>>
        >
    with $FutureModifier<List<CouponRule>>, $StreamProvider<List<CouponRule>> {
  /// Watch active coupon rules WITH display status (only those with active status)
  ActiveCouponRulesWithStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeCouponRulesWithStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeCouponRulesWithStatusHash();

  @$internal
  @override
  $StreamProviderElement<List<CouponRule>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<CouponRule>> create(Ref ref) {
    return activeCouponRulesWithStatus(ref);
  }
}

String _$activeCouponRulesWithStatusHash() =>
    r'42d127d52ed6857d1b6b643d288e78969db8b247';
