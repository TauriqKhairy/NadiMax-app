import '../config/api_config.dart';
import '../config/mock_data.dart';
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
    if (ApiConfig.isDemoMode) {
      await Future.delayed(const Duration(milliseconds: 400));

      final Map<String, TrainingZoneModel> zones = {};
      (MockData.trainingZones['zones'] as Map<String, dynamic>).forEach((
        key,
        value,
      ) {
        zones[key] = TrainingZoneModel.fromJson(value);
      });

      return {
        'hr_max': MockData.trainingZones['hr_max'] as int,
        'zones': zones,
      };
    }

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
    if (ApiConfig.isDemoMode) {
      await Future.delayed(const Duration(milliseconds: 300));

      final hrMax = MockData.trainingZones['hr_max'] as int;
      final percent = (bpm / hrMax) * 100;

      final zones = MockData.trainingZones['zones'] as Map<String, dynamic>;
      for (final entry in zones.entries) {
        final zone = entry.value;
        if (percent >= zone['min_percent'] && percent <= zone['max_percent']) {
          return entry.key;
        }
      }
      return null;
    }

    final response = await ApiService.get('${ApiConfig.detectZone}?bpm=$bpm');

    return response['data']['zone'];
  }
}
