import 'package:riverpod_annotation/riverpod_annotation.dart';
import '/models/site_model.dart';

part 'site_filter_provider.g.dart';

class SiteFilter {
  final String searchQuery;
  final int? areaId;
  final int? districtId;
  final List<SiteType> selectedTypes;
  final List<RecyclableItemType> selectedRecyclableItems;
  final bool showFavoriteOnly;
  final bool showOpenOnly;

  SiteFilter({
    this.searchQuery = '',
    this.areaId,
    this.districtId,
    this.selectedTypes = const [],
    this.selectedRecyclableItems = const [],
    this.showFavoriteOnly = false,
    this.showOpenOnly = false,
  });

  SiteFilter copyWith({
    String? searchQuery,
    int? areaId,
    int? districtId,
    List<SiteType>? selectedTypes,
    List<RecyclableItemType>? selectedRecyclableItems,
    bool? showFavoriteOnly,
    bool? showOpenOnly,
  }) {
    return SiteFilter(
      searchQuery: searchQuery ?? this.searchQuery,
      areaId: areaId ?? this.areaId,
      districtId: districtId ?? this.districtId,
      selectedTypes: selectedTypes ?? this.selectedTypes,
      selectedRecyclableItems: selectedRecyclableItems ?? this.selectedRecyclableItems,
      showFavoriteOnly: showFavoriteOnly ?? this.showFavoriteOnly,
      showOpenOnly: showOpenOnly ?? this.showOpenOnly,
    );
  }

  bool get hasLocationFilter => areaId != null || districtId != null;
  bool get hasTypeFilter => selectedTypes.isNotEmpty;
  bool get hasRecyclableItemFilter => selectedRecyclableItems.isNotEmpty;
}

@riverpod
class SiteFilterNotifier extends _$SiteFilterNotifier {
  @override
  SiteFilter build() {
    return SiteFilter();
  }

  void updateFilter(SiteFilter filter) {
    state = filter;
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setAreaId(int? areaId) {
    state = SiteFilter(
      searchQuery: state.searchQuery,
      areaId: areaId,
      districtId: areaId == null ? null : state.districtId,
      selectedTypes: state.selectedTypes,
      selectedRecyclableItems: state.selectedRecyclableItems,
      showFavoriteOnly: state.showFavoriteOnly,
      showOpenOnly: state.showOpenOnly,
    );
  }

  void setDistrictId(int? districtId) {
    state = SiteFilter(
      searchQuery: state.searchQuery,
      areaId: state.areaId,
      districtId: districtId,
      selectedTypes: state.selectedTypes,
      selectedRecyclableItems: state.selectedRecyclableItems,
      showFavoriteOnly: state.showFavoriteOnly,
      showOpenOnly: state.showOpenOnly,
    );
  }

  void setSelectedTypes(List<SiteType> types) {
    state = state.copyWith(selectedTypes: types);
  }

  void setSelectedRecyclableItems(List<RecyclableItemType> items) {
    state = state.copyWith(selectedRecyclableItems: items);
  }

  void setFavoriteOnly(bool value) {
    state = state.copyWith(showFavoriteOnly: value);
  }

  void setOpenOnly(bool value) {
    state = state.copyWith(showOpenOnly: value);
  }

  void reset() {
    state = SiteFilter();
  }
}
