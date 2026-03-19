import 'package:riverpod_annotation/riverpod_annotation.dart';
import '/models/brand_model.dart';
import '/repositories/brand_repository.dart';
import '/providers/app_database_provider.dart';
import '/providers/brands_service_provider.dart';

part 'brand_provider.g.dart';

/// Brand repository provider
@riverpod
BrandRepository brandRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  final brandsService = ref.watch(brandsServiceProvider);
  return BrandRepository(db: db, brandsService: brandsService);
}

/// Watch all active brands (sorted by sortOrder)
@riverpod
Stream<List<Brand>> brands(Ref ref) {
  final repository = ref.watch(brandRepositoryProvider);
  return repository.watchActiveBrands();
}

/// Watch premium brands for home carousel
@riverpod
Stream<List<Brand>> premiumBrands(Ref ref) {
  final repository = ref.watch(brandRepositoryProvider);
  return repository.watchPremiumBrands();
}

/// Watch brands by specific category (family provider)
@riverpod
Stream<List<Brand>> brandsByCategory(
  Ref ref,
  BrandCategory category,
) {
  final repository = ref.watch(brandRepositoryProvider);
  return repository.watchBrandsByCategory(category);
}

/// Watch a single brand by ID (family provider)
@riverpod
Stream<Brand?> brandById(
  Ref ref,
  String brandId,
) {
  final repository = ref.watch(brandRepositoryProvider);
  return repository.watchBrandById(brandId);
}
