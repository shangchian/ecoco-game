import 'package:ecoco_app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '/l10n/app_localizations.dart';
import '/widgets/highlighted_picker_item.dart';

class GenderFormField extends StatefulWidget {
  final String? selectedGender;
  final ValueChanged<String?> onChanged;
  final bool isEditable;
  final double fontSize;

  const GenderFormField({
    super.key,
    this.selectedGender,
    required this.onChanged,
    this.isEditable = true,
    this.fontSize = 16.0,
  });

  @override
  State<GenderFormField> createState() => _GenderFormFieldState();
}

class _GenderFormFieldState extends State<GenderFormField> {
  bool isEditing = false;
  late FocusNode myFocusNode;

  static const List<String?> _genderOptions = [null, 'male', 'female', 'other'];

  int _getGenderIndex(String? gender) {
    final index = _genderOptions.indexOf(gender);
    return index >= 0 ? index : 0;
  }

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
    myFocusNode.addListener(() {
      setState(() {
        isEditing = myFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  Future<void> _selectGender(BuildContext context) async {
    final appLocale = AppLocalizations.of(context);
    String? tempSelectedGender = widget.selectedGender;

    final scrollController = FixedExtentScrollController(
      initialItem: _getGenderIndex(widget.selectedGender),
    );

    await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              int currentPickerIndex = _getGenderIndex(tempSelectedGender);

              return Container(
                height: 300,
                decoration: BoxDecoration(
                  color: CupertinoColors.systemBackground.resolveFrom(context),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemBackground.resolveFrom(context),
                        border: Border(
                          bottom: BorderSide(
                            color: CupertinoColors.separator.resolveFrom(context),
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CupertinoButton(
                            child: const Text('取消', style: TextStyle(height: 1.4, color: AppColors.secondaryValueColor)),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          CupertinoButton(
                            child: const Text('完成', style: TextStyle(height: 1.4, color: AppColors.primaryHighlightColor)),
                            onPressed: () {
                              widget.onChanged(tempSelectedGender);
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: CupertinoPicker(
                        itemExtent: 40,
                        scrollController: scrollController,
                        onSelectedItemChanged: (int index) {
                          tempSelectedGender = _genderOptions[index];
                          setModalState(() {
                            currentPickerIndex = index;
                          });
                        },
                        children: [
                          HighlightedPickerItem(
                            text: appLocale?.genderNotSelected ?? '請選擇',
                            itemIndex: 0,
                            selectedIndex: currentPickerIndex,
                          ),
                          HighlightedPickerItem(
                            text: appLocale?.male ?? '男',
                            itemIndex: 1,
                            selectedIndex: currentPickerIndex,
                          ),
                          HighlightedPickerItem(
                            text: appLocale?.female ?? '女',
                            itemIndex: 2,
                            selectedIndex: currentPickerIndex,
                          ),
                          HighlightedPickerItem(
                            text: appLocale?.unknown ?? '其他',
                            itemIndex: 3,
                            selectedIndex: currentPickerIndex,
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
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(appLocale?.gender ?? '性別',
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.black)),
        const SizedBox(height: 8),
        if (widget.isEditable)
          Focus(
            focusNode: myFocusNode,
            child: InkWell(
              onTap: () {
                myFocusNode.requestFocus();
                _selectGender(context);
              },
              borderRadius: BorderRadius.circular(30),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: isEditing ? Colors.blue : AppColors.inputBorderColor,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          _getGenderDisplayText(widget.selectedGender, appLocale),
                          style: TextStyle(
                            fontSize: widget.fontSize,
                            color: widget.selectedGender == null ? AppColors.inputBorderColor : AppColors.secondaryTextColor,
                          ),
                        ),
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down, color: Colors.grey),
                  ],
                ),
              ),
            ),
          )
        else
          Container(height: 40,
          alignment: AlignmentGeometry.centerLeft,
          child: 
          Text(
            _getGenderDisplayText(widget.selectedGender, appLocale),
            style: TextStyle(
              fontSize: widget.fontSize,
              color: AppColors.secondaryTextColor,
            ),
          ),),
      ],
    );
  }

  String _getGenderDisplayText(String? gender, AppLocalizations? appLocale) {
    switch (gender) {
      case null:
        return appLocale?.genderNotSelected ?? '請選擇';
      case 'male':
        return appLocale?.male ?? '男';
      case 'female':
        return appLocale?.female ?? '女';
      case 'other':
        return appLocale?.unknown ?? '其他';
      default:
        return appLocale?.genderNotSelected ?? '請選擇';
    }
  }
}
