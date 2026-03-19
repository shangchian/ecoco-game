import 'dart:developer';
import 'package:ecoco_app/providers/avatar_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/member_coupon_provider.dart';
import '../providers/notifications_data_provider.dart';
import '../providers/recycling_stats_provider.dart';
import '/models/auth_data_model.dart';
import '/providers/profile_provider.dart';
import '/providers/wallet_provider.dart';
import '/providers/site_provider.dart';
import '/providers/brand_provider.dart';
import '/providers/coupon_rules_provider.dart';
import '/providers/carousel_provider.dart';
import '/services/interface/i_members_service.dart';
import '/repositories/notification_repository.dart';
import '/repositories/delete_reasons_repository.dart';
import '/services/version_manager.dart';


abstract class InitializationStep {
  /// Display name of the step (in Chinese Traditional)
  String get name;

  /// Execute the initialization step
  Future<void> execute(AuthData authData, Ref ref);
}

/// Result object tracking success/failures of initialization
class InitializationResult {
  final bool completed;
  final List<String> successfulSteps;
  final List<String> failedSteps;
  final Map<String, String> errors;

  InitializationResult({
    required this.completed,
    required this.successfulSteps,
    required this.failedSteps,
    required this.errors,
  });

  factory InitializationResult.empty() {
    return InitializationResult(
      completed: true,
      successfulSteps: [],
      failedSteps: [],
      errors: {},
    );
  }

  bool get hasFailures => failedSteps.isNotEmpty;
  bool get allSuccessful => failedSteps.isEmpty && successfulSteps.isNotEmpty;
}

/// Step 1: Get user profile information from server
class GetInfoStep implements InitializationStep {
  final IMembersService _membersService;

  GetInfoStep(this._membersService);

  @override
  String get name => '載入使用者資料';

  @override
  Future<void> execute(AuthData authData, Ref ref) async {
    final updatedProfileData = await _membersService.getProfile();
    
    // Update the auth provider with refreshed user data
    ref.read(profileProvider.notifier).setProfile(updatedProfileData);

    // Update avatar if changed  
    ref.read(avatarProvider.notifier).loadAvatar(updatedProfileData.avatarUrl ?? '');

    // Update auth provider with the new data
    // Note: This is already done in the repository layer via getInfo()
    // but we ensure it's updated here as well
    log('[GetInfoStep] Successfully loaded user info');
  }
}

/// Step 2: Initialize notification system
class SyncNotificationStep implements InitializationStep {
  final NotificationRepository _notificationRepository;

  SyncNotificationStep(this._notificationRepository);

  @override
  String get name => '同步通知設定';

  @override
  Future<void> execute(AuthData authData, Ref ref) async {
    // Initialize Firebase Messaging
    await _notificationRepository.init(authData);

    // Retry any pending notification setting changes
    await _notificationRepository.retryPendingSync();

    // Load latest notification settings from server
    // This ensures local state is in sync after login
    try {
      await _notificationRepository.loadNotificationSettings();
    } catch (e) {
      log('[SyncNotificationStep] Failed to load notification settings: $e');
      // Don't block initialization if this fails
    }

    log('[SyncNotificationStep] Successfully initialized notifications');
  }
}

/// Step 3: Load user wallet/points data
class LoadPointsStep implements InitializationStep {
  LoadPointsStep();

  @override
  String get name => '載入點數';

  @override
  Future<void> execute(AuthData authData, Ref ref) async {
    await ref.read(walletProvider.notifier).fetchWalletData();
    log('[LoadPointsStep] Successfully loaded wallet data');
  }
}

/// Step 4: Pre-fetch site status data for faster UX
class PreFetchSitesStep implements InitializationStep {
  PreFetchSitesStep();

  @override
  String get name => '載入站點資料';

  @override
  Future<void> execute(AuthData authData, Ref ref) async {
      // Force refresh sites and statuses
      // This ensures we get fresh data (especially statuses) on login
      // even if the provider was already alive (keepAlive: true)
      await ref.read(sitesProvider.notifier).refresh();

    log('[PreFetchSitesStep] Successfully triggered sites initialization');
  }
}

/// Step: Pre-fetch brands data for faster UX
class PreFetchBrandsStep implements InitializationStep {
  PreFetchBrandsStep();

  @override
  String get name => '載入商家資料';

  @override
  Future<void> execute(AuthData authData, Ref ref) async {
    final repository = ref.read(brandRepositoryProvider);
    await repository.syncBrands();
    log('[PreFetchBrandsStep] Successfully synced brands');
  }
}

