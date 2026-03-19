import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../constants/colors.dart';
import '../../../common/alerts/simple_error_alert.dart';
import '/l10n/app_localizations.dart';

@RoutePage()
class PointTransferConfirmPage extends ConsumerStatefulWidget {
  const PointTransferConfirmPage({super.key});

  @override
  ConsumerState<PointTransferConfirmPage> createState() =>
      _PointTransferConfirmPageState();
}

class _PointTransferConfirmPageState
    extends ConsumerState<PointTransferConfirmPage> {
  final _otpController = TextEditingController();
  bool _isLoading = false;
  late String points;
  late String phoneNumber;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _handleGetOTP() async {
    // TODO: 實作取得OTP邏輯
  }

  Future<void> _handleSubmit() async {
    setState(() => _isLoading = true);

    try {
      // TODO: 實作確認轉贈邏輯

      if (mounted) {
        // 完成後返回到首頁或指定頁面
        context.router.popUntilRoot();
      }
    } catch (e) {
      if (mounted) {
        await showDialog(
          context: context,
          builder: (_) => SimpleErrorAlert(
            title: '轉贈失敗',
            message: e.toString(),
            buttonText: '確認',
            onPressed: () {},
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(appLocale?.pointsTransferConfirm ?? ""),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                appLocale?.pointsTransferConfirmMsg ?? "",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32),

              // 點數顯示
              Text(
                appLocale?.pointsTransferHint ?? "",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/ecoco_points_icon.png', // 請確保有此圖片資源
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      points,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 手機號碼顯示
              Text(
                appLocale?.pointsTransferRecvPhone ?? "",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                phoneNumber,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 32),

              // OTP驗證區塊
              Text(
                appLocale?.pointsTransferOTPHints ?? "",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: appLocale?.pointsTransferOTPMsg ?? "",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: _handleGetOTP,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.black),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  '取得驗證碼',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(height: 32),

              // 確定轉贈按鈕
              ElevatedButton(
                onPressed: _isLoading ? null : _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primaryHighlightColor,
                        ),
                      )
                    : Text(
                        appLocale?.pointsTransferDoubleConfirm ?? "",
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
