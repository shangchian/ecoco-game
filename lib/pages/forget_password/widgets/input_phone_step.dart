import 'package:auto_route/auto_route.dart';
import '/pages/common/alerts/simple_error_alert.dart';
import '/pages/common/alerts/phone_not_registered_alert.dart';
import '/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/l10n/app_localizations.dart';
import '/providers/forget_password_provider.dart';
import '/providers/register/register_validator.dart';
import '/pages/common/auth_button.dart';
import '/pages/common/form_fields/phone_field.dart';
import '/services/online/base_service.dart';
import '/repositories/auth_repository.dart';
import '/router/app_router.dart';
import '/utils/router_analytics_extension.dart';

class InputPhoneStep extends ConsumerStatefulWidget {
  const InputPhoneStep({
    super.key,
    required this.onNext,
    required this.onLoadingChanged,
  });

  final void Function() onNext;
  final Function(bool) onLoadingChanged;

  @override
  ConsumerState<InputPhoneStep> createState() => _InputPhoneStepState();
}

class _InputPhoneStepState extends ConsumerState<InputPhoneStep> {
  late final TextEditingController _phoneController;
  bool _canRequestOTP = false;

  @override
  void initState() {
    super.initState();
    final initialPhone = ref.read(forgetPasswordControllerProvider).phoneNumber;
    _phoneController = TextEditingController(text: initialPhone);

    ref.listenManual(
        forgetPasswordControllerProvider.select((state) => state.phoneNumber),
        (previous, next) {
      if (_phoneController.text != next) {
        _phoneController.text = next;
      }
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleNext(WidgetRef ref) async {
    FocusScope.of(context).unfocus();
    widget.onLoadingChanged(true);

    try {
      final forgetPasswordController =
          ref.read(forgetPasswordControllerProvider.notifier);
      final phoneNumber = _phoneController.text;
      forgetPasswordController.updatePhoneNumber(phoneNumber);

      final authNotifier = ref.read(authProvider.notifier);
      final response = await authNotifier.sendForgetPasswordVerificationCode(phoneNumber);

      if (!mounted) return;

      // Store OTP response timing information in the provider for use in verify step
      forgetPasswordController.updateOtpResponse(response);

      if (mounted) {
        widget.onNext();
      }
    } catch (e) {
      if (!mounted) return;
      final appLocale = AppLocalizations.of(context);

      // Check for OTP rate limit exception first
      if (e is OtpRateLimitException) {
        await showDialog(
          context: context,
          builder: (_) => SimpleErrorAlert(
            title: '發送次數達上限',
            message: '您今日已發送 OTP 簡訊超過上限，\n請於 60 分鐘後再重試。',
            buttonText: appLocale?.okay ?? "確認",
            onPressed: () {},
          ),
        );
        return;
      }

      if (e is ApiException) {
        String message;
        VoidCallback onPressed;

        switch (e.code) {
          case ApiErrorCodes.sendOtpRateLimitExceeded:
            // Code 10007: Rate limit exceeded
            message = e.message;  // Use server message
            onPressed = () {};    // Just close dialog
            break;

          case ApiErrorCodes.smsSendFailure:
            // Code 10008: SMS service failure
            message = e.message;  // Use server message
            onPressed = () {};    // Just close dialog
            break;

          case ApiErrorCodes.accountNotRegistered:
            // Code 10003: Phone not registered - show specialized alert
            if (!mounted) return;
            await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => PhoneNotRegisteredAlert(
                onRetry: () {
                  _phoneController.clear();
                },
                onGoToRegister: () {
                  if (!mounted) return;
                  // 先回到登入頁，再導入註冊頁
                  context.router.popUntil((route) => route.settings.name == LoginRoute.name);
                  context.router.pushThrottledWithTracking(RegisterRoute());
                },
              ),
            );
            return;

          default:
            // Generic API error
            message = e.message;
            onPressed = () {};
            break;
        }

        if(mounted) {
          await showDialog(
            context: context,
            builder: (_) =>
                SimpleErrorAlert(
                  message: message,
                  buttonText: appLocale?.okay ?? "",
                  onPressed: onPressed,
                ),
          );
        }
      } else {
        // Network or other non-API errors
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
        widget.onLoadingChanged(false);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(35, 16, 35, 16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    appLocale?.inputPhoneStepHint ?? "請確認您的手機門號",
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  PhoneFormField(
                    controller: _phoneController,
                    onChanged: (value) {
                      setState(() {
                        _canRequestOTP = RegisterValidator.validatePhone(value) == null;
                      });
                    },
                  ),
                  const SizedBox(height: 32),
                  AuthButton(
                    onPressed: () async {
                      await _handleNext(ref);
                    },
                    label: appLocale?.next ?? "下一步",
                    isEnabled: _canRequestOTP,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}
