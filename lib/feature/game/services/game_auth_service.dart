import 'dart:developer';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ecoco_app/providers/auth_provider.dart';

part 'game_auth_service.g.dart';

@Riverpod(keepAlive: true)
class GameAuthService extends _$GameAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  @override
  void build() {
    // Listen to changes in the main auth state
    ref.listen(authProvider, (previous, next) {
      final authData = next;
      if (authData != null && previous == null) {
        // Just logged in to main app, try silent login to Firebase
        silentLogin(authData.accessToken);
      } else if (next == null && previous != null) {
        // Logged out from main app, logout from Firebase too
        logout();
      }
    });
  }

  /// Perform silent login to Firebase using existing AccessToken
  Future<void> silentLogin(String accessToken) async {
    try {
      log('Starting silent Firebase login...');
      
      // 1. Call Cloud Function to exchange AccessToken for CustomToken
      final result = await _functions.httpsCallable('exchangeToken').call({
        'accessToken': accessToken,
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
