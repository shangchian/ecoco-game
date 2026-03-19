import 'dart:io';
import 'dart:developer' as developer;
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '/flavors.dart';
import '../../models/points_log_model.dart';
import '../../models/site_model.dart';
import '../../models/site_status_model.dart';
import '../../models/brand_model.dart';
import '../../models/coupon_rule.dart';
import '../../models/coupon_status_model.dart';
import '../../models/carousel_model.dart';
import '../../models/member_coupon_model.dart';
import '../../models/redemption_credential_model.dart';
import '../../models/notification_item_model.dart';
import '../../models/notifications_response_model.dart';
import 'tables/point_logs.dart';
import 'tables/sites.dart';
import 'tables/site_statuses.dart';
import 'tables/brands.dart';
import 'tables/coupon_rules.dart';
import 'tables/coupon_rule_statuses.dart';
import 'tables/carousels.dart';
import 'tables/member_coupons.dart';
import 'tables/notifications.dart';
import 'converters/recyclable_items_converter.dart';
import 'converters/item_status_list_converter.dart';
import 'converters/bin_status_list_converter.dart';
import 'converters/coupon_rule_ids_converter.dart';
import 'converters/carousel_list_converter.dart';
import 'converters/redemption_credentials_converter.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [PointLogs, Sites, SiteStatuses, Brands, CouponRules, CouponRuleStatuses, Carousels, MemberCoupons, Notifications])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection()) {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  }

  @override
  int get schemaVersion => 11;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        // Create indexes for sites table
        await customStatement('CREATE INDEX IF NOT EXISTS idx_sites_code ON sites(code)');
        await customStatement('CREATE INDEX IF NOT EXISTS idx_sites_favorite ON sites(is_favorite)');

        // Create indexes for brands table
        await customStatement('CREATE INDEX IF NOT EXISTS idx_brands_is_premium ON brands(is_premium)');
        await customStatement('CREATE INDEX IF NOT EXISTS idx_brands_category ON brands(category)');
        await customStatement('CREATE INDEX IF NOT EXISTS idx_brands_sort_order ON brands(sort_order)');
        await customStatement('CREATE INDEX IF NOT EXISTS idx_brands_active_dates ON brands(is_active, start_date, end_date)');

        // Create indexes for coupon_rules table
        await customStatement('CREATE INDEX IF NOT EXISTS idx_coupon_rules_brand_id ON coupon_rules(brand_id)');
        await customStatement('CREATE INDEX IF NOT EXISTS idx_coupon_rules_is_active ON coupon_rules(is_active)');
        await customStatement('CREATE INDEX IF NOT EXISTS idx_coupon_rules_active_sort ON coupon_rules(is_active, sort_order)');
        await customStatement('CREATE INDEX IF NOT EXISTS idx_coupon_rules_category ON coupon_rules(category_code)');

        // Create indexes for notifications table
        await customStatement('CREATE INDEX IF NOT EXISTS idx_notifications_type ON notifications(notification_type)');
        await customStatement('CREATE INDEX IF NOT EXISTS idx_notifications_is_read ON notifications(is_read)');
        await customStatement('CREATE INDEX IF NOT EXISTS idx_notifications_published_at ON notifications(published_at)');
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from == 1 && to >= 2) {
          // Create new tables for Sites and SiteStatuses
          await m.createTable(sites);
          await m.createTable(siteStatuses);

          // Create indexes for performance
          await customStatement('CREATE INDEX IF NOT EXISTS idx_sites_code ON sites(code)');
          await customStatement('CREATE INDEX IF NOT EXISTS idx_sites_favorite ON sites(is_favorite)');

          // No data migration - will re-fetch from S3
        }

        if (from <= 2 && to >= 3) {
          // Create brands table
          await m.createTable(brands);

          // Create indexes for performance
          await customStatement('CREATE INDEX IF NOT EXISTS idx_brands_is_premium ON brands(is_premium)');
          await customStatement('CREATE INDEX IF NOT EXISTS idx_brands_category ON brands(category)');
          await customStatement('CREATE INDEX IF NOT EXISTS idx_brands_sort_order ON brands(sort_order)');
          await customStatement('CREATE INDEX IF NOT EXISTS idx_brands_active_dates ON brands(is_active, start_date, end_date)');
        }

        if (from <= 3 && to >= 4) {
          // Drop and recreate brands table (remove descriptionMarkdown column, fix descriptionMdUrl nullable)
          await m.deleteTable('brands');
          await m.createTable(brands);

          // Recreate indexes
          await customStatement('CREATE INDEX IF NOT EXISTS idx_brands_is_premium ON brands(is_premium)');
          await customStatement('CREATE INDEX IF NOT EXISTS idx_brands_category ON brands(category)');
          await customStatement('CREATE INDEX IF NOT EXISTS idx_brands_sort_order ON brands(sort_order)');
          await customStatement('CREATE INDEX IF NOT EXISTS idx_brands_active_dates ON brands(is_active, start_date, end_date)');
        }

        if (from <= 4 && to >= 5) {
          // Create coupon_rules table
          await m.createTable(couponRules);

          // Create indexes for performance
          await customStatement('CREATE INDEX IF NOT EXISTS idx_coupon_rules_brand_id ON coupon_rules(brand_id)');
          await customStatement('CREATE INDEX IF NOT EXISTS idx_coupon_rules_is_active ON coupon_rules(is_active)');
          await customStatement('CREATE INDEX IF NOT EXISTS idx_coupon_rules_active_sort ON coupon_rules(is_active, sort_order)');
          await customStatement('CREATE INDEX IF NOT EXISTS idx_coupon_rules_category ON coupon_rules(category_code)');
        }

        if (from <= 5 && to >= 6) {
          // Update coupon_rules table for API v2
          // SQLite doesn't support ALTER COLUMN, so we need to recreate the table
          await customStatement('ALTER TABLE coupon_rules RENAME TO coupon_rules_old');
          await m.createTable(couponRules);

          // Copy data from old table (cardImageUrl will be preserved, donationCode will be null)
          await customStatement('''
            INSERT INTO coupon_rules
            SELECT
              id, is_active, category_code, title, brand_id, brand_name,
              card_image_url, NULL as donation_code, is_premium, promo_label,
              short_notice, unit_price, display_unit, currency_code,
              exchange_display_text, exchange_input_type, exchange_flow_type,
              asset_redeem_type, max_per_exchange_count, exchange_step_value,
              geofence_area_ids, exchangeable_start_at, exchangeable_end_at,
              last_updated_at, carousel_list, exchange_alert,
              external_redemption_url, rules_summary_md_url,
              redemption_terms_md_url, user_instruction_md_url,
              staff_instruction_md_url, sort_order, cached_at
            FROM coupon_rules_old
          ''');

          await customStatement('DROP TABLE coupon_rules_old');

          // Recreate indexes
          await customStatement('CREATE INDEX IF NOT EXISTS idx_coupon_rules_brand_id ON coupon_rules(brand_id)');
          await customStatement('CREATE INDEX IF NOT EXISTS idx_coupon_rules_is_active ON coupon_rules(is_active)');
          await customStatement('CREATE INDEX IF NOT EXISTS idx_coupon_rules_active_sort ON coupon_rules(is_active, sort_order)');
          await customStatement('CREATE INDEX IF NOT EXISTS idx_coupon_rules_category ON coupon_rules(category_code)');
        }

        if (from <= 6 && to >= 7) {
          // Create coupon_rule_statuses table
          await m.createTable(couponRuleStatuses);
        }

        if (from <= 7 && to >= 8) {
          // Create carousels table
          await m.createTable(carousels);

          // Create indexes for performance
          await customStatement('CREATE INDEX IF NOT EXISTS idx_carousels_placement_key ON carousels(placement_key)');
          await customStatement('CREATE INDEX IF NOT EXISTS idx_carousels_sort_order ON carousels(sort_order)');
          await customStatement('CREATE INDEX IF NOT EXISTS idx_carousels_published_at ON carousels(published_at)');
        }

        if (from <= 8 && to >= 9) {
          // Create member_coupons table
          await m.createTable(memberCoupons);
          // Create indexes for performance
          await customStatement('CREATE INDEX IF NOT EXISTS idx_member_coupons_status ON member_coupons(current_status)');
          await customStatement('CREATE INDEX IF NOT EXISTS idx_member_coupons_updated ON member_coupons(last_updated_at)');
        }

        if (from <= 9 && to >= 10) {
          // Create notifications table
          await m.createTable(notifications);
          // Create indexes for performance
          await customStatement('CREATE INDEX IF NOT EXISTS idx_notifications_type ON notifications(notification_type)');
          await customStatement('CREATE INDEX IF NOT EXISTS idx_notifications_is_read ON notifications(is_read)');
          await customStatement('CREATE INDEX IF NOT EXISTS idx_notifications_published_at ON notifications(published_at)');
        }

        if (from <= 10 && to >= 11) {
          // Add exchangeUnits column to memberCoupons table
          await m.addColumn(memberCoupons, memberCoupons.exchangeUnits);
        }
      },
    );
  }

  // --- Member Coupons Queries ---

  /// Get the latest lastUpdatedAt timestamp for incremental sync
  Future<DateTime?> getLatestMemberCouponUpdatedAt() async {
    final query = select(memberCoupons)
      ..orderBy([(t) => OrderingTerm(expression: t.lastUpdatedAt, mode: OrderingMode.desc)])
      ..limit(1);
    final result = await query.getSingleOrNull();
    return result?.lastUpdatedAt;
  }

  /// Batch upsert member coupons
  Future<void> upsertMemberCoupons(List<MemberCouponModel> coupons) async {
    developer.log('[DEBUG] upsertMemberCoupons called with ${coupons.length} coupons');
    developer.log('[DEBUG] Coupon IDs: ${coupons.map((c) => c.memberCouponId).toList()}');
    developer.log('[DEBUG] Database instance: ${identityHashCode(this)}');

    await batch((batch) {
      for (final coupon in coupons) {
        batch.insert(
          memberCoupons,
          MemberCouponsCompanion.insert(
            id: coupon.memberCouponId,
            couponRuleId: coupon.couponRuleId,
            currentStatus: coupon.currentStatus.name.toUpperCase(),
            issuedAt: DateTime.parse(coupon.issuedAt),
            useStartAt: DateTime.parse(coupon.useStartAt),
            expiredAt: Value(coupon.expiredAt != null ? DateTime.parse(coupon.expiredAt!) : null),
            usedAt: Value(coupon.usedAt != null ? DateTime.parse(coupon.usedAt!) : null),
            canceledAt: Value(coupon.canceledAt != null ? DateTime.parse(coupon.canceledAt!) : null),
            revokedAt: Value(coupon.revokedAt != null ? DateTime.parse(coupon.revokedAt!) : null),
            lastUpdatedAt: DateTime.parse(coupon.lastUpdatedAt),
            redemptionCredentials: coupon.redemptionCredentials,
            exchangeUnits: Value(coupon.exchangeUnits),
            cachedAt: Value(DateTime.now()),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });

    developer.log('[DEBUG] upsertMemberCoupons completed');
  }

  /// Delete member coupons
  Future<void> deleteMemberCoupons(List<String> ids) async {
    await (delete(memberCoupons)..where((t) => t.id.isIn(ids))).go();
  }

  /// Update specific coupon status
  Future<void> updateMemberCouponStatus(String id, String status, DateTime? usedAt) async {
    await (update(memberCoupons)..where((t) => t.id.equals(id))).write(
      MemberCouponsCompanion(
        currentStatus: Value(status),
        usedAt: Value(usedAt),
        lastUpdatedAt: Value(DateTime.now()), // Local update time
      ),
    );
  }

  /// Watch active member coupons (ACTIVE, UNAVAILABLE, HOLDING)
  Stream<List<MemberCouponModel>> watchActiveMemberCoupons() {
    return (select(memberCoupons)
          ..where((t) => t.currentStatus.isIn(['ACTIVE', 'UNAVAILABLE', 'HOLDING']))
          ..orderBy([(t) => OrderingTerm(expression: t.issuedAt, mode: OrderingMode.desc)]))
        .watch()
        .map(_entitiesToMemberCoupons);
  }

  /// Watch used/expired coupons
  Stream<List<MemberCouponModel>> watchHistoryMemberCoupons() {
    return (select(memberCoupons)
          ..where((t) => t.currentStatus.isIn(['USED', 'EXPIRED']))
          ..orderBy([(t) => OrderingTerm(expression: t.lastUpdatedAt, mode: OrderingMode.desc)]))
        .watch()
        .map(_entitiesToMemberCoupons);
  }

  /// Watch coupons for expired check (Active/Holding/Unavailable/Expired)
  /// Excludes USED, CANCELED, REVOKED which are final states handled elsewhere
  /// Used by Expired Tab to perform date-based filtering on a single stream
  /// 
  /// NOTE: This returns a SINGLE stream event containing all potential candidates.
  /// Filtering for "Active but Date-Expired" happens in the provider.
  /// This prevents the flickering issue caused by combining two separate streams (active + history).
  Stream<List<MemberCouponModel>> watchCouponsForExpiredCheck() {
    return (select(memberCoupons)
          ..where((t) => t.currentStatus.isNotIn(['USED', 'CANCELED', 'REVOKED']))
          ..orderBy([(t) => OrderingTerm(expression: t.expiredAt, mode: OrderingMode.desc)]))
        .watch()
        .map(_entitiesToMemberCoupons);
  }
  
  /// Clear all member coupons (for logout)
  Future<void> clearAllMemberCoupons() async {
    await delete(memberCoupons).go();
  }

  /// Get member coupons by IDs (for fetching freshly issued coupons)
  Future<List<MemberCouponModel>> getMemberCouponsByIds(List<String> ids) async {
    developer.log('[DEBUG] getMemberCouponsByIds called with ids: $ids');
    developer.log('[DEBUG] Database instance: ${identityHashCode(this)}');

    if (ids.isEmpty) return [];
    final query = select(memberCoupons)..where((t) => t.id.isIn(ids));
    final entities = await query.get();

    developer.log('[DEBUG] Found ${entities.length} entities');
    developer.log('[DEBUG] Entity IDs: ${entities.map((e) => e.id).toList()}');

    return _entitiesToMemberCoupons(entities);
  }

  List<MemberCouponModel> _entitiesToMemberCoupons(List<MemberCouponEntity> entities) {
    return entities.map((e) => MemberCouponModel(
      memberCouponId: e.id,
      couponRuleId: e.couponRuleId,
      currentStatus: MemberCouponStatus.values.firstWhere(
        (s) => s.name.toUpperCase() == e.currentStatus.toUpperCase(),
        orElse: () => MemberCouponStatus.unavailable,
      ),
      syncAction: SyncAction.upsert, // Default for reading
      issuedAt: e.issuedAt.toIso8601String(),
      useStartAt: e.useStartAt.toIso8601String(),
      expiredAt: e.expiredAt?.toIso8601String(),
      usedAt: e.usedAt?.toIso8601String(),
      canceledAt: e.canceledAt?.toIso8601String(),
      revokedAt: e.revokedAt?.toIso8601String(),
      lastUpdatedAt: e.lastUpdatedAt.toIso8601String(),
      redemptionCredentials: e.redemptionCredentials,
      exchangeUnits: e.exchangeUnits,
    )).toList();
  }

  // --- Points History Queries ---

  Future<DateTime?> getLatestLastUpdatedAt() async {
    final query = select(pointLogs)
      ..orderBy([(t) => OrderingTerm(expression: t.lastUpdatedAt, mode: OrderingMode.desc)])
      ..limit(1);
    
    final result = await query.getSingleOrNull();
    return result?.lastUpdatedAt;
  }

  Future<void> upsertPointLogs(List<PointLog> logs) async {
    await batch((batch) {
      for (final log in logs) {
        batch.insert(
          pointLogs,
          PointLogsCompanion.insert(
            logId: log.logId,
            logType: log.logType,
            iconTypeCode: log.iconTypeCode,
            detailType: log.detailType,
            currencyCode: log.currencyCode,
            title: log.title,
            pointsChange: log.pointsChange,
            occurredAt: DateTime.parse(log.occurredAt),
            lastUpdatedAt: DateTime.parse(log.lastUpdatedAt),
            detailsRaw: Value(log.detailsRaw),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  Stream<List<PointLog>> watchPointLogs() {
    return (select(pointLogs)
          ..orderBy([(t) => OrderingTerm(expression: t.occurredAt, mode: OrderingMode.desc)]))
        .watch()
        .map((entities) => entities.map((e) => PointLog(
              logId: e.logId,
              logType: e.logType,
              iconTypeCode: e.iconTypeCode,
              currencyCode: e.currencyCode,
              title: e.title,
              pointsChange: e.pointsChange,
              occurredAt: e.occurredAt.toIso8601String(),
              detailType: e.detailType,
              lastUpdatedAt: e.lastUpdatedAt.toIso8601String(),
              detailsRaw: e.detailsRaw,
            )).toList());
  }

  Future<void> pruneOldLogs(DateTime threshold) async {
    await (delete(pointLogs)..where((t) => t.occurredAt.isSmallerThanValue(threshold))).go();
  }
  
  Future<void> clearAll() async {
      await delete(pointLogs).go();
  }

  // --- Sites Queries ---

  /// Watch all sites (reactive stream)
  Stream<List<Site>> watchSites() {
    return select(sites).watch().map((entities) {
      final sites = _entitiesToSites(entities);
      developer.log('[AppDatabase.watchSites] Emitting ${sites.length} sites');
      return sites;
    });
  }

  /// Watch favorite sites only
  Stream<List<Site>> watchFavoriteSites() {
    final query = select(sites).join([
      leftOuterJoin(siteStatuses, siteStatuses.siteId.equalsExp(sites.id)),
    ]);

    query.where(sites.isFavorite.equals(true));

    return query.watch().map((rows) {
      final sitesList = rows.map((row) {
        final siteEntity = row.readTable(sites);
        final statusEntity = row.readTableOrNull(siteStatuses);

        final site = _entityToSite(siteEntity);

        // Merge status if available
        if (statusEntity != null) {
          site.statusData = _entityToSiteStatus(statusEntity);
          site.statusAvailable = true;
        }

        return site;
      }).toList();

      return sitesList;
    });
  }

  /// Watch sites with status joined (LEFT JOIN)
  Stream<List<Site>> watchSitesWithStatus() {
    final query = select(sites).join([
      leftOuterJoin(siteStatuses, siteStatuses.siteId.equalsExp(sites.id)),
    ]);

    return query.watch().map((rows) {
      final sitesList = rows.map((row) {
        final siteEntity = row.readTable(sites);
        final statusEntity = row.readTableOrNull(siteStatuses);

        final site = _entityToSite(siteEntity);

        // Merge status if available
        if (statusEntity != null) {
          site.statusData = _entityToSiteStatus(statusEntity);
          site.statusAvailable = true;
        }

        return site;
      }).toList();

      developer.log('[AppDatabase.watchSitesWithStatus] Emitting ${sitesList.length} sites');
      return sitesList;
    });
  }

  /// Batch upsert sites (for S3 sync)
  /// PRESERVES existing favorite status
  Future<void> upsertSites(List<Site> sitesList) async {
    // 1. Get current favorite codes before writing
    final currentFavoriteCodes = await getFavoriteCodes();
    
    await batch((batch) {
      for (final site in sitesList) {
        // Check if this site was previously favorited
        final wasFavorite = currentFavoriteCodes.contains(site.code);

        batch.insert(
          sites,
          SitesCompanion.insert(
            id: site.id,
            code: site.code,
            name: site.name,
            siteType: site.type,
            address: site.address,
            longitude: site.longitude,
            latitude: site.latitude,
            serviceHours: site.serviceHours,
            areaId: site.areaId,
            districtId: site.districtId,
            note: Value(site.note),
            recyclableItems: site.recyclableItems,
            isFavorite: Value(wasFavorite), // Restore favorite status
            cachedAt: DateTime.now(),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });

    if (currentFavoriteCodes.isNotEmpty) {
      developer.log('[AppDatabase] Preserved ${currentFavoriteCodes.length} favorites during sync');
    }
  }

  /// Remove sites not in the provided list (cleanup deleted sites)
  Future<void> removeSitesNotInList(List<String> siteIds) async {
    await (delete(sites)..where((t) => t.id.isNotIn(siteIds))).go();
  }

  /// Clear all sites (Deep Clean)
  Future<void> clearAllSites() async {
    await delete(sites).go();
  }

  /// Get latest cache timestamp
  Future<DateTime?> getLatestSiteCachedAt() async {
    final query = select(sites)
      ..orderBy([(t) => OrderingTerm(expression: t.cachedAt, mode: OrderingMode.desc)])
      ..limit(1);
    final result = await query.getSingleOrNull();
    return result?.cachedAt;
  }

  // --- Favorites Management ---

  /// Set favorite status for a site
  Future<void> setFavorite(String siteCode, bool isFavorite) async {
    await (update(sites)..where((t) => t.code.equals(siteCode)))
        .write(SitesCompanion(isFavorite: Value(isFavorite)));
  }

  /// Get favorite site codes
  Future<List<String>> getFavoriteCodes() async {
    final favSites = await (select(sites)..where((t) => t.isFavorite.equals(true))).get();
    return favSites.map((e) => e.code).toList();
  }

  // --- Site Status Queries ---

  /// Batch upsert site statuses
  Future<void> upsertSiteStatuses(List<SiteStatus> statusList) async {
    await batch((batch) {
      for (final status in statusList) {
        batch.insert(
          siteStatuses,
          SiteStatusesCompanion.insert(
            siteId: status.siteId,
            displayStatus: status.displayStatus,
            cardType: Value(status.cardType),
            isOffHours: Value(status.isOffHours),
            itemStatusList: Value(status.itemStatusList),
            binStatusList: Value(status.binStatusList),
            statusCachedAt: DateTime.now(),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  /// Clear expired status (older than 1 hour)
  Future<void> clearExpiredStatuses() async {
    final threshold = DateTime.now().subtract(const Duration(hours: 1));
    await (delete(siteStatuses)
          ..where((t) => t.statusCachedAt.isSmallerThanValue(threshold)))
        .go();
  }

  /// Clear all statuses (called on logout)
  Future<void> clearAllStatuses() async {
    await delete(siteStatuses).go();
  }

  // --- Helper Methods ---

  List<Site> _entitiesToSites(List<SiteEntity> entities) {
    return entities.map(_entityToSite).toList();
  }

  Site _entityToSite(SiteEntity entity) {
    return Site(
      id: entity.id,
      code: entity.code,
      name: entity.name,
      type: entity.siteType,
      address: entity.address,
      longitude: entity.longitude,
      latitude: entity.latitude,
      serviceHours: entity.serviceHours,
      areaId: entity.areaId,
      districtId: entity.districtId,
      note: entity.note,
      recyclableItems: entity.recyclableItems,
      favorite: entity.isFavorite,
    );
  }

  SiteStatus _entityToSiteStatus(SiteStatusEntity entity) {
    return SiteStatus(
      siteId: entity.siteId,
      displayStatus: entity.displayStatus,
      cardType: entity.cardType,
      isOffHours: entity.isOffHours,
      itemStatusList: entity.itemStatusList,
      binStatusList: entity.binStatusList,
    );
  }

  // --- Brands Queries ---

  /// Watch all active brands (reactive stream)
  Stream<List<Brand>> watchActiveBrands() {
    final now = DateTime.now().toUtc();

    final query = select(brands)
      ..where((b) =>
          b.isActive.equals(true) &
          b.startDate.isSmallerOrEqualValue(now) &
          (b.endDate.isNull() | b.endDate.isBiggerOrEqualValue(now)))
      ..orderBy([(b) => OrderingTerm(expression: b.sortOrder)]);

    return query.watch().map(_entitiesToBrands);
  }

  /// Watch brands by specific category
  Stream<List<Brand>> watchActiveBrandsByCategory(BrandCategory category) {
    final now = DateTime.now().toUtc();

    final query = select(brands)
      ..where((b) =>
          b.isActive.equals(true) &
          b.category.equals(category.name) &
          b.startDate.isSmallerOrEqualValue(now) &
          (b.endDate.isNull() | b.endDate.isBiggerOrEqualValue(now)))
      ..orderBy([(b) => OrderingTerm(expression: b.sortOrder)]);

    return query.watch().map(_entitiesToBrands);
  }

  /// Watch premium brands (for carousel)
  Stream<List<Brand>> watchPremiumBrands() {
    final now = DateTime.now().toUtc();

    final query = select(brands)
      ..where((b) =>
          b.isActive.equals(true) &
          b.isPremium.equals(true) &
          b.startDate.isSmallerOrEqualValue(now) &
          (b.endDate.isNull() | b.endDate.isBiggerOrEqualValue(now)))
      ..orderBy([(b) => OrderingTerm(expression: b.sortOrder)]);

    return query.watch().map(_entitiesToBrands);
  }

  /// Watch a single brand by ID
  Stream<Brand?> watchBrandById(String brandId) {
    final query = select(brands)..where((b) => b.id.equals(brandId));
    return query.watchSingleOrNull().map((entity) {
      return entity != null ? _entityToBrand(entity) : null;
    });
  }

  /// Batch upsert brands (for S3 sync)
  Future<void> upsertBrands(List<Brand> brandsList) async {
    await batch((batch) {
      for (final brand in brandsList) {
        batch.insert(
          brands,
          BrandsCompanion.insert(
            id: brand.id,
            isActive: brand.isActive,
            name: brand.name,
            category: Value(brand.category),
            logoUrl: Value(brand.logoUrl),
            isPremium: brand.isPremium,
            startDate: brand.startDate,
            endDate: Value(brand.endDate),
            descriptionMdUrl: Value(brand.descriptionMdUrl),
            sortOrder: brand.sortOrder,
            couponRuleIds: brand.couponRuleIds,
            cachedAt: DateTime.now(),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  /// Clear all brands (Deep Clean)
  Future<void> clearAllBrands() async {
    await delete(brands).go();
  }

  /// Get latest cache timestamp for brands
  Future<DateTime?> getLatestBrandCachedAt() async {
    final query = select(brands)
      ..orderBy([
        (t) => OrderingTerm(expression: t.cachedAt, mode: OrderingMode.desc)
      ])
      ..limit(1);
    final result = await query.getSingleOrNull();
    return result?.cachedAt;
  }

  // --- Brand Helper Methods ---

  List<Brand> _entitiesToBrands(List<BrandEntity> entities) {
    return entities.map(_entityToBrand).toList();
  }

  Brand _entityToBrand(BrandEntity entity) {
    return Brand(
      id: entity.id,
      isActive: entity.isActive,
      name: entity.name,
      category: entity.category,
      logoUrl: entity.logoUrl,
      isPremium: entity.isPremium,
      startDate: entity.startDate,
      endDate: entity.endDate,
      descriptionMdUrl: entity.descriptionMdUrl,
      sortOrder: entity.sortOrder,
      couponRuleIds: entity.couponRuleIds,
    );
  }

  // --- Coupon Rules Queries ---

  /// Watch all active coupon rules (reactive stream)
  Stream<List<CouponRule>> watchActiveCouponRules() {
    final now = DateTime.now().toUtc();

    final query = select(couponRules)
      ..where((c) =>
          c.isActive.equals(true) &
          c.exchangeableStartAt.isSmallerOrEqualValue(now) &
          (c.exchangeableEndAt.isNull() | c.exchangeableEndAt.isBiggerOrEqualValue(now)))
      ..orderBy([(c) => OrderingTerm(expression: c.sortOrder)]);

    return query.watch().map(_entitiesToCouponRules);
  }

  /// Watch all coupon rules (including inactive)
  Stream<List<CouponRule>> watchAllCouponRules() {
    final query = select(couponRules)
      ..orderBy([(c) => OrderingTerm(expression: c.sortOrder)]);

    return query.watch().map(_entitiesToCouponRules);
  }

  /// Watch coupon rules by category
  Stream<List<CouponRule>> watchCouponRulesByCategory(String categoryCode) {
    final now = DateTime.now().toUtc();

    final query = select(couponRules)
      ..where((c) =>
          c.isActive.equals(true) &
          c.categoryCode.equals(categoryCode.toUpperCase()) &
          c.exchangeableStartAt.isSmallerOrEqualValue(now) &
          (c.exchangeableEndAt.isNull() | c.exchangeableEndAt.isBiggerOrEqualValue(now)))
      ..orderBy([(c) => OrderingTerm(expression: c.sortOrder)]);

    return query.watch().map(_entitiesToCouponRules);
  }

  /// Watch coupon rules by brand
  Stream<List<CouponRule>> watchCouponRulesByBrand(String brandId) {
    final now = DateTime.now().toUtc();

    final query = select(couponRules)
      ..where((c) =>
          c.isActive.equals(true) &
          c.brandId.equals(brandId) &
          c.exchangeableStartAt.isSmallerOrEqualValue(now) &
          (c.exchangeableEndAt.isNull() | c.exchangeableEndAt.isBiggerOrEqualValue(now)))
      ..orderBy([(c) => OrderingTerm(expression: c.sortOrder)]);

    return query.watch().map(_entitiesToCouponRules);
  }

  /// Get a single coupon rule by ID
  Future<CouponRule?> getCouponRuleById(String id) async {
    final query = select(couponRules)..where((c) => c.id.equals(id));
    final entity = await query.getSingleOrNull();
    return entity != null ? _entityToCouponRule(entity) : null;
  }

  /// Get all active coupon rules (snapshot)
  Future<List<CouponRule>> getActiveCouponRules() async {
    final now = DateTime.now().toUtc();

    final query = select(couponRules)
      ..where((c) =>
          c.isActive.equals(true) &
          c.exchangeableStartAt.isSmallerOrEqualValue(now) &
          (c.exchangeableEndAt.isNull() | c.exchangeableEndAt.isBiggerOrEqualValue(now)))
      ..orderBy([(c) => OrderingTerm(expression: c.sortOrder)]);

    final entities = await query.get();
    return _entitiesToCouponRules(entities);
  }

  /// Batch upsert coupon rules (for S3 sync)
  Future<void> upsertCouponRules(List<CouponRule> couponRulesList) async {
    await batch((batch) {
      for (final couponRule in couponRulesList) {
        batch.insert(
          couponRules,
          couponRule.toTableCompanion(),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  /// Clear all coupon rules (Deep Clean)
  Future<void> clearAllCouponRules() async {
    await delete(couponRules).go();
  }

  /// Get latest cache timestamp for coupon rules
  Future<DateTime?> getLatestCouponRuleCachedAt() async {
    final query = select(couponRules)
      ..orderBy([
        (t) => OrderingTerm(expression: t.cachedAt, mode: OrderingMode.desc)
      ])
      ..limit(1);
    final result = await query.getSingleOrNull();
    return result?.cachedAt;
  }

  // --- Coupon Rules Helper Methods ---

  List<CouponRule> _entitiesToCouponRules(List<CouponRuleEntity> entities) {
    return entities.map(_entityToCouponRule).toList();
  }

  CouponRule _entityToCouponRule(CouponRuleEntity entity) {
    return CouponRule(
      id: entity.id,
      isActive: entity.isActive,
      categoryCode: CouponCategory.values.firstWhere(
        (e) => e.name.toUpperCase() == entity.categoryCode.toUpperCase(),
        orElse: () => CouponCategory.uncategorized,
      ),
      title: entity.title,
      brandId: entity.brandId,
      brandName: entity.brandName,
      cardImageUrl: entity.cardImageUrl,
      donationCode: entity.donationCode,
      isPremium: entity.isPremium,
      promoLabel: entity.promoLabel,
      shortNotice: entity.shortNotice,
      unitPrice: entity.unitPrice,
      displayUnit: entity.displayUnit,
      currencyCode: CurrencyCode.values.firstWhere(
        (e) => e.name.toUpperCase() == entity.currencyCode.toUpperCase(),
      ),
      exchangeDisplayText: entity.exchangeDisplayText,
      exchangeInputType: ExchangeInputType.values.firstWhere(
        (e) => e.name.toUpperCase() == entity.exchangeInputType.toUpperCase(),
      ),
      exchangeFlowType: ExchangeFlowType.values.firstWhere(
        (e) => e.name.toUpperCase() == entity.exchangeFlowType.toUpperCase(),
        orElse: () => ExchangeFlowType.unknown,
      ),
      assetRedeemType: AssetRedeemType.values.firstWhere(
        (e) => e.name.toUpperCase() == entity.assetRedeemType.toUpperCase(),
      ),
      maxPerExchangeCount: entity.maxPerExchangeCount,
      exchangeStepValue: entity.exchangeStepValue,
      geofenceAreaIds: entity.geofenceAreaIds,
      exchangeableStartAt: entity.exchangeableStartAt,
      exchangeableEndAt: entity.exchangeableEndAt,
      lastUpdatedAt: entity.lastUpdatedAt,
      carouselList: entity.carouselList,
      exchangeAlert: entity.exchangeAlert,
      externalRedemptionUrl: entity.externalRedemptionUrl,
      rulesSummaryMdUrl: entity.rulesSummaryMdUrl,
      redemptionTermsMdUrl: entity.redemptionTermsMdUrl,
      userInstructionMdUrl: entity.userInstructionMdUrl,
      staffInstructionMdUrl: entity.staffInstructionMdUrl,
      sortOrder: entity.sortOrder,
    );
  }

  // --- Coupon Rule Status Queries ---

  /// Batch upsert coupon rule statuses
  Future<void> upsertCouponRuleStatuses(List<CouponStatusItem> statusList) async {
    await batch((batch) {
      for (final status in statusList) {
        batch.insert(
          couponRuleStatuses,
          CouponRuleStatusesCompanion.insert(
            couponRuleId: status.couponRuleId,
            displayStatus: status.displayStatus.name.toUpperCase(),
            statusCachedAt: DateTime.now(),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  /// Watch active coupon rules WITH status (INNER JOIN - only with status)
  Stream<List<CouponRule>> watchActiveCouponRulesWithStatus() {
    final now = DateTime.now().toUtc();

    // INNER JOIN - only return coupons that have status records
    final query = select(couponRules).join([
      innerJoin(
        couponRuleStatuses,
        couponRuleStatuses.couponRuleId.equalsExp(couponRules.id),
      ),
    ]);

    query.where(
      couponRules.isActive.equals(true) &
      couponRules.exchangeableStartAt.isSmallerOrEqualValue(now) &
      (couponRules.exchangeableEndAt.isNull() |
       couponRules.exchangeableEndAt.isBiggerOrEqualValue(now))
    );

    query.orderBy([
      OrderingTerm(expression: couponRules.sortOrder)
    ]);

    return query.watch().map((rows) {
      return rows.map((row) {
        final couponRule = _entityToCouponRule(row.readTable(couponRules));
        final statusEntity = row.readTable(couponRuleStatuses);  // Must exist (INNER JOIN)

        // Parse displayStatus from database and set runtime property
        couponRule.displayStatus = DisplayStatus.values.firstWhere(
          (e) => e.name.toUpperCase() == statusEntity.displayStatus.toUpperCase(),
          orElse: () => DisplayStatus.normal,
        );

        return couponRule;
      }).toList();
    });
  }

  /// Delete coupon statuses not in the provided list (cleanup orphaned records)
  Future<void> deleteOrphanedCouponStatuses(List<String> validCouponRuleIds) async {
    await (delete(couponRuleStatuses)
      ..where((t) => t.couponRuleId.isNotIn(validCouponRuleIds))
    ).go();
  }

  /// Clear expired coupon statuses (older than 5 minutes)
  Future<void> clearExpiredCouponStatuses() async {
    final threshold = DateTime.now().subtract(const Duration(minutes: 5));
    await (delete(couponRuleStatuses)
      ..where((t) => t.statusCachedAt.isSmallerThanValue(threshold))
    ).go();
  }

  // --- Carousel Queries ---

  /// Watch carousels by placement key (filtered by publishedAt/expiredAt)
  Stream<List<CarouselModel>> watchCarouselsByPlacement(String placementKey) {
    final now = DateTime.now().toUtc();

    final query = select(carousels)
      ..where((c) =>
          c.placementKey.equals(placementKey) &
          c.publishedAt.isSmallerOrEqualValue(now) &
          (c.expiredAt.isNull() | c.expiredAt.isBiggerOrEqualValue(now)))
      ..orderBy([(c) => OrderingTerm(expression: c.sortOrder)]);

    return query.watch().map(_entitiesToCarousels);
  }

  /// Batch upsert carousels (for S3 sync)
  Future<void> upsertCarousels(List<CarouselModel> carouselsList) async {
    await batch((batch) {
      for (final carousel in carouselsList) {
        batch.insert(
          carousels,
          CarouselsCompanion.insert(
            id: carousel.id,
            placementKey: carousel.placementKey,
            title: carousel.title,
            promotionCode: Value(carousel.promotionCode),
            mediaType: carousel.mediaType,
            mediaUrl: carousel.mediaUrl,
            fallbackUrl: Value(carousel.fallbackUrl),
            actionType: carousel.actionType,
            actionLink: Value(carousel.actionLink),
            sortOrder: carousel.sortOrder,
            publishedAt: carousel.publishedAt,
            expiredAt: Value(carousel.expiredAt),
            cachedAt: DateTime.now(),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  /// Delete carousels not in the provided list (cleanup after S3 sync)
  Future<void> deleteCarouselsNotInList(List<String> ids) async {
    await (delete(carousels)..where((c) => c.id.isNotIn(ids))).go();
  }

  /// Clear all carousels (Deep Clean)
  Future<void> clearAllCarousels() async {
    await delete(carousels).go();
  }

  /// Get latest cache timestamp for carousels
  Future<DateTime?> getLatestCarouselCachedAt() async {
    final query = select(carousels)
      ..orderBy([
        (t) => OrderingTerm(expression: t.cachedAt, mode: OrderingMode.desc)
      ])
      ..limit(1);
    final result = await query.getSingleOrNull();
    return result?.cachedAt;
  }

  // --- Carousel Helper Methods ---

  List<CarouselModel> _entitiesToCarousels(List<Carousel> entities) {
    return entities.map(_entityToCarousel).toList();
  }

  CarouselModel _entityToCarousel(Carousel entity) {
    return CarouselModel(
      id: entity.id,
      placementKey: entity.placementKey,
      title: entity.title,
      promotionCode: entity.promotionCode,
      mediaType: entity.mediaType,
      mediaUrl: entity.mediaUrl,
      fallbackUrl: entity.fallbackUrl,
      actionType: entity.actionType,
      actionLink: entity.actionLink,
      sortOrder: entity.sortOrder,
      publishedAt: entity.publishedAt,
      expiredAt: entity.expiredAt,
    );
  }

  // --- Notifications Queries ---

  /// Watch notifications by type (ANNOUNCEMENT or CAMPAIGN)
  Stream<List<NotificationItemModel>> watchNotificationsByType(NotificationType type) {
    final now = DateTime.now().toUtc();
    final typeString = type.name.toUpperCase();

    final query = select(notifications)
      ..where((n) {
        if (type == NotificationType.personal) {
          return n.notificationType.equals(typeString);
        } else {
          return n.notificationType.equals(typeString) &
              n.publishedAt.isSmallerOrEqualValue(now) &
              (n.expiredAt.isNull() | n.expiredAt.isBiggerOrEqualValue(now));
        }
      })
      ..orderBy([(n) => OrderingTerm(expression: n.publishedAt, mode: OrderingMode.desc)]);

    return query.watch().map(_entitiesToNotificationItems);
  }

  /// Watch unread counts for both types
  Stream<UnreadNotificationCounts> watchUnreadNotificationCounts() {
    final now = DateTime.now().toUtc();

    return customSelect(
      '''
      SELECT
        SUM(CASE WHEN notification_type = 'ANNOUNCEMENT' AND is_read = 0 AND published_at <= ? AND (expired_at IS NULL OR expired_at >= ?) THEN 1 ELSE 0 END) as announcements,
        SUM(CASE WHEN notification_type = 'CAMPAIGN' AND is_read = 0 AND published_at <= ? AND (expired_at IS NULL OR expired_at >= ?) THEN 1 ELSE 0 END) as campaigns,
        SUM(CASE WHEN notification_type = 'PERSONAL' AND is_read = 0 THEN 1 ELSE 0 END) as personal
      FROM notifications
      ''',
      variables: [Variable.withDateTime(now), Variable.withDateTime(now), Variable.withDateTime(now), Variable.withDateTime(now)],
      readsFrom: {notifications},
    ).watch().map((rows) {
      if (rows.isEmpty) {
        return UnreadNotificationCounts(announcements: 0, campaigns: 0, personal: 0);
      }
      final row = rows.first;
      return UnreadNotificationCounts(
        announcements: row.read<int?>('announcements') ?? 0,
        campaigns: row.read<int?>('campaigns') ?? 0,
        personal: row.read<int?>('personal') ?? 0,
      );
    });
  }

  /// Get unread count for a specific type
  Future<int> getUnreadCountByType(NotificationType type) async {
    final now = DateTime.now().toUtc();
    final typeString = type.name.toUpperCase();

    final query = select(notifications)
      ..where((n) {
        if (type == NotificationType.personal) {
          return n.notificationType.equals(typeString) & n.isRead.equals(false);
        } else {
          return n.notificationType.equals(typeString) &
              n.isRead.equals(false) &
              n.publishedAt.isSmallerOrEqualValue(now) &
              (n.expiredAt.isNull() | n.expiredAt.isBiggerOrEqualValue(now));
        }
      });

    final results = await query.get();
    return results.length;
  }

  /// Get all read notification IDs (for backup before deep clean)
  Future<List<String>> getReadNotificationIds() async {
    final query = select(notifications)..where((n) => n.isRead.equals(true));
    final results = await query.get();
    return results.map((e) => e.id).toList();
  }

  /// Batch upsert notifications (preserves read status)
  Future<void> upsertNotifications(List<NotificationItemModel> notificationsList, NotificationType type) async {
    final typeString = type.name.toUpperCase();

    // First, get existing read statuses to preserve them
    final existingIds = notificationsList.map((n) => n.id).toList();
    final existingQuery = select(notifications)..where((n) => n.id.isIn(existingIds));
    final existingEntities = await existingQuery.get();
    final readStatusMap = {for (var e in existingEntities) e.id: (e.isRead, e.readAt)};

    await batch((batch) {
      for (final notification in notificationsList) {
        final existing = readStatusMap[notification.id];
        final isRead = existing?.$1 ?? false;
        final readAt = existing?.$2;

        batch.insert(
          notifications,
          NotificationsCompanion.insert(
            id: notification.id,
            notificationType: typeString,
            title: notification.title,
            tagText: Value(notification.tagText),
            summary: notification.summary,
            publishedAt: notification.publishedAt.toUtc(),
            expiredAt: Value(notification.expiredAt?.toUtc()),
            actionType: notification.actionType,
            actionLink: Value(notification.actionLink),
            isRead: Value(isRead),
            readAt: Value(readAt),
            cachedAt: DateTime.now().toUtc(),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  /// Mark a single notification as read
  Future<void> markNotificationAsRead(String id) async {
    await (update(notifications)..where((n) => n.id.equals(id))).write(
      NotificationsCompanion(
        isRead: const Value(true),
        readAt: Value(DateTime.now()),
      ),
    );
  }

  /// Mark all notifications of a specific type as read
  Future<void> markAllNotificationsAsReadByType(NotificationType type) async {
    final typeString = type.name.toUpperCase();

    await (update(notifications)
          ..where((n) => n.notificationType.equals(typeString) & n.isRead.equals(false)))
        .write(
      NotificationsCompanion(
        isRead: const Value(true),
        readAt: Value(DateTime.now()),
      ),
    );
  }

  /// Watch personal notifications
  Stream<List<NotificationItemModel>> watchPersonalNotifications() {
    return watchNotificationsByType(NotificationType.personal);
  }

  /// Delete notifications not in the provided list (cleanup after S3 sync)
  Future<void> deleteNotificationsNotInList(List<String> ids, NotificationType type) async {
    final typeString = type.name.toUpperCase();
    await (delete(notifications)
          ..where((n) => n.notificationType.equals(typeString) & n.id.isNotIn(ids)))
        .go();
  }

  /// Get latest cache timestamp for notifications
  Future<DateTime?> getLatestNotificationCachedAt() async {
    final query = select(notifications)
      ..orderBy([
        (t) => OrderingTerm(expression: t.cachedAt, mode: OrderingMode.desc)
      ])
      ..limit(1);
    final result = await query.getSingleOrNull();
    return result?.cachedAt;
  }

  /// Clear all notifications (for logout or reset)
  Future<void> clearAllNotifications() async {
    await delete(notifications).go();
  }

  // --- Notifications Helper Methods ---

  List<NotificationItemModel> _entitiesToNotificationItems(List<Notification> entities) {
    return entities.map(_entityToNotificationItem).toList();
  }

  NotificationItemModel _entityToNotificationItem(Notification entity) {
    return NotificationItemModel(
      id: entity.id,
      title: entity.title,
      tagText: entity.tagText,
      summary: entity.summary,
      publishedAt: entity.publishedAt,
      expiredAt: entity.expiredAt,
      actionType: entity.actionType,
      actionLink: entity.actionLink,
      notificationType: NotificationType.values.firstWhere(
        (t) => t.name.toUpperCase() == entity.notificationType,
        orElse: () => NotificationType.announcement,
      ),
      isRead: entity.isRead,
      readAt: entity.readAt,
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    // Use different database file for mock flavor to keep test data separate
    final dbFileName = F.appFlavor == Flavor.mock ? 'db_mock.sqlite' : 'db.sqlite';
    final file = File(p.join(dbFolder.path, dbFileName));
    return NativeDatabase.createInBackground(file);
  });
}
