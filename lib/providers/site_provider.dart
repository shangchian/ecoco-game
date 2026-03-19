import 'dart:developer';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '/models/site_model.dart';
import '/providers/site_repository_provider.dart';

part 'site_provider.g.dart';

@Riverpod(keepAlive: true)
class Sites extends _$Sites {
  @override
  Stream<List<Site>> build() {
    final repository = ref.watch(siteRepositoryProvider);

    // Initialize sync in background (don't await)
    _initSync();

    // Return reactive stream from repository
    return repository.watchSitesWithStatus();
  }

  void _initSync() {
    final repository = ref.read(siteRepositoryProvider);

    // Sync sites (respects cache) - run in background
    repository.syncSites().catchError((e) {
      log('Sites sync failed: $e');
    });

    // Sync statuses in background
    repository.syncSiteStatuses().catchError((e) {
      log('Status sync failed (non-critical): $e');
    });
  }

  /// Refresh sites and statuses
  Future<void> refresh() async {
    final repository = ref.read(siteRepositoryProvider);
    await repository.syncSites(forceRefresh: true);
    await repository.syncSiteStatuses(forceRefresh: true);
  }

  /// Toggle favorite
  Future<void> toggleFavorite(String siteCode, bool isFavorite) async {
    final repository = ref.read(siteRepositoryProvider);
    if (isFavorite) {
      await repository.addFavorite(siteCode);
    } else {
      await repository.removeFavorite(siteCode);
    }
    // Stream automatically updates UI
  }
}