/// Step: Pre-fetch coupon rules data for faster UX
class PreFetchCouponRulesStep implements InitializationStep {
  PreFetchCouponRulesStep();

  @override
  String get name => '載入優惠券資料';

  @override
  Future<void> execute(AuthData authData, Ref ref) async {
    final repository = ref.read(couponRulesRepositoryProvider);
    await repository.syncCouponRules();
    log('[PreFetchCouponRulesStep] Successfully synced coupon rules');
  }
}

/// Step: Pre-fetch carousels data for faster UX
class PreFetchCarouselsStep implements InitializationStep {
  PreFetchCarouselsStep();

  @override
  String get name => '載入輪播資料';

  @override
  Future<void> execute(AuthData authData, Ref ref) async {
    final repository = ref.read(carouselRepositoryProvider);
    await repository.syncCarousels();
    log('[PreFetchCarouselsStep] Successfully synced carousels');
  }
}

/// Step: Pre-fetch notifications data for faster UX
class PreFetchNotificationsDataStep implements InitializationStep {
  PreFetchNotificationsDataStep();

  @override
  String get name => '載入通知資料';

  @override
  Future<void> execute(AuthData authData, Ref ref) async {
    final repository = ref.read(notificationsDataRepositoryProvider);
    await repository.syncNotifications();
    log('[PreFetchNotificationsDataStep] Successfully synced notifications data');
  }
}

/// Step: Sync coupon status data from API
class SyncCouponStatusStep implements InitializationStep {
  SyncCouponStatusStep();

  @override
  String get name => '載入優惠券狀態';

  @override
  Future<void> execute(AuthData authData, Ref ref) async {
    final repository = ref.read(couponRulesRepositoryProvider);
    await repository.syncCouponStatuses();
    log('[SyncCouponStatusStep] Successfully synced coupon statuses');
  }
}

/// Step: Sync member coupons from server to local database
class SyncMemberCouponsStep implements InitializationStep {
  SyncMemberCouponsStep();

  @override
  String get name => '同步會員優惠券';

  @override
  Future<void> execute(AuthData authData, Ref ref) async {
    final repository = ref.read(memberCouponRepositoryProvider);
    await repository.syncMemberCoupons();
    log('[SyncMemberCouponsStep] Successfully synced member coupons');
  }
}

/// Step 5: Pre-load delete reasons data for faster UX
/// This is an optional step - failure won't block initialization
class PreloadDeleteReasonsStep implements InitializationStep {
  final DeleteReasonsRepository _deleteReasonsRepository;

  PreloadDeleteReasonsStep(this._deleteReasonsRepository);

  @override
  String get name => '載入刪除原因';

  @override
  Future<void> execute(AuthData authData, Ref ref) async {
    // Pre-fetch delete reasons into cache
    // This ensures delete account page loads instantly if user navigates there
    await _deleteReasonsRepository.getDeleteReasons();

    log('[PreloadDeleteReasonsStep] Successfully pre-loaded delete reasons');
  }
}

/// Step 6: Load recycling stats
class LoadRecyclingStatsStep implements InitializationStep {
  LoadRecyclingStatsStep();

  @override
  String get name => '載入回收統計';

  @override
  Future<void> execute(AuthData authData, Ref ref) async {
    await ref.read(recyclingStatsProvider.notifier).fetchRecyclingStats();
    log('[LoadRecyclingStatsStep] Successfully loaded recycling stats');
  }
}

/// Main service that manages post-authentication initialization
class InitializationService {
  final IMembersService _membersService;
  final NotificationRepository _notificationRepository;

  InitializationService({
    required IMembersService membersService,
    required NotificationRepository notificationRepository,
  })  : _membersService = membersService,
        _notificationRepository = notificationRepository;

  /// Get list of initialization steps
  /// Only include active steps (comment out placeholder steps for now)
  // Group 1: Critical sequential steps
  // VersionCheckStep must be first to clear invalid cache
  // GetInfoStep is needed first to update profile/auth state
  List<InitializationStep> get _criticalSteps => [
        VersionCheckStep(),
        GetInfoStep(_membersService),
        SyncNotificationStep(_notificationRepository),
      ];

  // Group 2: Parallel steps (Blocking - needed for Home UI)
  List<InitializationStep> get _blockingParallelSteps => [
        LoadPointsStep(),
      ];

