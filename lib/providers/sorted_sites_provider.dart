import 'dart:math';
import 'dart:developer' as developer;

import '/models/site_model.dart';
import '/providers/location_provider.dart';
import '/providers/site_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sorted_sites_provider.g.dart';

double _calculateDistance(double lat1, double lng1, double lat2, double lng2) {
  const p = 0.017453292519943295; // Math.PI / 180
  final a = 0.5 -
      cos((lat2 - lat1) * p) / 2 +
      cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lng2 - lng1) * p)) / 2;
  return 12742 * asin(sqrt(a)); // 2 * R * asin(sqrt(a))
}

@riverpod
class FrozenFavoriteCodes extends _$FrozenFavoriteCodes {
  @override
  Set<String>? build() => null;

  void initialize(Set<String> codes) {
    state ??= codes;
  }

  void reset() {
    state = null;
  }
}

@riverpod
class SortedSites extends _$SortedSites {
  @override
  Stream<List<Site>> build() {
    // Watch sites stream directly from repository
    final repository = ref.watch(siteRepositoryProvider);
    final locationState = ref.watch(userLocationProvider);
    final frozenCodes = ref.watch(frozenFavoriteCodesProvider);

    return repository.watchSitesWithStatus().map((sites) {
      developer.log('Sorting ${sites.length} sites');

      // If frozen codes are not set, initialize them from the current favorite status.
      // We use Future.microtask to avoid modifying another provider during the build process.
      if (frozenCodes == null) {
        final currentFavCodes =
            sites.where((s) => s.favorite).map((s) => s.code).toSet();
        Future.microtask(() => ref
            .read(frozenFavoriteCodesProvider.notifier)
            .initialize(currentFavCodes));
      }

      return _sortSitesList(sites, locationState, frozenCodes);
    });
  }

  /// Reset the frozen favorite status to allow re-sorting
  void resetSorting() {
    ref.read(frozenFavoriteCodesProvider.notifier).reset();
  }

  /// Sort sites list (favorites first, then by distance)
  List<Site> _sortSitesList(
    List<Site> sites,
    LocationState locationState,
    Set<String>? frozenCodes,
  ) {
    // Calculate distances for all sites
    for (var site in sites) {
      site.distance = _calculateDistance(
        site.latitude,
        site.longitude,
        locationState.location.lat,
        locationState.location.lng,
      );
    }

    // Sort: favorites first (using frozen status if available), then by distance
    sites.sort((a, b) {
      final aIsFav = frozenCodes?.contains(a.code) ?? a.favorite;
      final bIsFav = frozenCodes?.contains(b.code) ?? b.favorite;

      if (aIsFav != bIsFav) {
        return bIsFav ? 1 : -1;
      }
      return (a.distance ?? double.infinity)
          .compareTo(b.distance ?? double.infinity);
    });

    return sites;
  }
}