import 'package:riverpod_annotation/riverpod_annotation.dart';
import '/models/area_model.dart';
import '/repositories/area_district_repository.dart';
import '/utils/area_conversion_helper.dart';

part 'area_district_provider.g.dart';

/// Provider for area/district data loaded from S3 cache
/// Returns data in legacy Area model format for backward compatibility
@Riverpod(keepAlive: true)
class AreaDistrictNotifier extends _$AreaDistrictNotifier {
  @override
  Area build() {
    return Area(); // Return empty initially
  }

  /// Load area/district data from S3 cache and convert to legacy format
  Future<void> loadAreaDistrict({bool forceRefresh = false}) async {
    try {
      final repository = AreaDistrictRepository();
      final response = await repository.getAreaDistrict(forceRefresh: forceRefresh);

      // Convert to legacy Area model (uses "all" list)
      final area = AreaConversionHelper.toArea(response, useStationOnly: true);

      state = area;
    } catch (e) {
      // On error, keep existing state (empty Area if first load)
      // Errors are already logged in repository
    }
  }

  /// Clear cache and reload
  Future<void> clearAndReload() async {
    final repository = AreaDistrictRepository();
    await repository.clearAreaDistrictCache();
    await loadAreaDistrict(forceRefresh: true);
  }
}
