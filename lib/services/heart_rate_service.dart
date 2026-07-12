import '../config/api_config.dart';
import '../config/mock_data.dart';
import '../models/heart_rate_model.dart';
import 'api_service.dart';

class HeartRateService {
  /// Kirim data BPM baru (dipanggil saat menerima data dari ESP32).
  static Future<HeartRateModel> recordHeartRate({
    required String deviceId,
    required int bpm,
    int? spo2,
    String? measuredAt,
  }) async {
    if (ApiConfig.isDemoMode) {
      await Future.delayed(const Duration(milliseconds: 400));
      final newRecord = HeartRateModel(
        id: 'demo-hr-${MockData.heartRateHistory.length + 1}',
        deviceId: deviceId,
        deviceName: MockData.devices.first.deviceName,
        bpm: bpm,
        spo2: spo2,
        measuredAt: measuredAt ?? DateTime.now().toIso8601String(),
      );
      MockData.heartRateHistory = [newRecord, ...MockData.heartRateHistory];
      return newRecord;
    }

    final response = await ApiService.post(ApiConfig.heartRates, {
      'device_id': deviceId,
      'bpm': bpm,
      'spo2': spo2,
      'measured_at': measuredAt,
    });

    return HeartRateModel.fromJson(response['data']);
  }

  /// Ambil history BPM milik user (dengan pagination).
  static Future<List<HeartRateModel>> getHistory({int perPage = 20}) async {
    if (ApiConfig.isDemoMode) {
      await Future.delayed(const Duration(milliseconds: 500));
      return MockData.heartRateHistory;
    }

    final response = await ApiService.get(
      '${ApiConfig.heartRateHistory}?per_page=$perPage',
    );

    final List<dynamic> data = response['data'];
    return data.map((json) => HeartRateModel.fromJson(json)).toList();
  }

  /// Ambil BPM terakhir milik user.
  static Future<HeartRateModel?> getLatest() async {
    if (ApiConfig.isDemoMode) {
      await Future.delayed(const Duration(milliseconds: 300));
      return MockData.latestHeartRate;
    }

    final response = await ApiService.get(ApiConfig.heartRateLatest);

    if (response['data'] == null) {
      return null;
    }

    return HeartRateModel.fromJson(response['data']);
  }
}
