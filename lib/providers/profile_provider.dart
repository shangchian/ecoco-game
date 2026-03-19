import 'package:riverpod_annotation/riverpod_annotation.dart';
import '/models/profile_data_model.dart';
import '/models/auth_data_model.dart';
import '/repositories/auth_repository.dart';
import '/providers/members_service_provider.dart';
import '/providers/auth_provider.dart';

part 'profile_provider.g.dart';

@Riverpod(keepAlive: true)
class ProfileNotifier extends _$ProfileNotifier {
  AuthRepository? _authRepository;

  AuthRepository get _repository {
    _authRepository ??= AuthRepository(
      membersService: ref.read(membersServiceProvider),
    );
    return _authRepository!;
  }

  @override
  ProfileData? build() {
    return null;
  }

  /// Fetch user profile using automatic token management
  ///
  /// Automatically gets a valid access token from AuthProvider, refreshing if needed.
  /// Throws exceptions that are handled internally:
  /// - [NotAuthenticatedException]: User not logged in - clears state
  /// - [TokenRefreshFailedException]: Token refresh failed - clears state
  Future<void> fetchProfile() async {
    try {
      final profileData = await _repository.getInfo();
      if (ref.mounted) {
        state = profileData;
      }
    } catch (e) {
      // Handle other errors - don't clear state on temporary errors (network, server 500, etc.)
      // Just rethrow so caller can handle if needed
      if (ref.mounted) {
        // Only rethrow if necessary, or just silent fail to keep UI showing cached data
        // rethrow; 
      }
    }
  }

  Future<void> updateProfile({
    required AuthData authData,
    required String nickname,
    String? email,
    String? gender,
    String? birthday,
    String? districtId,
    String? areaId,
  }) async {
    try {
      final updatedProfile = await _repository.updateProfile(
        authData: authData,
        nickname: nickname,
        email: email,
        gender: gender,
        birthday: birthday,
        districtId: districtId,
        areaId: areaId,
      );
      if (ref.mounted) {
        state = updatedProfile;
      }
    } catch (e) {
      rethrow;
    }
  }

  void clear() {
    state = null;
  }
  
  void setProfile(ProfileData profile) {
    state = profile;
  }
}