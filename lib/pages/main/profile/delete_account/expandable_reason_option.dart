import 'package:flutter/material.dart';
import 'package:ecoco_app/constants/colors.dart';

class ExpandableReasonOption extends StatefulWidget {
  final String mainReason;
  final List<String> subReasons;
  final bool isMainReasonSelected;
  final bool isExpanded;
  final Set<String> selectedSubReasons;
  final VoidCallback onMainReasonTap;
  final VoidCallback onExpandTap;
  final Function(String) onSubReasonTap;

  const ExpandableReasonOption({
    super.key,
    required this.mainReason,
    required this.subReasons,
    required this.isMainReasonSelected,
    required this.isExpanded,
    required this.selectedSubReasons,
    required this.onMainReasonTap,
    required this.onExpandTap,
    required this.onSubReasonTap,
  });

  @override
  State<ExpandableReasonOption> createState() => _ExpandableReasonOptionState();
}

class _ExpandableReasonOptionState extends State<ExpandableReasonOption> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Main reason row
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            children: [
              // Checkbox button
              InkWell(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  widget.onMainReasonTap();
                },
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: widget.isMainReasonSelected
                          ? AppColors.orangeBackground
                          : Colors.grey,
                      width: 2,
                    ),
                    color: widget.isMainReasonSelected
                        ? AppColors.orangeBackground
                        : Colors.white,
                  ),
                  child: widget.isMainReasonSelected
                      ? const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16,
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              // Main reason text
              Expanded(
                child: Text(
                  widget.mainReason,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
              // Expand/collapse icon
              InkWell(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  widget.onExpandTap();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    widget.isExpanded
                        ? Icons.remove
                        : Icons.add,
                    color: Colors.grey,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Sub-reasons (only shown when expanded)
        if (widget.isExpanded) ...[
          Padding(
            padding: const EdgeInsets.only(left: 32.0),
            child: Column(
              children: widget.subReasons.map((subReason) {
                final isSubSelected = widget.selectedSubReasons.contains(subReason);
                return InkWell(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    widget.onSubReasonTap(subReason);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Row(
                      children: [
                        // Checkbox for sub-reason
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSubSelected
                                  ? AppColors.orangeBackground
                                  : Colors.grey,
                              width: 2,
                            ),
                            color: isSubSelected
                                ? AppColors.orangeBackground
                                : Colors.white,
                          ),
                          child: isSubSelected
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 16,
                                )
                              : null,
                        ),
                        const SizedBox(width: 12),
                        // Sub-reason text
                        Expanded(
                          child: Text(
                            subReason,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }
}
