import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../../../flavors.dart';

import '../models/shop_product_model.dart';
import '../../../providers/auth_provider.dart';

part 'iap_provider.g.dart';

@Riverpod(keepAlive: true)
class IAPManager extends _$IAPManager {
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  // Real store product IDs would be configured in App Store Connect / Google Play Console
  // We use placeholder IDs for this task
  final List<String> _productIds = ['ecoco_starter_pack_1', 'ecoco_master_pack_1'];

  @override
  List<ShopProductModel> build() {
    final purchaseUpdated = InAppPurchase.instance.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      log('IAP Error: $error');
    });

    ref.onDispose(() {
      _subscription.cancel();
    });

    // Initialize products
    _loadProducts();

    return [];
  }

  Future<void> _loadProducts() async {
    final bool isAvailable = await InAppPurchase.instance.isAvailable();
    if (!isAvailable) {
      // Return predefined mock list if store unavailable (e.g. testing in simulator)
      state = _getMockProducts();
      return;
    }

    final ProductDetailsResponse productDetailResponse =
        await InAppPurchase.instance.queryProductDetails(_productIds.toSet());

    if (productDetailResponse.error != null) {
      log('IAP Error fetching products: ${productDetailResponse.error}');
      state = _getMockProducts();
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      log('IAP No products found');
      state = _getMockProducts();
      return;
    }

    List<ShopProductModel> shopProducts = [];
    
    // Add point exchange items first
    shopProducts.add(const ShopProductModel(
      id: 'exchange_1',
      title: '遊戲金幣 x1000',
      description: '消耗 10 點 ECOCO',
      currencyType: ProductCurrencyType.ecocoPoint,
      ecocoPointCost: 10,
      goldReward: 1000,
      isAvailable: true,
    ));
    shopProducts.add(const ShopProductModel(
      id: 'exchange_2',
      title: '遊戲金幣 x5000',
      description: '消耗 45 點 ECOCO',
      currencyType: ProductCurrencyType.ecocoPoint,
      ecocoPointCost: 45,
      goldReward: 5000,
      isAvailable: true,
    ));

    // Convert IAP products
    for (var product in productDetailResponse.productDetails) {
      shopProducts.add(ShopProductModel(
        id: product.id,
        title: product.title,
        description: product.description,
        currencyType: ProductCurrencyType.iap,
        iapPriceString: product.price,
        goldReward: product.id == 'ecoco_starter_pack_1' ? 30000 : 150000,
        isAvailable: true,
      ));
    }

    state = shopProducts;
  }

  List<ShopProductModel> _getMockProducts() {
    return const [
      ShopProductModel(
        id: 'exchange_1',
        title: '遊戲金幣 x1000',
        description: '消耗 10 點 ECOCO',
        currencyType: ProductCurrencyType.ecocoPoint,
        ecocoPointCost: 10,
        goldReward: 1000,
        isAvailable: true,
      ),
      ShopProductModel(
        id: 'exchange_2',
        title: '遊戲金幣 x5000',
        description: '消耗 45 點 ECOCO',
        currencyType: ProductCurrencyType.ecocoPoint,
        ecocoPointCost: 45,
        goldReward: 5000,
        isAvailable: true,
      ),
      ShopProductModel(
        id: 'mock_iap_1',
        title: '新手資源包 (測試)',
        description: '內含大量金幣與稀有素材',
        currencyType: ProductCurrencyType.iap,
        iapPriceString: 'NT\$30',
        goldReward: 30000,
        isAvailable: true,
      ),
      ShopProductModel(
        id: 'mock_iap_2',
        title: '大師補給箱 (測試)',
        description: '內含極大量金幣',
        currencyType: ProductCurrencyType.iap,
        iapPriceString: 'NT\$150',
        goldReward: 150000,
        isAvailable: true,
      ),
    ];
  }

  void buyProduct(ShopProductModel product) async {
    if (product.currencyType == ProductCurrencyType.ecocoPoint) {
      // Invoke cloud function to exchange ECOCO points for game gold
      _exchangePointsForGold(product);
      return;
    }

    // Process IAP
    final bool isAvailable = await InAppPurchase.instance.isAvailable();
    if (!isAvailable) {
      log('Store not available for IAP purchase');
      // For testing, mock a successful exchange
      _handleMockIapPurchase(product);
      return;
    }
    
    // Find the real product details
    final ProductDetailsResponse productDetailResponse =
        await InAppPurchase.instance.queryProductDetails({product.id});
        
    if (productDetailResponse.productDetails.isNotEmpty) {
      final ProductDetails realProduct = productDetailResponse.productDetails.first;
      final PurchaseParam purchaseParam = PurchaseParam(productDetails: realProduct);
      
      // We assume consumable for game gold
      InAppPurchase.instance.buyConsumable(purchaseParam: purchaseParam);
    } else {
      log('Could not find product matching ${product.id} in store');
      _handleMockIapPurchase(product);
    }
  }

  Future<void> _handleMockIapPurchase(ShopProductModel product) async {
    log('Mocking purchase for ${product.id}');
    final authData = ref.read(authProvider);
    if (authData?.memberId == null) return;

    try {
      // Call our mock function or directly the verifyReceipt function logic in Cloud Functions
      await FirebaseFunctions.instanceFor(region: 'asia-east1').httpsCallable('verifyMockPurchase').call({
        'memberId': authData!.memberId,
        'productId': product.id,
        'reward': product.goldReward,
        'databaseId': F.gameDatabaseId,
      });
      log('Mock purchase successful');
    } catch (e) {
      log('Mock purchase failed: \$e');
    }
  }

  Future<void> _exchangePointsForGold(ShopProductModel product) async {
    final authData = ref.read(authProvider);
    if (authData?.memberId == null) return;

    try {
      await FirebaseFunctions.instanceFor(region: 'asia-east1').httpsCallable('exchangePointsForGold').call({
        'memberId': authData!.memberId,
        'cost': product.ecocoPointCost,
        'reward': product.goldReward,
        'databaseId': F.gameDatabaseId,
      });
      log('Exchange successful');
    } catch (e) {
      log('Exchange failed: \$e');
    }
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    for (var purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        log('Purchase pending: \${purchaseDetails.productID}');
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          log('Purchase error: \${purchaseDetails.error}');
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
                   purchaseDetails.status == PurchaseStatus.restored) {
          // Send to server for validation
          _verifyPurchaseOnServer(purchaseDetails);
        }

        if (purchaseDetails.pendingCompletePurchase) {
          InAppPurchase.instance.completePurchase(purchaseDetails);
        }
      }
    }
  }

  Future<void> _verifyPurchaseOnServer(PurchaseDetails purchaseDetails) async {
    try {
      final authData = ref.read(authProvider);
      if (authData?.memberId == null) return;

      final serverVerificationData = purchaseDetails.verificationData;
      
      final HttpsCallable callable = FirebaseFunctions.instanceFor(region: 'asia-east1').httpsCallable('verifyReceipt');
      
      Map<String, dynamic> data = {
        'memberId': authData!.memberId,
        'source': serverVerificationData.source,
        'verificationData': serverVerificationData.serverVerificationData,
        'productId': purchaseDetails.productID,
        'databaseId': F.gameDatabaseId,
      };
      
      if (Platform.isAndroid) {
        // App Store receipt formatting vs Google Play format differences
        data['localVerificationData'] = serverVerificationData.localVerificationData;
      }

      await callable.call(data);
      log('Receipt verified successfully on server');
    } catch (e) {
      log('Failed to verify receipt: \$e');
    }
  }
}
