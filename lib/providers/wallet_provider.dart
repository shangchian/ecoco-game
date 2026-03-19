import 'package:riverpod_annotation/riverpod_annotation.dart';
import '/models/wallet_model.dart';
import '/repositories/wallet_repository.dart';
import '/providers/points_provider.dart';

part 'wallet_provider.g.dart';

@Riverpod(keepAlive: true)
class WalletNotifier extends _$WalletNotifier {
  WalletRepository? _walletRepository;

  WalletRepository get _repository {
    _walletRepository ??= WalletRepository(
      pointsService: ref.read(pointsServiceProvider),
    );
    return _walletRepository!;
  }

  @override
  WalletData? build() {
    return null;
  }

  /// Initialize wallet data from local storage
  Future<void> initialize() async {
    try {
      final walletData = await _repository.getStoredWalletData();
      if (ref.mounted) {
        state = walletData;
      }
    } catch (e) {
      if (ref.mounted) {}
    }
  }

  /// Fetch wallet data from API using automatic token management
  Future<void> fetchWalletData() async {
    try {
      final walletData = await _repository.fetchAndSaveWalletData();
      if (ref.mounted) {
        state = walletData;
      }
    } catch (e) {
      // Don't clear state on temporary errors
      rethrow;
    }
  }

  /// Clear wallet data
  Future<void> clear() async {
    await _repository.clearWalletData();
    if (ref.mounted) {
      state = null;
    }
  }

  // Convenience getters
  Wallet? get ecocoWallet => state?.ecocoWallet;
  Wallet? get dakaWallet => state?.dakaWallet;
  Wallet? get ntpWallet => state?.ntpWallet;
  int get ecocoBalance => ecocoWallet?.currentBalance ?? 0;
  int get dakaBalance => dakaWallet?.currentBalance ?? 0;
  int get ntpBalance => ntpWallet?.currentBalance ?? 0;
  bool get hasExpiringPoints =>
      (ecocoWallet?.expiryDetails.isExpiringSoon ?? false) ||
      (dakaWallet?.expiryDetails.isExpiringSoon ?? false) ||
      (ntpWallet?.expiryDetails.isExpiringSoon ?? false);
}
