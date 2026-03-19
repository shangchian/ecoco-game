import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/colors.dart';
import '/providers/brand_provider.dart';
import 'merchant_detail_page.dart';

/// 透過 brandId 載入 Brand 後顯示 MerchantDetailPage
/// 用於 Deep Link / Universal Link 導航
@RoutePage()
class MerchantDetailByIdPage extends ConsumerWidget {
  final String brandId;

  const MerchantDetailByIdPage({
    super.key,
    @PathParam('brandId') required this.brandId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brandAsync = ref.watch(brandByIdProvider(brandId));

    return brandAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryHighlightColor,
            )
        ),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                '無法載入商家資訊',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.router.maybePop(),
                child: const Text('返回'),
              ),
            ],
          ),
        ),
      ),
      data: (brand) {
        if (brand == null) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.store_outlined, size: 48, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    '找不到此商家',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.router.maybePop(),
                    child: const Text('返回'),
                  ),
                ],
              ),
            ),
          );
        }
        // 成功載入 Brand，顯示實際的 MerchantDetailPage
        return MerchantDetailPage(brand: brand);
      },
    );
  }
}
