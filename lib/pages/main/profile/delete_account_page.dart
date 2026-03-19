import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/constants/colors.dart';
import '/l10n/app_localizations.dart';
import '/pages/common/alerts/delete_account_confirm_alert.dart';
import '/pages/common/alerts/simple_error_alert.dart';
import '/pages/common/form_fields/password_builder_field.dart';
import '/pages/common/loading_overlay.dart';
import '/pages/main/profile/delete_account/expandable_reason_option.dart';
import '/providers/auth_provider.dart';
import '/providers/member_delete_reasons_provider.dart';
import '/router/app_router.dart';
import '/utils/router_analytics_extension.dart';

@RoutePage()
class DeleteAccountPage extends ConsumerStatefulWidget {
  const DeleteAccountPage({super.key});

  @override
  ConsumerState<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends ConsumerState<DeleteAccountPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _feedbackController = TextEditingController();

  String? _selectedReasonKindId; // Changed from _selectedMainReason
  final Map<String, Set<String>> _selectedSubReasonsByKindId =
      {}; // Changed from _selectedSubReasons
  final Set<String> _expandedReasons = {};
  bool _isConsentChecked = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Load delete reasons on page init
    Future.microtask(() {
      ref.read(memberDeleteReasonsProvider.notifier).fetchReasons();
    });
  }

  bool get _isFormValid {
    // Check if main reason is selected (sub-reason is optional)
    final hasMainReasonSelected = _selectedReasonKindId != null;

    return _passwordController.text.isNotEmpty &&
        hasMainReasonSelected &&
        _isConsentChecked;
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  void _showDeleteConfirmDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return DeleteAccountConfirmAlert(
          onConfirm: () {
            _handleDeleteAccount();
          },
          onCancel: () {
            // Dialog already closed by the alert itself
          },
        );
      },
    );
  }

  Future<void> _handleDeleteAccount() async {
    final appLocale = AppLocalizations.of(context);

    // Validate password
    if (_passwordController.text.isEmpty) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => SimpleErrorAlert(
          message: appLocale?.deleteAccountPasswordError ?? '請輸入密碼',
          buttonText: appLocale?.okay ?? '確定',
          onPressed: () {},
        ),
      );
      return;
    }

    // Validate reason selection (only main reason is required)
    if (_selectedReasonKindId == null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => SimpleErrorAlert(
          message: appLocale?.deleteAccountReasonRequired ?? '請選擇刪除原因',
          buttonText: appLocale?.okay ?? '確定',
          onPressed: () {},
        ),
      );
      return;
    }

    // Validate consent
    if (!_isConsentChecked) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => SimpleErrorAlert(
          message: appLocale?.deleteAccountConsentRequired ?? '請確認您同意刪除帳號',
          buttonText: appLocale?.okay ?? '確定',
          onPressed: () {},
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Collect selected sub-reason IDs
      final List<String> subReasonIdList = [];
      _selectedSubReasonsByKindId.forEach((kindId, subReasonIds) {
        if (subReasonIds.isNotEmpty) {
          subReasonIdList.addAll(subReasonIds);
        }
      });

      final isSuccess = await ref
          .read(authProvider.notifier)
          .deleteAccount(
            password: _passwordController.text,
            agreeToTerms: _isConsentChecked,
            reasonId: _selectedReasonKindId,
            subReasonId: subReasonIdList.isNotEmpty ? subReasonIdList : null,
            feedback: _feedbackController.text.isNotEmpty
                ? _feedbackController.text
                : null,
          );

      if (isSuccess && mounted) {
        // Navigate to login and clear all previous routes
        context.router.pushAndPopUntilWithTracking(
          LoginRoute(isLogout: true),
          predicate: (route) => false,
        );
      } else if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => SimpleErrorAlert(
            message: appLocale?.deleteAccountPasswordError ?? '密碼錯誤',
            buttonText: appLocale?.okay ?? '確定',
            onPressed: () {},
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => SimpleErrorAlert(
            message: appLocale?.deleteAccountPasswordError ?? '密碼錯誤',
            buttonText: appLocale?.okay ?? '確定',
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

  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context);
    final deleteReasonsData = ref.watch(memberDeleteReasonsProvider);
    final reasons = deleteReasonsData?.result ?? [];

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      behavior: HitTestBehavior.translucent,
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: AppColors.greyBackground,
            appBar: AppBar(
              toolbarHeight: 56,
              backgroundColor: AppColors.secondaryHighlightColor,
              surfaceTintColor: Colors.transparent,
              title: Text(
                appLocale?.deleteAccountPageTitle ?? "刪除ECOCO帳號",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => context.router.maybePop(),
              ),
              elevation: 0,
              centerTitle: true,
            ),
            body: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Warning message
                    Container(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              textAlign: TextAlign.center,
                              appLocale?.deleteAccountWarning ?? "警告",
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Password verification section
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: PasswordBuilderFormField(
                        controller: _passwordController,
                        onChanged: (value) {
                          setState(() {});
                        },
                        mode: PasswordFieldMode.simple,
                        labelText:
                            appLocale?.deleteAccountPasswordTitle ?? "請輸入密碼以驗證身份",
                        labelTextStar: true,
                        hintText:
                            appLocale?.deleteAccountPasswordHint ?? "請輸入密碼",
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Reason selection section
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        appLocale?.deleteAccountReasonTitle ??
                                            "為什麼想要刪除帳號",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        '*',
                                        style: TextStyle(
                                          color: Colors.red.shade700,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ]
                      )
                    ),
                    SizedBox(height: 2,),
                    Container(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        children: [
                          // Reason options
                          ...reasons.map((reasonKind) {
                            final kindId = reasonKind.kindId;
                            final kindName = reasonKind.kindName;
                            final subReasonsList = reasonKind.reasons
                                .map((r) => r.name)
                                .toList();
                            final isMainReasonSelected =
                                _selectedReasonKindId == kindId;
                            final isExpanded = _expandedReasons.contains(
                              kindId,
                            );

                            // Convert stored IDs to names for widget display
                            final selectedSubReasonIds =
                                _selectedSubReasonsByKindId[kindId] ?? {};
                            final selectedSubReasonNames = reasonKind.reasons
                                .where(
                                  (r) => selectedSubReasonIds.contains(r.id),
                                )
                                .map((r) => r.name)
                                .toSet();

                            return Column(
                              children: [
                                ExpandableReasonOption(
                                  mainReason: kindName,
                                  subReasons: subReasonsList,
                                  isMainReasonSelected: isMainReasonSelected,
                                  isExpanded: isExpanded,
                                  selectedSubReasons: selectedSubReasonNames,
                                  onMainReasonTap: () {
                                    setState(() {
                                      if (_selectedReasonKindId == kindId) {
                                        // Deselect current main reason
                                        _selectedReasonKindId = null;
                                        _selectedSubReasonsByKindId.clear();
                                        _expandedReasons.remove(kindId);
                                      } else {
                                        // Select new main reason, clear previous selections
                                        _selectedReasonKindId = kindId;
                                        _selectedSubReasonsByKindId.clear();
                                        _selectedSubReasonsByKindId[kindId] =
                                            {};
                                        _expandedReasons.clear();
                                        _expandedReasons.add(kindId);
                                      }
                                    });
                                  },
                                  onExpandTap: () {
                                    setState(() {
                                      if (_expandedReasons.contains(kindId)) {
                                        _expandedReasons.remove(kindId);
                                      } else {
                                        _expandedReasons.add(kindId);
                                      }
                                    });
                                  },
                                  onSubReasonTap: (subReasonName) {
                                    setState(() {
                                      // Find the subReason ID by name
                                      final subReason = reasonKind.reasons
                                          .firstWhere(
                                            (r) => r.name == subReasonName,
                                          );
                                      final subReasonId = subReason.id;

                                      if (_selectedReasonKindId != kindId) {
                                        // Auto-select main reason if not selected
                                        _selectedReasonKindId = kindId;
                                        _selectedSubReasonsByKindId.clear();
                                        _selectedSubReasonsByKindId[kindId] =
                                            {};
                                      }

                                      if (!_selectedSubReasonsByKindId
                                          .containsKey(kindId)) {
                                        _selectedSubReasonsByKindId[kindId] =
                                            {};
                                      }

                                      if (_selectedSubReasonsByKindId[kindId]!
                                          .contains(subReasonId)) {
                                        _selectedSubReasonsByKindId[kindId]!
                                            .remove(subReasonId);
                                      } else {
                                        _selectedSubReasonsByKindId[kindId]!
                                            .add(subReasonId);
                                      }
                                    });
                                  },
                                ),
                                Divider(color: Colors.grey.shade200, height: 1),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Feedback section
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appLocale?.deleteAccountFeedbackTitle ??
                                "最後有什麼想建議ECOCO團隊嗎?",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                bottom: BorderSide(color: Colors.black),
                              ),
                            ),
                            child: TextField(
                              controller: _feedbackController,
                              cursorColor: AppColors.textCursorColor,
                              maxLines: 1,
                              decoration: InputDecoration(
                                hintText:
                                    appLocale?.deleteAccountFeedbackHint ??
                                    "請輸入建議",
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.all(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Consent checkbox
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() => _isConsentChecked = !_isConsentChecked);
                          },
                          child: Container(
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _isConsentChecked
                                    ? AppColors.orangeBackground
                                    : Colors.grey,
                                width: 2,
                              ),
                              color: _isConsentChecked
                                  ? AppColors.orangeBackground
                                  : Colors.white,
                            ),
                            child: _isConsentChecked
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 16,
                                  )
                                : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            appLocale?.deleteAccountConsentText ??
                                "我同意並了解我的所有帳號資料都將永久刪除",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: (_isLoading || !_isFormValid)
                            ? null
                            : _showDeleteConfirmDialog,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isFormValid
                              ? AppColors.primaryHighlightColor
                              : AppColors.loginButtonGray,
                          disabledBackgroundColor: AppColors.loginButtonGray,
                          side: BorderSide(
                            color: _isFormValid
                                ? AppColors.primaryHighlightColor
                                : AppColors.loginButtonGray,
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          appLocale?.deleteAccountButton ?? "刪除帳號",
                          style: TextStyle(
                            color: _isFormValid
                                ? AppColors.primaryDisabledColor
                                : Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: _isLoading
                            ? null
                            : () => context.router.maybePop(),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          appLocale?.deleteAccountCancelButton ?? "取消",
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading) const LoadingOverlay(),
        ],
      ),
    );
  }
}
