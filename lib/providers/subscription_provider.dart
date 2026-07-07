import 'package:flutter/material.dart';
import '../models/subscription_model.dart';
import '../services/api_service.dart';
import '../services/subscription_service.dart';

class SubscriptionProvider extends ChangeNotifier {
  SubscriptionModel? _subscription;
  bool _isPremium = false;
  bool _isLoading = false;
  String? _errorMessage;

  SubscriptionModel? get subscription => _subscription;
  bool get isPremium => _isPremium;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Ambil subscription aktif milik user.
  Future<void> fetchSubscription() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await SubscriptionService.getActiveSubscription();
      _subscription = result['subscription'];
      _isPremium = result['is_premium'];
      _isLoading = false;
      notifyListeners();
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Upgrade ke Premium.
  Future<bool> upgradeToPremium({int durationInDays = 30}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _subscription = await SubscriptionService.upgradeToPremium(
        durationInDays: durationInDays,
      );
      _isPremium = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Downgrade ke Free.
  Future<bool> downgradeToFree() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _subscription = await SubscriptionService.downgradeToFree();
      _isPremium = false;
      _isLoading = false;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Bersihkan pesan error.
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
