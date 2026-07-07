import 'package:flutter/material.dart';
import '../models/heart_rate_model.dart';
import '../services/api_service.dart';
import '../services/heart_rate_service.dart';

class HeartRateProvider extends ChangeNotifier {
  List<HeartRateModel> _history = [];
  HeartRateModel? _latest;
  bool _isLoading = false;
  String? _errorMessage;

  List<HeartRateModel> get history => _history;
  HeartRateModel? get latest => _latest;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Ambil history BPM milik user.
  Future<void> fetchHistory({int perPage = 20}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _history = await HeartRateService.getHistory(perPage: perPage);
      _isLoading = false;
      notifyListeners();
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Ambil BPM terakhir milik user (buat ditampilkan di Dashboard).
  Future<void> fetchLatest() async {
    try {
      _latest = await HeartRateService.getLatest();
      notifyListeners();
    } on ApiException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
    }
  }

  /// Bersihkan pesan error.
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
