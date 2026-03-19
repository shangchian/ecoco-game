import '/models/district_model.dart';

class CountryModel {
  final int areaId;
  final String name;
  final List<DistrictModel> districts = [];

  CountryModel({
    required this.areaId,
    required this.name,
  });
}
