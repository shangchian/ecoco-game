import 'package:auto_route/auto_route.dart';
import '../../../../constants/colors.dart';
import '/providers/wallet_provider.dart';
import '/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/l10n/app_localizations.dart';
import '/utils/router_analytics_extension.dart';

@RoutePage()
class PointTransferPage extends ConsumerStatefulWidget {
  const PointTransferPage({super.key});

  @override
  ConsumerState<PointTransferPage> createState() => _PointTransferPageState();
}

class _PointTransferPageState extends ConsumerState<PointTransferPage> {
  final _formKey = GlobalKey<FormState>();
  final _pointsController = TextEditingController();
  final _phoneController = TextEditingController();
  final bool _isLoading = false;

  @override
  void dispose() {
    _pointsController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      context.router.pushThrottledWithTracking(
        PointTransferConfirmRoute(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final walletData = ref.watch(walletProvider);
    final appLocale = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocale?.pointsTransferTitle ?? ""),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 可用點數顯示
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        appLocale?.pointsTransferAvaliable ?? "",
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        (walletData?.ecocoWallet.currentBalance ?? 0).toString(),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 贈予點數輸入
                TextFormField(
                  controller: _pointsController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: appLocale?.pointsTransferCount ?? "",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return appLocale?.pointsTransferCountZeroMsg ?? "";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // 手機號碼輸入
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: appLocale?.pointsTransferRecvHint ?? "",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return appLocale?.pointsTransferRecvPhone2 ?? "";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // 注意事項
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appLocale?.pointsTransferManualTitle ?? "",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(appLocale?.pointsTransferManual1 ?? ""),
                      Text(appLocale?.pointsTransferManual2 ?? ""),
                      Text(appLocale?.pointsTransferManual3 ?? ""),
                      Text(appLocale?.pointsTransferManual4 ?? ""),
                      Text(appLocale?.pointsTransferManual5 ?? ""),
                      Text(appLocale?.pointsTransferManual6 ?? ""),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 提交按鈕
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
                      : const Text(
                          '下一步',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
