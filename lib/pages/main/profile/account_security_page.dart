import 'package:auto_route/auto_route.dart';
import '/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/l10n/app_localizations.dart';
import '/constants/colors.dart';
import '/utils/router_analytics_extension.dart';

@RoutePage()
class AccountSecurityPage extends ConsumerStatefulWidget {
  const AccountSecurityPage({super.key});

  @override
  ConsumerState<AccountSecurityPage> createState() =>
      _AccountSecurityPageState();
}

class _AccountSecurityPageState extends ConsumerState<AccountSecurityPage> {
  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.secondaryHighlightColor,
        surfaceTintColor: Colors.transparent,
        title: Text(
          appLocale?.accountSecurity ?? "帳號與安全",
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  ListTile(
                    title: Text(appLocale?.passwordEdit ?? "修改密碼"),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: AppColors.indicatorColor,
                    ),
                    onTap: () {
                      context.router.pushThrottledWithTracking(const ChangePasswordRoute());
                    },
                  ),
                  ListTile(
                    title: Text(appLocale?.phoneVerificationStatus ?? "手機驗證狀態"),
                    trailing: Text(
                      appLocale?.verified ?? "已驗證",
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ),
                  // ListTile(
                  //   title: Text(appLocale?.lineBindingStatus ?? "Line綁定狀態"),
                  //   trailing: Row(
                  //     mainAxisSize: MainAxisSize.min,
                  //     children: [
                  //       Text(
                  //         appLocale?.goToBind ?? "前往綁定",
                  //         style: TextStyle(
                  //           color: AppColors.loginTextbutton,
                  //           fontSize: 14,
                  //         ),
                  //       ),
                  //       const Icon(Icons.chevron_right, color: AppColors.indicatorColor),
                  //     ],
                  //   ),
                  //   onTap: () {
                  //     // TODO: Implement LINE binding functionality
                  //   },
                  // ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                      child: TextButton(
                        onPressed: () {
                          context.router.pushThrottledWithTracking(DeleteAccountRoute());
                        },
                        child: Text(
                          appLocale?.requestDeleteAccount ?? "申請刪除帳號",
                          style: TextStyle(
                            color: AppColors.formFieldErrorBorder,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.formFieldErrorBorder,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
