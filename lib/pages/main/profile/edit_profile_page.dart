import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/l10n/app_localizations.dart';
import '/models/area_model.dart';
import '/models/profile_data_model.dart';
import '/models/country_model.dart';
import '/models/district_model.dart';
import '/providers/area_district_provider.dart';
import '/providers/profile_provider.dart';
import '/providers/auth_provider.dart';
import '/pages/common/alerts/simple_error_alert.dart';
import '/pages/common/form_fields/nickname_field.dart';
import '/pages/common/form_fields/email_field.dart';
import '/pages/common/form_fields/birthday_field.dart';
import '/pages/common/form_fields/gender_field.dart';
import '/pages/common/form_fields/location_field.dart';
import '/pages/common/loading_overlay.dart';
import '/constants/colors.dart';

@RoutePage()
class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nicknameController = TextEditingController();
  final _emailController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedGender;
  CountryModel? _selectedCountry;
  DistrictModel? _selectedDistrict;
  bool _isLoading = false;
  bool _isInitialized = false;
  bool _isNicknameValid = true;
  bool _isEmailValid = true;

  bool get _isFormValid =>
      _isNicknameValid &&
      _isEmailValid &&
      _nicknameController.text.isNotEmpty &&
      _selectedDate != null;

  void _initializeFormData(Area area, ProfileData? user) {
    // Only initialize once
    if (_isInitialized) return;

    // Wait for area data to load before initializing
    if (area.countries.isEmpty || area.districts.isEmpty) {
      return; // Data not loaded yet, skip initialization
    }

    // Initialize controllers with existing user data
    _nicknameController.text = user?.nickname ?? '';
    _emailController.text = user?.email ?? '';
    final gender = user?.gender?.toLowerCase();
    _selectedGender =
        (gender == 'male' || gender == 'female' || gender == 'other')
        ? gender
        : null;
    _selectedDate =
        user != null &&
            user.birthday != null &&
            user.birthday != '0000-00-00' &&
            user.birthday!.isNotEmpty
        ? DateTime.parse(user.birthday!)
        : null;

    // Initialize location
    _selectedDistrict = area.districts.firstWhere(
      (district) => user?.districtId != null
          ? district.districtId.toString() == user!.districtId
          : false,
      orElse: () => area.districts.first,
    );
    _selectedCountry = area.countries.firstWhere(
      (d) => d.areaId == _selectedDistrict?.areaId,
      orElse: () => area.countries.first,
    );

    _isInitialized = true;
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    final appLocale = AppLocalizations.of(context);
    final authData = ref.read(authProvider);

    if (authData == null) {
      if (mounted) {
        await showDialog(
          context: context,
          builder: (_) => SimpleErrorAlert(
            message: "User not logged in",
            buttonText: appLocale?.okay ?? "",
            onPressed: () {},
          ),
        );
      }
      return;
    }

    // Manual validation check since validators always return null
    if (!_isNicknameValid) {
      return;
    }
    if (!_isEmailValid) {
      return;
    }

    // All fields valid, proceed with submission
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      try {
        final profileNotifier = ref.read(profileProvider.notifier);
        await profileNotifier.updateProfile(
          authData: authData,
          nickname: _nicknameController.text,
          email: _emailController.text.isEmpty ? null : _emailController.text,
          gender: _selectedGender,
          birthday: _selectedDate?.toIso8601String().split("T")[0],
          districtId: _selectedDistrict?.districtId.toString(),
          areaId: _selectedDistrict?.areaId.toString(),
        );

        if (mounted) {
          context.router.maybePop();
        }
      } catch (e) {
        if (mounted) {
          await showDialog(
            context: context,
            builder: (_) => SimpleErrorAlert(
              message: e.toString(),
              buttonText: appLocale?.okay ?? "",
              onPressed: () {},
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final area = ref.watch(areaDistrictProvider);
    final user = ref.watch(profileProvider); // Watch for profile data changes
    final appLocale = AppLocalizations.of(context);
    final double textScaleFactor = MediaQuery.of(context).textScaler.scale(1);
    final double inputFontSize = (MediaQuery.of(context).size.width < 360 ? 13 : 16) / textScaleFactor;

    // Load area/district data if empty
    if (area.countries.isEmpty) {
      ref.read(areaDistrictProvider.notifier).loadAreaDistrict();
    }

    // Initialize form data when user data is available
    _initializeFormData(area, user);

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: AppColors.secondaryHighlightColor,
            surfaceTintColor: Colors.transparent,
            title: Text(
              appLocale?.editProfile ?? "",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Color(0xFF333333),
              ),
            ),
            centerTitle: true,
            elevation: 0,
            toolbarHeight: 56,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => context.router.pop(),
            ),
          ),
          body: GestureDetector(
            onTap: () {
              // 移除所有焦點，關閉鍵盤
              FocusScope.of(context).unfocus();
            },
            behavior: HitTestBehavior.opaque,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(35,16,35,16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/images/ecoco_avatar.png',
                          width: 76,
                          height: 76,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "會員帳號",
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        user?.phone ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.secondaryValueColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      NicknameFormField(
                        controller: _nicknameController,
                        fontSize: inputFontSize,
                        onChanged: (_) {},
                        onValidationChanged: (isValid) {
                          setState(() => _isNicknameValid = isValid);
                        },
                      ),
                      const SizedBox(height: 16),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: appLocale?.email ?? "Email",
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const TextSpan(
                              text: ' ',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      EmailFormField(
                        controller: _emailController,
                        fontSize: inputFontSize,
                        onChanged: (_) {},
                        onValidationChanged: (isValid) {
                          setState(() => _isEmailValid = isValid);
                        },
                      ),
                      const SizedBox(height: 16),
                      LocationFormField(
                        countries: area.countries,
                        selectedCountry: _selectedCountry,
                        selectedDistrict: _selectedDistrict,
                        fontSize: inputFontSize,
                        onChanged: (district) {
                          setState(() => _selectedDistrict = district);
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: GenderFormField(
                              selectedGender: _selectedGender,
                              isEditable: user?.isGenderEditable ?? true,
                              fontSize: inputFontSize,
                              onChanged: (value) {
                                if (user?.isGenderEditable ?? true) {
                                  setState(() {
                                    _selectedGender = value;
                                  });
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: BirthdayFormField(
                              selectedDate: _selectedDate,
                              isEditable: user?.isBirthdayEditable ?? true,
                              fontSize: inputFontSize,
                              onChanged: (date) {
                                if (user?.isBirthdayEditable ?? true) {
                                  setState(() {
                                    _selectedDate = date;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 18,
                              color: AppColors.secondaryValueColor,
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                appLocale?.genderBirthdayEditableHint ??
                                    '性別、生日可編輯一次，儲存後無法變更',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.secondaryValueColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: (_isLoading || !_isFormValid) ? null : _handleSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryHighlightColor,
                          disabledBackgroundColor: AppColors.disabledButtomBackground,
                          foregroundColor: Colors.white,
                          disabledForegroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          "儲存變更",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.router.maybePop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.disabledButtomBackground,
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: BorderSide(
                              color: AppColors.disabledButtomBackground,
                              width: 2,
                            ),
                          ),
                        ),
                        child: const Text("取消", style: TextStyle(fontSize: 16)),
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        if (_isLoading) const LoadingOverlay(),
      ],
    );
  }
}
