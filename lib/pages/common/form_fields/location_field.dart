import 'package:ecoco_app/constants/colors.dart';

import '/models/country_model.dart';
import '/models/district_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '/l10n/app_localizations.dart';
import '/widgets/highlighted_picker_item.dart';

class LocationFormField extends StatefulWidget {
  final List<CountryModel> countries;
  final CountryModel? selectedCountry;
  final DistrictModel? selectedDistrict;
  final ValueChanged<DistrictModel?> onChanged;
  final double fontSize;

  const LocationFormField({
    super.key,
    required this.countries,
    this.selectedCountry,
    this.selectedDistrict,
    required this.onChanged,
    this.fontSize = 16.0,
  });

  @override
  State<LocationFormField> createState() => _LocationFormFieldState();
}

class _LocationFormFieldState extends State<LocationFormField> {
  late CountryModel? _selectedCountry;
  late DistrictModel? _selectedDistrict;
  bool isEditing = false;
  late FocusNode locationFocusNode;

  @override
  void initState() {
    super.initState();
    // Respect null values from parent widget - no auto-selection
    _selectedCountry = widget.selectedCountry;
    _selectedDistrict = widget.selectedDistrict;

    locationFocusNode = FocusNode();
    locationFocusNode.addListener(() {
      setState(() {
        isEditing = locationFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    locationFocusNode.dispose();
    super.dispose();
  }

  String _getDisplayText(AppLocalizations? appLocale) {
    if (_selectedCountry != null && _selectedDistrict != null) {
      return '${_selectedCountry!.name}${_selectedDistrict!.name}';
    }
    return appLocale?.locationHint ?? '請選擇縣市與區域';
  }

  Future<void> _showLocationPicker(BuildContext context) async {
    // Find initial indices with offset for "請選擇" option
    int tempCountryIndex = 0; // Default to "請選擇"
    if (_selectedCountry != null) {
      int actualIndex = widget.countries.indexWhere(
        (c) => c.areaId == _selectedCountry?.areaId
      );
      if (actualIndex != -1) {
        tempCountryIndex = actualIndex + 1; // +1 because first item is "請選擇"
      }
    }

    int tempDistrictIndex = 0;
    if (tempCountryIndex > 0 && _selectedDistrict != null) {
      int actualCountryIndex = tempCountryIndex - 1;
      tempDistrictIndex = widget.countries[actualCountryIndex].districts.indexWhere(
        (d) => d.districtId == _selectedDistrict?.districtId
      );
      if (tempDistrictIndex == -1) tempDistrictIndex = 0;
    }

    final countryController = FixedExtentScrollController(
      initialItem: tempCountryIndex
    );
    final districtController = FixedExtentScrollController(
      initialItem: tempDistrictIndex
    );

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return MediaQuery.withNoTextScaling(
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              // Track current picker indices for highlighting
              int currentCountryPickerIndex = tempCountryIndex;
              int currentDistrictPickerIndex = tempDistrictIndex;

              // Get current country based on tempCountryIndex (handle "請選擇" case)
              final currentCountry = tempCountryIndex > 0
                  ? widget.countries[tempCountryIndex - 1]
                  : widget.countries.isNotEmpty
                      ? widget.countries[0]
                      : null;

              return Container(
                height: 300,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    // Header with Cancel/Done buttons
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Color(0xFFE5E7EB), width: 0.5),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              '取消',
                              style: TextStyle(
                                color: Color(0xFF6B7280),
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const Text(
                            '選擇地區',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF374151),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              if (tempCountryIndex == 0) {
                                // Selected "請選擇", set both to null
                                setState(() {
                                  _selectedCountry = null;
                                  _selectedDistrict = null;
                                });
                                widget.onChanged(null);
                              } else {
                                // Selected actual country
                                final country = widget.countries[tempCountryIndex - 1];
                                final district = country.districts[tempDistrictIndex];

                                setState(() {
                                  _selectedCountry = country;
                                  _selectedDistrict = district;
                                });
                                widget.onChanged(district);
                              }
                              Navigator.pop(context);
                            },
                            child: const Text(
                              '確定',
                              style: TextStyle(
                                color: Color(0xFFF97316),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Dual pickers
                    Expanded(
                      child: Row(
                        children: [
                          // Country picker
                          Expanded(
                            child: CupertinoPicker(
                              scrollController: countryController,
                              itemExtent: 40,
                              onSelectedItemChanged: (int index) {
                                setModalState(() {
                                  tempCountryIndex = index;
                                  currentCountryPickerIndex = index;
                                  tempDistrictIndex = 0;
                                  currentDistrictPickerIndex = 0;
                                  districtController.jumpToItem(0);
                                });
                              },
                              children: [
                                // First item: "請選擇"
                                HighlightedPickerItem(
                                  text: '請選擇',
                                  itemIndex: 0,
                                  selectedIndex: currentCountryPickerIndex,
                                  baseStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                                ),
                                // Rest of items: actual countries
                                ...widget.countries.asMap().entries.map((entry) {
                                  return HighlightedPickerItem(
                                    text: entry.value.name,
                                    itemIndex: entry.key + 1,
                                    selectedIndex: currentCountryPickerIndex,
                                  );
                                }),
                              ],
                            ),
                          ),
                          // District picker
                          Expanded(
                            child: CupertinoPicker(
                              scrollController: districtController,
                              itemExtent: 40,
                              onSelectedItemChanged: (int index) {
                                setModalState(() {
                                  tempDistrictIndex = index;
                                  currentDistrictPickerIndex = index;
                                });
                              },
                              children: tempCountryIndex == 0 || currentCountry == null
                                  ? [
                                      // When "請選擇" is selected, show empty/disabled state
                                      HighlightedPickerItem(
                                        text: '',
                                        itemIndex: 0,
                                        selectedIndex: currentDistrictPickerIndex,
                                        baseStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                                      ),
                                    ]
                                  : currentCountry.districts.asMap().entries.map((entry) {
                                      return HighlightedPickerItem(
                                        text: entry.value.name,
                                        itemIndex: entry.key,
                                        selectedIndex: currentDistrictPickerIndex,
                                      );
                                    }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          appLocale?.location ?? '縣市區域',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Focus(
          focusNode: locationFocusNode,
          child: InkWell(
            onTap: () {
              locationFocusNode.requestFocus();
              _showLocationPicker(context);
            },
            borderRadius: BorderRadius.circular(30),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isEditing ? Colors.blue : AppColors.inputBorderColor,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _getDisplayText(appLocale),
                      style: TextStyle(
                        fontSize: widget.fontSize,
                        color: _selectedCountry == null ? AppColors.inputBorderColor : AppColors.secondaryTextColor,
                      ),
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down, color: Colors.grey),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
} 