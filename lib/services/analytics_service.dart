import '../config/api_config.dart';
import 'api_service.dart';

class TrainingZoneModel {
  final String label;
  final int minBpm;
  final int maxBpm;
  final int minPercent;
  final int maxPercent;

  TrainingZoneModel({
    required this.label,
    required this.minBpm,
    required this.maxBpm,
    required this.minPercent,
    required this.maxPercent,
  });

  factory TrainingZoneModel.fromJson(Map<String, dynamic> json) {
    return TrainingZoneModel(
      label: json['label'],
      minBpm: json['min_bpm'],
      maxBpm: json['max_bpm'],
      minPercent: json['min_percent'],
      maxPercent: json['max_percent'],
    );
  }
}

class AnalyticsService {
  /// Ambil HR Max dan semua Training Zone milik user.
  static Future<Map<String, dynamic>> getTrainingZones() async {
    final response = await ApiService.get(ApiConfig.trainingZones);
    final data = response['data'];

    final Map<String, TrainingZoneModel> zones = {};
    (data['zones'] as Map<String, dynamic>).forEach((key, value) {
      zones[key] = TrainingZoneModel.fromJson(value);
    });

    return {'hr_max': data['hr_max'] as int, 'zones': zones};
  }

  /// Deteksi training zone dari nilai BPM tertentu.
  static Future<String?> detectZone(int bpm) async {
    final response = await ApiService.get('${ApiConfig.detectZone}?bpm=$bpm');

    return response['data']['zone'];
  }
}
