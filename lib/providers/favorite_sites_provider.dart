import 'dart:developer' as dev;
import 'dart:math';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '/models/site_model.dart';
import '/providers/site_repository_provider.dart';
import '/providers/location_provider.dart';

part 'favorite_sites_provider.g.dart';

double _calculateDistance(double lat1, double lng1, double lat2, double lng2) {
  const p = 0.017453292519943295; // Math.PI / 180
  final a = 0.5 -
      cos((lat2 - lat1) * p) / 2 +
      cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lng2 - lng1) * p)) / 2;
  return 12742 * asin(sqrt(a)); // 2 * R * asin(sqrt(a))
}

@riverpod
class FavoriteSites extends _$FavoriteSites {
  @override
  Stream<List<Site>> build() {
    final repository = ref.watch(siteRepositoryProvider);

    // Watch favorite sites and transform with distance calculation
    return repository.watchFavoriteSites().asyncMap((sites) {
      final locationState = ref.read(userLocationProvider);

      // Calculate distances if location is available
      if (locationState.hasPermission) {
        for (var site in sites) {
          site.distance = _calculateDistance(
            site.latitude,
            site.longitude,
            locationState.location.lat,
            locationState.location.lng,
          );
        }

        // Sort by distance (closest first)
        sites.sort((a, b) =>
            (a.distance ?? double.infinity).compareTo(b.distance ?? double.infinity));
      }

      dev.log('Loaded ${sites.length} favorite sites');
      return sites;
    });
  }

  /// Refresh favorite sites
  Future<void> refresh() async {
    final repository = ref.read(siteRepositoryProvider);
    await repository.syncSites(forceRefresh: true);
    await repository.syncSiteStatuses(forceRefresh: true);
  }
}
