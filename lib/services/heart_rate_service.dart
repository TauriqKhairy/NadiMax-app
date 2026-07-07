import '../config/api_config.dart';
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
    final response = await ApiService.get(
      '${ApiConfig.heartRateHistory}?per_page=$perPage',
    );

    final List<dynamic> data = response['data'];
    return data.map((json) => HeartRateModel.fromJson(json)).toList();
  }

  /// Ambil BPM terakhir milik user.
  static Future<HeartRateModel?> getLatest() async {
    final response = await ApiService.get(ApiConfig.heartRateLatest);

    if (response['data'] == null) {
      return null;
    }

    return HeartRateModel.fromJson(response['data']);
  }
}
