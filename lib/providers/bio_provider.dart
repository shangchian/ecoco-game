import 'package:biometric_storage/biometric_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '/models/bio_auth_model.dart';
import '/repositories/bio_repository.dart';

part 'bio_provider.g.dart';

@Riverpod(keepAlive: true)
class Bio extends _$Bio {
  late final BioRepository _repository = BioRepository();

  @override
  void build() {
    return;
  }

  Future<CanAuthenticateResponse> checkAuthenticate() async {
    return await _repository.checkAuthenticate();
  }

  Future<bool> isSaveBiometricData() async {
    return await _repository.isSaveBiometricData();
  }

  Future<void> saveBiometricData(String phone, String password) async {
    await _repository.saveBiometricData(phone, password);
  }

  Future<void> deleteBiometricData() async {
    await _repository.deleteBiometricData();
  }

  Future<BioAuthData?> getBiometricData() async {
    return await _repository.getBiometricData();
  }
}