// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'carousel_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Carousel repository provider

@ProviderFor(carouselRepository)
final carouselRepositoryProvider = CarouselRepositoryProvider._();

/// Carousel repository provider

final class CarouselRepositoryProvider
    extends
        $FunctionalProvider<
          CarouselRepository,
          CarouselRepository,
          CarouselRepository
        >
    with $Provider<CarouselRepository> {
  /// Carousel repository provider
  CarouselRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'carouselRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$carouselRepositoryHash();

  @$internal
  @override
  $ProviderElement<CarouselRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CarouselRepository create(Ref ref) {
    return carouselRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CarouselRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CarouselRepository>(value),
    );
  }
}

String _$carouselRepositoryHash() =>
    r'c605bcce1a5384108584f9dac317fcda094b7e09';

/// Watch active main carousels (HOME_MAIN_CAROUSEL) with background sync

@ProviderFor(MainCarousels)
final mainCarouselsProvider = MainCarouselsProvider._();

/// Watch active main carousels (HOME_MAIN_CAROUSEL) with background sync
final class MainCarouselsProvider
    extends $StreamNotifierProvider<MainCarousels, List<CarouselModel>> {
  /// Watch active main carousels (HOME_MAIN_CAROUSEL) with background sync
  MainCarouselsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mainCarouselsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mainCarouselsHash();

  @$internal
  @override
  MainCarousels create() => MainCarousels();
}

String _$mainCarouselsHash() => r'0c564e13831d43370abb81ed1acfbdb1fc822aeb';

/// Watch active main carousels (HOME_MAIN_CAROUSEL) with background sync

abstract class _$MainCarousels extends $StreamNotifier<List<CarouselModel>> {
  Stream<List<CarouselModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<CarouselModel>>, List<CarouselModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<CarouselModel>>, List<CarouselModel>>,
              AsyncValue<List<CarouselModel>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Watch active popup modals (HOME_POPUP_MODAL)

@ProviderFor(popupModals)
final popupModalsProvider = PopupModalsProvider._();

/// Watch active popup modals (HOME_POPUP_MODAL)

final class PopupModalsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CarouselModel>>,
          List<CarouselModel>,
          Stream<List<CarouselModel>>
        >
    with
        $FutureModifier<List<CarouselModel>>,
        $StreamProvider<List<CarouselModel>> {
  /// Watch active popup modals (HOME_POPUP_MODAL)
  PopupModalsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'popupModalsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$popupModalsHash();

  @$internal
  @override
  $StreamProviderElement<List<CarouselModel>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<CarouselModel>> create(Ref ref) {
    return popupModals(ref);
  }
}

String _$popupModalsHash() => r'5ee5a0d8c814c027af3356b2459d3a3d64f0a9f1';
