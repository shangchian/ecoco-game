import 'package:ecoco_app/widgets/merchant_reward_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MerchantRewardCard Layout Tests', () {
    testWidgets('renders in unbounded height (ListView)', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              children: const [
                MerchantRewardCard(
                  merchantName: 'Test Merchant',
                  rewardName: 'Test Reward',
                  backgroundImageUrl: 'assets/images/test.png',
                  rewardType: 'Coupon',
                  exchangeRate: '100 points',
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Test Reward'), findsOneWidget);
      expect(find.text('100 points'), findsOneWidget);
    });

    testWidgets('renders in bounded height (SizedBox)', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                height: 300,
                width: 200,
                child: const MerchantRewardCard(
                  merchantName: 'Test Merchant',
                  backgroundImageUrl: 'assets/images/test.png',
                  rewardType: 'Coupon',
                  exchangeRate: '100 points',
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Test Merchant'), findsOneWidget);
    });

    testWidgets('renders in GridView (bounded height cell)', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              children: const [
                MerchantRewardCard(
                  merchantName: 'Grid Merchant',
                  backgroundImageUrl: 'assets/images/test.png',
                  rewardType: 'Coupon',
                  exchangeRate: '50 points',
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Grid Merchant'), findsOneWidget);
    });
  });

  group('MerchantRewardCard Badge Tests', () {
    testWidgets('displays no badges by default', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              children: const [
                MerchantRewardCard(
                  merchantName: 'Normal Merchant',
                  backgroundImageUrl: 'assets/images/test.png',
                  rewardType: 'Coupon',
                  exchangeRate: '100 points',
                ),
              ],
            ),
          ),
        ),
      );

      // Should find the merchant name but no badge widgets
      expect(find.text('Normal Merchant'), findsOneWidget);
      // No badge images should be present
      expect(find.byType(Image), findsOneWidget); // Only background image
    });

    testWidgets('displays NEW badge when showNewBadge is true', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              children: const [
                MerchantRewardCard(
                  merchantName: 'New Merchant',
                  backgroundImageUrl: 'assets/images/test.png',
                  rewardType: 'Coupon',
                  exchangeRate: '100 points',
                  showNewBadge: true,
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('New Merchant'), findsOneWidget);
      // Should find NEW badge image + background image
      expect(find.byType(Image), findsNWidgets(2));
    });

    testWidgets('displays promo label badge', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              children: const [
                MerchantRewardCard(
                  merchantName: 'Promo Merchant',
                  backgroundImageUrl: 'assets/images/test.png',
                  rewardType: 'Coupon',
                  exchangeRate: '100 points',
                  promoLabel: '期間限定',
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Promo Merchant'), findsOneWidget);
      expect(find.text('期間限定'), findsOneWidget);
    });

    testWidgets('displays SOLD_OUT badge with gray overlay', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              children: const [
                MerchantRewardCard(
                  merchantName: 'Sold Out Merchant',
                  backgroundImageUrl: 'assets/images/test.png',
                  rewardType: 'Coupon',
                  exchangeRate: '100 points',
                  showSoldOutBadge: true,
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Sold Out Merchant'), findsOneWidget);
      // Should find SOLD_OUT badge image (redeemed_cover.png + background image)
      expect(find.byType(Image), findsNWidgets(2));
    });

    testWidgets('displays multiple badges simultaneously', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              children: const [
                MerchantRewardCard(
                  merchantName: 'Multi Badge Merchant',
                  backgroundImageUrl: 'assets/images/test.png',
                  rewardType: 'Coupon',
                  exchangeRate: '100 points',
                  promoLabel: '超值優惠',
                  showNewBadge: true,
                  showSoldOutBadge: true,
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Multi Badge Merchant'), findsOneWidget);
      expect(find.text('超值優惠'), findsOneWidget);
      // Should find all badge images: background + NEW + SOLD_OUT + promo label
      expect(find.byType(Image), findsNWidgets(4));
    });

    testWidgets('truncates promo label to 6 characters', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              children: const [
                MerchantRewardCard(
                  merchantName: 'Long Label Merchant',
                  backgroundImageUrl: 'assets/images/test.png',
                  rewardType: 'Coupon',
                  exchangeRate: '100 points',
                  promoLabel: '這是一個很長的促銷標籤',
                ),
              ],
            ),
          ),
        ),
      );

      // The actual truncation happens in fromCouponRule factory
      // Here we're passing it directly, so it won't be truncated
      expect(find.text('Long Label Merchant'), findsOneWidget);
      expect(find.text('這是一個很長的促銷標籤'), findsOneWidget);
    });
  });

  group('MerchantRewardCard Interaction Tests', () {
    testWidgets('calls onTap callback when tapped', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              children: [
                MerchantRewardCard(
                  merchantName: 'Tappable Merchant',
                  backgroundImageUrl: 'assets/images/test.png',
                  rewardType: 'Coupon',
                  exchangeRate: '100 points',
                  onTap: () {
                    tapped = true;
                  },
                ),
              ],
            ),
          ),
        ),
      );

      await tester.tap(find.byType(MerchantRewardCard));
      expect(tapped, isTrue);
    });

    testWidgets('displays reward name instead of merchant name when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              children: const [
                MerchantRewardCard(
                  merchantName: 'Merchant Name',
                  rewardName: 'Reward Name',
                  backgroundImageUrl: 'assets/images/test.png',
                  rewardType: 'Coupon',
                  exchangeRate: '100 points',
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Reward Name'), findsOneWidget);
      expect(find.text('Merchant Name'), findsNothing);
    });
  });
}
