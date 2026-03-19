import 'package:riverpod_annotation/riverpod_annotation.dart';
import '/models/coupon_rule.dart';
import '/repositories/coupon_rules_repository.dart';
import '/providers/app_database_provider.dart';
import '/providers/coupon_rules_service_provider.dart';

part 'coupon_rules_provider.g.dart';

/// Coupon rules repository provider
@riverpod
CouponRulesRepository couponRulesRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  final couponRulesService = ref.watch(couponRulesServiceProvider);
  return CouponRulesRepository(db: db, couponRulesService: couponRulesService);
}

/// Watch all coupon rules (including inactive)
@riverpod
Stream<List<CouponRule>> allCouponRules(Ref ref) {
  final repository = ref.watch(couponRulesRepositoryProvider);
  return repository.watchAllCouponRules();
}

/// Watch only active coupon rules (sorted by sortOrder)
@riverpod
Stream<List<CouponRule>> activeCouponRules(Ref ref) {
  final repository = ref.watch(couponRulesRepositoryProvider);
  return repository.watchActiveCouponRules();
}

/// Watch coupon rules by category (family provider)
@riverpod
Stream<List<CouponRule>> couponRulesByCategory(
  Ref ref,
  String categoryCode,
) {
  final repository = ref.watch(couponRulesRepositoryProvider);
  return repository.watchCouponRulesByCategory(categoryCode);
}

/// Watch coupon rules by brand (family provider)
@riverpod
Stream<List<CouponRule>> couponRulesByBrand(
  Ref ref,
  String brandId,
) {
  final repository = ref.watch(couponRulesRepositoryProvider);
  return repository.watchCouponRulesByBrand(brandId);
}

/// Get a single coupon rule by ID (family provider)
@riverpod
Future<CouponRule?> couponRuleById(
  Ref ref,
  String id,
) async {
  final repository = ref.watch(couponRulesRepositoryProvider);
  return repository.getCouponRuleById(id);
}

/// Watch active coupon rules WITH display status (only those with active status)
@riverpod
Stream<List<CouponRule>> activeCouponRulesWithStatus(Ref ref) {
  final repository = ref.watch(couponRulesRepositoryProvider);
  return repository.watchActiveCouponRulesWithStatus();
}
