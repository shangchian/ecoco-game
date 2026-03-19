// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Brand repository provider

@ProviderFor(brandRepository)
final brandRepositoryProvider = BrandRepositoryProvider._();

/// Brand repository provider

final class BrandRepositoryProvider
    extends
        $FunctionalProvider<BrandRepository, BrandRepository, BrandRepository>
    with $Provider<BrandRepository> {
  /// Brand repository provider
  BrandRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'brandRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$brandRepositoryHash();

  @$internal
  @override
  $ProviderElement<BrandRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BrandRepository create(Ref ref) {
    return brandRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BrandRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BrandRepository>(value),
    );
  }
}

String _$brandRepositoryHash() => r'6524aa75b425cecfa207415937bd5d1d38671766';

/// Watch all active brands (sorted by sortOrder)

@ProviderFor(brands)
final brandsProvider = BrandsProvider._();

/// Watch all active brands (sorted by sortOrder)

final class BrandsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Brand>>,
          List<Brand>,
          Stream<List<Brand>>
        >
    with $FutureModifier<List<Brand>>, $StreamProvider<List<Brand>> {
  /// Watch all active brands (sorted by sortOrder)
  BrandsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'brandsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$brandsHash();

  @$internal
  @override
  $StreamProviderElement<List<Brand>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Brand>> create(Ref ref) {
    return brands(ref);
  }
}

String _$brandsHash() => r'817274dd661d10db85a4bf0c5b74cc7fb28e0433';

/// Watch premium brands for home carousel

@ProviderFor(premiumBrands)
final premiumBrandsProvider = PremiumBrandsProvider._();

/// Watch premium brands for home carousel

final class PremiumBrandsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Brand>>,
          List<Brand>,
          Stream<List<Brand>>
        >
    with $FutureModifier<List<Brand>>, $StreamProvider<List<Brand>> {
  /// Watch premium brands for home carousel
  PremiumBrandsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'premiumBrandsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$premiumBrandsHash();

  @$internal
  @override
  $StreamProviderElement<List<Brand>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Brand>> create(Ref ref) {
    return premiumBrands(ref);
  }
}

String _$premiumBrandsHash() => r'9acd70df2e3cd0eeddbdbba22241edeae758e0a4';

/// Watch brands by specific category (family provider)

@ProviderFor(brandsByCategory)
final brandsByCategoryProvider = BrandsByCategoryFamily._();

/// Watch brands by specific category (family provider)

final class BrandsByCategoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Brand>>,
          List<Brand>,
          Stream<List<Brand>>
        >
    with $FutureModifier<List<Brand>>, $StreamProvider<List<Brand>> {
  /// Watch brands by specific category (family provider)
  BrandsByCategoryProvider._({
    required BrandsByCategoryFamily super.from,
    required BrandCategory super.argument,
  }) : super(
         retry: null,
         name: r'brandsByCategoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$brandsByCategoryHash();

  @override
  String toString() {
    return r'brandsByCategoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Brand>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Brand>> create(Ref ref) {
    final argument = this.argument as BrandCategory;
    return brandsByCategory(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is BrandsByCategoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$brandsByCategoryHash() => r'24324939faacc43d6b5c1b64f0d4a6a51c0dc201';

/// Watch brands by specific category (family provider)

final class BrandsByCategoryFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Brand>>, BrandCategory> {
  BrandsByCategoryFamily._()
    : super(
        retry: null,
        name: r'brandsByCategoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Watch brands by specific category (family provider)

  BrandsByCategoryProvider call(BrandCategory category) =>
      BrandsByCategoryProvider._(argument: category, from: this);

  @override
  String toString() => r'brandsByCategoryProvider';
}

/// Watch a single brand by ID (family provider)

@ProviderFor(brandById)
final brandByIdProvider = BrandByIdFamily._();

/// Watch a single brand by ID (family provider)

final class BrandByIdProvider
    extends $FunctionalProvider<AsyncValue<Brand?>, Brand?, Stream<Brand?>>
    with $FutureModifier<Brand?>, $StreamProvider<Brand?> {
  /// Watch a single brand by ID (family provider)
  BrandByIdProvider._({
    required BrandByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'brandByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$brandByIdHash();

  @override
  String toString() {
    return r'brandByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Brand?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Brand?> create(Ref ref) {
    final argument = this.argument as String;
    return brandById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is BrandByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$brandByIdHash() => r'1cd90430974245e0b3b5b76c2952e2e7dfb7c53c';

/// Watch a single brand by ID (family provider)

final class BrandByIdFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Brand?>, String> {
  BrandByIdFamily._()
    : super(
        retry: null,
        name: r'brandByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Watch a single brand by ID (family provider)

  BrandByIdProvider call(String brandId) =>
      BrandByIdProvider._(argument: brandId, from: this);

  @override
  String toString() => r'brandByIdProvider';
}
