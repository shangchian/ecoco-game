import 'package:riverpod_annotation/riverpod_annotation.dart';
import '/models/carousel_model.dart';
import '/repositories/carousel_repository.dart';
import '/providers/app_database_provider.dart';
import '/providers/carousels_service_provider.dart';

part 'carousel_provider.g.dart';

/// Carousel repository provider
@Riverpod(keepAlive: true)
CarouselRepository carouselRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  final carouselsService = ref.watch(carouselsServiceProvider);
  return CarouselRepository(db: db, carouselsService: carouselsService);
}

/// Watch active main carousels (HOME_MAIN_CAROUSEL) with background sync
@Riverpod(keepAlive: true)
class MainCarousels extends _$MainCarousels {
  @override
  Stream<List<CarouselModel>> build() {
    final repository = ref.watch(carouselRepositoryProvider);
    _initSync();
    return repository.watchActiveMainCarousels();
  }

  Future<void> _initSync() async {
    try {
      final repository = ref.read(carouselRepositoryProvider);
      await repository.syncCarousels();
    } catch (e) {
      // Log error but don't block UI
    }
  }

  Future<void> refresh() async {
    final repository = ref.read(carouselRepositoryProvider);
    await repository.syncCarousels(forceRefresh: true);
  }
}

/// Watch active popup modals (HOME_POPUP_MODAL)
@Riverpod(keepAlive: true)
Stream<List<CarouselModel>> popupModals(Ref ref) {
  final repository = ref.watch(carouselRepositoryProvider);
  return repository.watchActivePopupModals();
}
