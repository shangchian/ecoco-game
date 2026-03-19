import 'dart:convert';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import '/models/wallet_model.dart';
import '/services/interface/i_points_service.dart';
import '/services/online/points_service.dart';
import '/services/mock/points_service_mock.dart';
import '/flavors.dart';

class WalletRepository {
  static const String walletDataKey = 'walletData';
  final IPointsService _pointsService;

  WalletRepository({IPointsService? pointsService})
      : _pointsService = pointsService ??
          (F.useMockService ? PointsServiceMock() : PointsService());

  /// Get wallet data from local storage
  Future<WalletData?> getStoredWalletData() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? walletDataString = prefs.getString(walletDataKey);

      if (walletDataString == null) return null;

      final decodedData = jsonDecode(walletDataString);
      if (decodedData is! Map<String, dynamic>) {
        throw FormatException('Invalid stored wallet data format');
      }

      return WalletData.fromJson(decodedData);
    } catch (e) {
      log('Error getting stored wallet data: $e');
      return null;
    }
  }

  /// Fetch wallet data from API and save to local storage
  Future<WalletData> fetchAndSaveWalletData() async {
    try {
      // Fetch all wallets (no currency filter)
      final walletData = await _pointsService.getMemberPoints();

      // Save to local storage
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(walletDataKey, jsonEncode(walletData.toJson()));

      return walletData;
    } catch (e) {
      log('Error fetching wallet data: $e');
      rethrow;
    }
  }

  /// Clear wallet data from local storage
  Future<void> clearWalletData() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(walletDataKey);
    } catch (e) {
      log('Error clearing wallet data: $e');
    }
  }
}
