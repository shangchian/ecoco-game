import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:developer';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../flavors.dart';
import '../../../providers/auth_provider.dart';
import '../models/game_wallet_model.dart';

part 'game_wallet_provider.g.dart';

@Riverpod(keepAlive: true)
class GameWallet extends _$GameWallet {
  @override
  Stream<GameWalletModel> build() {
    final authData = ref.watch(authProvider);
    final memberId = authData?.memberId;

    if (memberId == null) {
      // User is not logged in, return stream with default 0 balances
      return Stream.value(const GameWalletModel(gameGold: 0, ecocoPoints: 0));
    }

    final docRef = FirebaseFirestore.instanceFor(
      app: Firebase.app(),
      databaseId: F.gameDatabaseId,
    )
        .collection('members')
        .doc(memberId.toString())
        .collection('game_wallet')
        .doc('default');

    // Client-side writes are forbidden by security rules (allow write: if false).
    // Initialization should happen via Cloud Functions during user creation or purchase.

    log('DEBUG: Connecting to Firestore database: ${F.gameDatabaseId} for member: $memberId');
    
    return docRef.snapshots().map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        final Map<String, dynamic> data = Map<String, dynamic>.from(snapshot.data()!);
        
        // Handle Firestore Timestamp conversion to ISO8601 String for the model
        if (data['lastSyncedAt'] is Timestamp) {
          data['lastSyncedAt'] = (data['lastSyncedAt'] as Timestamp).toDate().toIso8601String();
        }
        
        final wallet = GameWalletModel.fromJson(data);
        log('DEBUG: Wallet data received: ${wallet.gameGold} Gold, ${wallet.ecocoPoints} Points');
        return wallet;
      }
      log('DEBUG: Wallet document does not exist at path: ${docRef.path}');
      return const GameWalletModel();
    }).handleError((error) {
      log('DEBUG: Firestore Stream Error: $error');
    });
  }
}
