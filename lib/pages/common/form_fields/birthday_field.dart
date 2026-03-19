import 'package:ecoco_app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class BirthdayFormField extends StatefulWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onChanged;
  final bool isEditable;
  final double fontSize;

  const BirthdayFormField({
    super.key,
    this.selectedDate,
    required this.onChanged,
    this.isEditable = true,
    this.fontSize = 16.0,
  });

  @override
  State<BirthdayFormField> createState() => _BirthdayFormFieldState();
}

class _BirthdayFormFieldState extends State<BirthdayFormField> {
  bool isEditing = false;
  final FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
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

  Future<void> _selectDate(BuildContext context) async {
    DateTime? tempPickedDate;
    bool hasChanged = false;

    await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
          child: Container(
            height: 300,
            color: CupertinoColors.systemBackground.resolveFrom(context),
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
                        child: const Text(
                          '取消',
                          style: TextStyle(
                            height: 1.4,
                            color: AppColors.secondaryValueColor
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      CupertinoButton(
                        child: const Text(
                          '完成',
                          style: TextStyle(
                            height: 1.4,
                            color: AppColors.primaryHighlightColor
                          ),
                        ),
                        onPressed: () {
                          if (hasChanged && tempPickedDate != null) {
                            widget.onChanged(tempPickedDate!);
                          }
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: widget.selectedDate ?? DateTime(1990, 1, 1),
                    minimumDate: DateTime(1900),
                    maximumDate: DateTime.now(),
                    onDateTimeChanged: (DateTime newDate) {
                      hasChanged = true;
                      tempPickedDate = newDate;
                    },
                  ),
                ),
              ],
            ),
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
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: appLocale?.birthday ?? '生日',
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const TextSpan(
                text: ' *',
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
        if (widget.isEditable)
          Focus(
            focusNode: myFocusNode,
            child: InkWell(
              onTap: () {
                myFocusNode.requestFocus();
                _selectDate(context);
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
                    child: Center(child: Text(
                      widget.selectedDate == null
                          ? appLocale?.birthdayHint ?? ''
                          : DateFormat('yyyy-MM-dd').format(widget.selectedDate!),
                      style: TextStyle(
                        fontSize: widget.fontSize,
                        color: widget.selectedDate == null ? AppColors.inputBorderColor : AppColors.secondaryTextColor,
                      ),
                    ),
                  )),
                  const Icon(Icons.arrow_drop_down, color: Colors.grey),
                ],
              ),
            ),
            ),
          )
        else
          SizedBox(
            height: 40,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.selectedDate == null ||
                    (widget.selectedDate!.year == 1 &&
                     widget.selectedDate!.month == 1 &&
                     widget.selectedDate!.day == 1)
                        ? appLocale?.birthdayHint ?? '請選擇'
                        : DateFormat('yyyy-MM-dd').format(widget.selectedDate!),
                    style: TextStyle(
                      fontSize: widget.fontSize,
                      color: AppColors.secondaryTextColor
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