  // Group 3: Parallel steps (Background - run silently)
  List<InitializationStep> get _backgroundParallelSteps => [
        PreFetchSitesStep(),
        PreFetchBrandsStep(),
        PreFetchCouponRulesStep(),
        PreFetchCarouselsStep(),
        PreFetchNotificationsDataStep(),
        SyncCouponStatusStep(),
        SyncMemberCouponsStep(),
        PreloadDeleteReasonsStep(DeleteReasonsRepository()),
        LoadRecyclingStatsStep(),
      ];

  /// Run all initialization steps sequentially
  /// - Calls onProgress callback after each step
  /// - Handles errors gracefully (partial failures allowed)
  /// - Returns InitializationResult with success/failure details
  Future<InitializationResult> runInitialization(
    AuthData authData,
    Ref ref, {
    Function(String stepName, int current, int total)? onProgress,
  }) async {
    final successfulSteps = <String>[];
    final failedSteps = <String>[];
    final errors = <String, String>{};
    final totalStopwatch = Stopwatch()..start();

    // Use the getters to access the steps
    final criticalSteps = _criticalSteps;
    final blockingParallelSteps = _blockingParallelSteps;
    final backgroundParallelSteps = _backgroundParallelSteps;

    final totalSteps = criticalSteps.length + blockingParallelSteps.length + backgroundParallelSteps.length;
    int completedSteps = 0;

    log('[InitializationService] Starting initialization with $totalSteps steps');
    log('[InitializationService] Critical: ${criticalSteps.length}, Blocking Parallel: ${blockingParallelSteps.length}, Background: ${backgroundParallelSteps.length}');

    // 1. Execute Critical Steps Sequentially
    for (final step in criticalSteps) {
      final currentStepNum = ++completedSteps;
      final stepStopwatch = Stopwatch()..start();
      
      try {
        log('[InitializationService] Executing critical step $currentStepNum: ${step.name}');
        onProgress?.call(step.name, currentStepNum, totalSteps);

        await step.execute(authData, ref);

        successfulSteps.add(step.name);
        stepStopwatch.stop();
        log('[InitializationService] Critical step completed: ${step.name} (${stepStopwatch.elapsedMilliseconds} ms)');
      } catch (e) {
        stepStopwatch.stop();
        final errorMessage = e.toString();
        failedSteps.add(step.name);
        errors[step.name] = errorMessage;
        log('[InitializationService] Critical step failed: ${step.name} - $errorMessage (${stepStopwatch.elapsedMilliseconds} ms)');
      }
    }

    // 2. Start Background Parallel Steps (Fire and Forget)
    log('[InitializationService] Starting ${backgroundParallelSteps.length} background steps');
    for (final step in backgroundParallelSteps) {
      _executeStepSafe(step, authData, ref).then((success) {
        if (success) {
          log('[InitializationService] Background step completed: ${step.name}');
        } else {
          log('[InitializationService] Background step failed: ${step.name}');
        }
      });
    }

    // 3. Execute Blocking Parallel Steps (Wait for these)
    if (blockingParallelSteps.isNotEmpty) {
      log('[InitializationService] Executing ${blockingParallelSteps.length} blocking parallel steps');
      final blockingFutures = blockingParallelSteps.map((step) => _executeStepSafe(step, authData, ref));
      
      final results = await Future.wait(blockingFutures);
      
      for (int i = 0; i < blockingParallelSteps.length; i++) {
        if (results[i]) {
          successfulSteps.add(blockingParallelSteps[i].name);
        } else {
          failedSteps.add(blockingParallelSteps[i].name);
        }
      }
    }

    totalStopwatch.stop();
    // Only blocking steps count towards "completed" status for the splash screen
    final completed = failedSteps.isEmpty;
    log('[InitializationService] Blocking initialization complete - Success: ${successfulSteps.length}, Failed: ${failedSteps.length} (Total: ${totalStopwatch.elapsedMilliseconds} ms)');

    // Only return the results of critical and blocking steps
    // Background steps will finish later
    return InitializationResult(
      completed: completed,
      successfulSteps: successfulSteps,
      failedSteps: failedSteps,
      errors: errors,
    );
  }

  /// Helper to execute a single step safely and return success status
  Future<bool> _executeStepSafe(InitializationStep step, AuthData authData, Ref ref) async {
    final stepStopwatch = Stopwatch()..start();
    try {
      await step.execute(authData, ref);
      stepStopwatch.stop();
      // log('[InitializationService] Step finished: ${step.name} (${stepStopwatch.elapsedMilliseconds} ms)');
      return true;
    } catch (e) {
      stepStopwatch.stop();
      log('[InitializationService] Step failed: ${step.name} - $e (${stepStopwatch.elapsedMilliseconds} ms)');
      return false;
    }
  }
}
