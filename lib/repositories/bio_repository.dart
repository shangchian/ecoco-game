import 'dart:convert';
import 'package:biometric_storage/biometric_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/models/bio_auth_model.dart';

class BioRepository {
  static const String _bioStorageKey = 'ecocov2_auth';
  static const String _isSaveBiometricKey = 'is_save_biometric';

  BiometricStorageFile? _storageCached;

  Future<BiometricStorageFile> _getStorage() async {
    if (_storageCached != null) return _storageCached!;
    _storageCached = await BiometricStorage().getStorage(
      _bioStorageKey,
      options: StorageFileInitOptions(
        authenticationRequired: true,
      ),
    );
    return _storageCached!;
  }

  Future<CanAuthenticateResponse> checkAuthenticate() async {
    return await BiometricStorage().canAuthenticate();
  }

  Future<bool> isSaveBiometricData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isSaveBiometricKey) ?? false;
  }

  Future<void> saveBiometricData(String phone, String password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bioAuthData = BioAuthData(phone: phone, password: password);
    final authStorage = await _getStorage();
    await authStorage.write(jsonEncode(bioAuthData.toJson()));
    await prefs.setBool(_isSaveBiometricKey, true);
  }

  Future<void> deleteBiometricData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final authStorage = await _getStorage();
    await authStorage.delete();
    await prefs.setBool(_isSaveBiometricKey, false);
  }

  Future<BioAuthData?> getBiometricData() async {
    final authStorage = await _getStorage();
    final result = await authStorage.read();
    if (result == null) return null;
    return BioAuthData.fromJson(jsonDecode(result));
  }
}