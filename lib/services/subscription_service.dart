import '../config/api_config.dart';
import '../models/subscription_model.dart';
import 'api_service.dart';

class SubscriptionService {
  /// Ambil subscription aktif milik user.
  static Future<Map<String, dynamic>> getActiveSubscription() async {
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
    final response = await ApiService.post(ApiConfig.subscriptionUpgrade, {
      'duration_in_days': durationInDays,
    });

    return SubscriptionModel.fromJson(response['data']);
  }

  /// Downgrade ke plan Free.
  static Future<SubscriptionModel> downgradeToFree() async {
    final response = await ApiService.post(ApiConfig.subscriptionDowngrade, {});

    return SubscriptionModel.fromJson(response['data']);
  }
}
