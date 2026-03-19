import '/models/area_district_model.dart';
import '/models/country_model.dart';
import '/models/district_model.dart';
import '/models/area_model.dart';

/// Helper class to convert between new S3-based AreaDistrict models (String IDs)
/// and legacy CSV-based CountryModel/DistrictModel (int IDs)
///
/// This enables gradual migration from CSV to S3 data source
class AreaConversionHelper {
  /// Convert AreaDistrictResponse to legacy Area model
  /// Uses the "all" list by default (contains all areas/districts)
  static Area toArea(AreaDistrictResponse response, {bool useStationOnly = false}) {
    final area = Area();

    final sourceList = useStationOnly ? response.result.stationOnly : response.result.all;

    // Convert to legacy models
    for (final areaDistrict in sourceList) {
      final areaId = int.tryParse(areaDistrict.areaId) ?? 0;

      final country = CountryModel(
        areaId: areaId,
        name: areaDistrict.areaName,
      );

      // Add districts to this country
      for (final dist in areaDistrict.districtList) {
        final districtId = int.tryParse(dist.id) ?? 0;
        final district = DistrictModel(
          districtId: districtId,
          areaId: areaId,
          name: dist.name,
        );
        country.districts.add(district);
        area.districts.add(district);
      }

      area.countries.add(country);
    }

    return area;
  }

  /// Convert a single AreaDistrict to CountryModel
  static CountryModel toCountryModel(AreaDistrict areaDistrict) {
    final areaId = int.tryParse(areaDistrict.areaId) ?? 0;
    final country = CountryModel(
      areaId: areaId,
      name: areaDistrict.areaName,
    );

    for (final dist in areaDistrict.districtList) {
      final districtId = int.tryParse(dist.id) ?? 0;
      final district = DistrictModel(
        districtId: districtId,
        areaId: areaId,
        name: dist.name,
      );
      country.districts.add(district);
    }

    return country;
  }

  /// Convert a single District to DistrictModel
  static DistrictModel toDistrictModel(District district, String areaId) {
    return DistrictModel(
      districtId: int.tryParse(district.id) ?? 0,
      areaId: int.tryParse(areaId) ?? 0,
      name: district.name,
    );
  }

  /// Parse String ID to int (for backward compatibility)
  static int parseAreaId(String id) {
    return int.tryParse(id) ?? 0;
  }

  /// Parse String ID to int (for backward compatibility)
  static int parseDistrictId(String id) {
    return int.tryParse(id) ?? 0;
  }

  /// Check if a district is in "stationOnly" list
  static bool isStationOnly(AreaDistrictResponse response, String areaId, String districtId) {
    for (final area in response.result.stationOnly) {
      if (area.areaId == areaId) {
        for (final district in area.districtList) {
          if (district.id == districtId) {
            return true;
          }
        }
      }
    }
    return false;
  }

  /// Get all districts from "stationOnly" list for filtering
  static List<DistrictModel> getStationOnlyDistricts(AreaDistrictResponse response) {
    final List<DistrictModel> districts = [];

    for (final area in response.result.stationOnly) {
      final areaId = int.tryParse(area.areaId) ?? 0;
      for (final dist in area.districtList) {
        final districtId = int.tryParse(dist.id) ?? 0;
        districts.add(DistrictModel(
          districtId: districtId,
          areaId: areaId,
          name: dist.name,
        ));
      }
    }

    return districts;
  }
}
