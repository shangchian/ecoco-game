import 'dart:developer' as dev;
import 'package:auto_route/auto_route.dart';
import 'package:ecoco_app/constants/colors.dart';
import '/pages/common/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/l10n/app_localizations.dart';
import '/models/verify_otp_response_model.dart';
import '/pages/register/widgets/account_step.dart';
import '/pages/register/widgets/password_step.dart';
import '/pages/register/widgets/profile_step.dart';
import '/pages/common/auth_page_layout.dart';
import '/pages/common/auth_step_tabs.dart';
import '/pages/common/alerts/register_exit_confirm_alert.dart';
import '/widgets/terms_and_privacy_dialog.dart';
import '/providers/register/register_provider.dart';

@RoutePage()
class RegisterPage extends ConsumerStatefulWidget {
  final VerifyOtpResponse? initialTokens;
  final int? initialStep;
  final String? initialPassword;
  final String? initialPhone;

  const RegisterPage({
    super.key,
    this.initialTokens,
    this.initialStep,
    this.initialPassword,
    this.initialPhone,
  });

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _pageController = PageController();
  int _currentPage = 0;
  bool _isLoading = false;
  VerifyOtpResponse? _tempTokens;

  void _goToNextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _showExitConfirmDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return RegisterExitConfirmAlert(
          onContinue: () {
            // Dialog already pops itself, nothing else needed
          },
          onExit: () {
            context.router.maybePop();
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    // If initialTokens and initialStep are provided, this is a resume registration flow
    if (widget.initialTokens != null && widget.initialStep != null) {
      // Set the tokens immediately
      _tempTokens = widget.initialTokens;

      // If initialPassword is provided (TEMPORARY account flow),
      // initialize it in registerState so it's available in ProfileStep
      if (widget.initialPassword != null && widget.initialPassword!.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            dev.log('Initializing password in registerState: ${widget.initialPassword!.length} chars',
                    name: 'RegisterPage');
            ref.read(registerProvider.notifier).updatePassword(widget.initialPassword!);
          }
        });
      }

      // If initialPhone is provided, initialize it so auto-login works
      if (widget.initialPhone != null && widget.initialPhone!.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            ref.read(registerProvider.notifier).updatePhone(widget.initialPhone!);
          }
        });
      }

      // Jump to the specified step after the first frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _pageController.jumpToPage(widget.initialStep!);
        setState(() => _currentPage = widget.initialStep!);
      });
    } else {
      // Normal registration flow - show terms and privacy dialog
      _showTermsAndPrivacyDialog();
    }
  }

  void _showTermsAndPrivacyDialog() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      final result = await TermsAndPrivacyDialog.show(
        context,
        requireScrollToBottom: true,
      );

      // If user disagreed or dismissed dialog, go back to previous page
      if (result != true) {
        if (mounted) {
          context.router.maybePop();
        }
      }
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
      appLocale?.phoneVerification ?? "",
      appLocale?.setPassword ?? "",
      appLocale?.personalInformation ?? "",
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
          backgroundColor: Colors.transparent,
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
                      appLocale?.registerTitle ?? "",
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
                              onPressed: _showExitConfirmDialog,
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
                        AccountStep(
                          onNext: (tokens) {
                            setState(() {
                              _tempTokens = tokens;
                            });
                            _goToNextPage();
                          },
                          onLoadingChanged: setLoading,
                        ),
                        if (_tempTokens != null)
                          PasswordStep(
                            tempTokens: _tempTokens!,
                            onNext: _goToNextPage,
                          )
                        else
                          const SizedBox.shrink(),
                        if (_tempTokens != null)
                          ProfileStep(
                            tempTokens: _tempTokens!,
                            onLoadingChanged: setLoading,
                            initialPassword: widget.initialPassword,
                          )
                        else
                          const SizedBox.shrink(),
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
