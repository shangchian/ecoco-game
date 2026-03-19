import 'package:auto_route/auto_route.dart';
import 'package:ecoco_app/constants/colors.dart';
import '/pages/common/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/l10n/app_localizations.dart';
import '/providers/forget_password_provider.dart';
import 'widgets/input_phone_step.dart';
import 'widgets/verify_phone_step.dart';
import 'widgets/reset_password_step.dart';
import '/pages/common/auth_page_layout.dart';
import '/pages/common/auth_step_tabs.dart';

@RoutePage()
class ForgetPasswordPage extends ConsumerStatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  ConsumerState<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends ConsumerState<ForgetPasswordPage> {
  final _pageController = PageController();
  int _currentPage = 0;
  bool _isLoading = false;

  void _goToNextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(forgetPasswordControllerProvider.notifier).reset();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context);

    final steps = [
      appLocale?.inputPhoneStepTitle ?? "",
      appLocale?.verifyPhoneStepTitle ?? "",
      appLocale?.resetPasswordStepTitle ?? "",
    ];

    return Stack(
      children: [
        // Full screen yellow background (static)
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/yellow_bg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent, // Changed to transparent
          resizeToAvoidBottomInset: false, // Keep scaffold size fixed, let SingleChildScrollView handle keyboard
          body: AuthPageLayout(
            topPadding: 160,
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: Column(
                children: [
                  AppBar(
                    backgroundColor: Colors.transparent,
                    surfaceTintColor: Colors.transparent,
                    elevation: 0,
                    toolbarHeight: kToolbarHeight,
                    automaticallyImplyLeading: false,
                    title: Text(
                      appLocale?.forgetPasswordTitle ?? "",
                      style: const TextStyle(
                        color: AppColors.primaryHighlightColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    centerTitle: true,
                    leading: _currentPage == 0
                        ? IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.grey),
                            color: AppColors.loginButtonGray,
                            iconSize: 38.0,
                            onPressed: () => context.router.maybePop(),
                          )
                        : null,
                    actions: _currentPage > 0
                        ? [
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.grey),
                              color: AppColors.loginButtonGray,
                              iconSize: 38.0,
                              onPressed: () => context.router.maybePop(),
                            )
                          ]
                        : [],
                  ),
                  AuthStepTabs(
                    steps: steps,
                    currentStep: _currentPage,
                  ),
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      onPageChanged: (index) =>
                          setState(() => _currentPage = index),
                      children: [
                        InputPhoneStep(
                          onNext: _goToNextPage,
                          onLoadingChanged: setLoading,
                        ),
                        VerifyPhoneStep(
                          onNext: _goToNextPage,
                          onLoadingChanged: setLoading,
                        ),
                        ResetPasswordStep(onLoadingChanged: setLoading),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_isLoading) const LoadingOverlay(),
      ],
    );
  }

  void setLoading(bool loading) {
    setState(() => _isLoading = loading);
  }
}
