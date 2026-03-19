import '/models/country_model.dart';
import '/models/district_model.dart';
import 'package:flutter/services.dart';

class Area {
  List<CountryModel> countries = [];
  List<DistrictModel> districts = [];

  Future<void> loadFromCSV() async {
    final countryData = await rootBundle.loadString('assets/data/country.csv');
    final districtsData = await rootBundle.loadString('assets/data/district.csv');

    final countryLines = countryData.split('\n');
    final districtLines = districtsData.split('\n');

    final firstCountryLine = countryLines.removeAt(0).trim().split(',');

    final areaIdIndex = firstCountryLine.indexOf('area_id');
    final areaNameIndex = firstCountryLine.indexOf("name");
    List<CountryModel?> tmpCountries = List.filled(countryLines.length + 2, null);
    for (var line in countryLines) {
      final values = line.trim().split(',');
      final country = CountryModel(areaId: int.parse(values[areaIdIndex]), name: values[areaNameIndex]);
      tmpCountries[country.areaId] = country;
    }

    final firstDistrictLine = districtLines.removeAt(0).trim().split(',');
    final districtIdIndex = firstDistrictLine.indexOf('district_id');
    final districtAreaIdIndex = firstDistrictLine.indexOf('area_id');
    final districtNameIndex = firstDistrictLine.indexOf('name');
    List<DistrictModel?> tmpDistricts = [];
    for (var line in districtLines) {
      final values = line.trim().split(',');
      final district = DistrictModel(districtId: int.parse(values[districtIdIndex]), areaId: int.parse(values[districtAreaIdIndex]), name: values[districtNameIndex]);
      tmpCountries[district.areaId]?.districts.add(district);
      tmpDistricts.add(district);
    }
    countries = tmpCountries.nonNulls.toList();
    districts = tmpDistricts.nonNulls.toList();
  }
}
