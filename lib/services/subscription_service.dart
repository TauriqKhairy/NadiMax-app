import '../config/api_config.dart';
import '../config/mock_data.dart';
import '../models/subscription_model.dart';
import 'api_service.dart';

class SubscriptionService {
  /// Ambil subscription aktif milik user.
  static Future<Map<String, dynamic>> getActiveSubscription() async {
    if (ApiConfig.isDemoMode) {
      await Future.delayed(const Duration(milliseconds: 400));
      return {
        'subscription': MockData.subscription,
        'is_premium':
            MockData.subscription.plan == 'premium' &&
            MockData.subscription.isValid,
      };
    }

    final response = await ApiService.get(ApiConfig.subscription);
    final data = response['data'];

    return {
      'subscription': SubscriptionModel.fromJson(data['subscription']),
      'is_premium': data['is_premium'] as bool,
    };
  }

  /// Upgrade ke plan Premium.
  static Future<SubscriptionModel> upgradeToPremium({
    int durationInDays = 30,
  }) async {
    if (ApiConfig.isDemoMode) {
      await Future.delayed(const Duration(milliseconds: 600));
      MockData.subscription = SubscriptionModel(
        id: MockData.subscription.id,
        plan: 'premium',
        startedAt: DateTime.now().toIso8601String(),
        expiredAt: DateTime.now()
            .add(Duration(days: durationInDays))
            .toIso8601String(),
        isActive: true,
        isValid: true,
      );
      return MockData.subscription;
    }

    final response = await ApiService.post(ApiConfig.subscriptionUpgrade, {
      'duration_in_days': durationInDays,
    });

    return SubscriptionModel.fromJson(response['data']);
  }

  /// Downgrade ke plan Free.
  static Future<SubscriptionModel> downgradeToFree() async {
    if (ApiConfig.isDemoMode) {
      await Future.delayed(const Duration(milliseconds: 500));
      MockData.subscription = SubscriptionModel(
        id: MockData.subscription.id,
        plan: 'free',
        startedAt: DateTime.now().toIso8601String(),
        expiredAt: null,
        isActive: true,
        isValid: true,
      );
      return MockData.subscription;
    }

    final response = await ApiService.post(ApiConfig.subscriptionDowngrade, {});

    return SubscriptionModel.fromJson(response['data']);
  }
}
