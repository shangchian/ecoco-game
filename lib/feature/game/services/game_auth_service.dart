import 'dart:developer';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../flavors.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/wallet_provider.dart';

part 'game_auth_service.g.dart';

@Riverpod(keepAlive: true)
class GameAuthService extends _$GameAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instanceFor(region: 'asia-east1');

  @override
  void build() {
    // 1. Reactive Sync: Wait for wallet data to be ready before syncing to Firebase
    // This solves the race condition where silentLogin triggers before ecocoBalance is loaded.
    ref.listen(walletProvider, (previous, next) {
      if (next != null && (previous == null || previous.ecocoWallet?.currentBalance == 0)) {
        final authData = ref.read(authProvider);
        if (authData != null) {
          log('AUTH: Wallet data received (${next.ecocoWallet?.currentBalance} points), triggering point sync!');
          silentLogin(authData.accessToken, authData.memberId);
        }
      }
    });

    // 2. Auth Transition Listening: Handle login/logout
    ref.listen(authProvider, (previous, next) {
      if (next != null && previous == null) {
        log('AUTH: Just logged in, waiting for wallet to sync...');
        // silentLogin will be triggered by the walletProvider listener once data is fetched
      } else if (next == null && previous != null) {
        log('AUTH: Logged out, triggering logout');
        logout();
      }
    });
  }

  /// Perform silent login to Firebase using existing AccessToken
  Future<void> silentLogin(String accessToken, String memberId) async {
    try {
      log('Starting silent Firebase login...');
      
      // 1. Call Cloud Function to exchange AccessToken for CustomToken
      final ecocoPoints = ref.read(walletProvider.notifier).ecocoBalance;
      log('AUTH: Synching ecocoPoints for $memberId: $ecocoPoints');
      
      final result = await _functions.httpsCallable('exchangeToken').call({
        'accessToken': 'MOCK_TOKEN',
        'memberId': memberId,
        'ecocoPoints': ecocoPoints,
        'databaseId': F.gameDatabaseId,
      });

      final String? customToken = result.data['customToken'];
      if (customToken == null) {
        throw Exception('Failed to get custom token from server');
      }

      // 2. Sign in to Firebase with the Custom Token
      await _auth.signInWithCustomToken(customToken);
      log('Silent Firebase login successful: ${_auth.currentUser?.uid}');
    } catch (e) {
      log('Silent Firebase login failed: $e');
      // We don't throw here to avoid breaking the main app experience,
      // but we log it for debugging.
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    log('Firebase logged out.');
  }

  User? get currentUser => _auth.currentUser;
}
