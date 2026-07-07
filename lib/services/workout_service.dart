import '../config/api_config.dart';
import '../models/workout_schedule_model.dart';
import 'api_service.dart';

class WorkoutService {
  /// Ambil semua jadwal latihan milik user.
  static Future<List<WorkoutScheduleModel>> getSchedules() async {
    final response = await ApiService.get(ApiConfig.workoutSchedules);

    final List<dynamic> data = response['data'];
    return data.map((json) => WorkoutScheduleModel.fromJson(json)).toList();
  }

  /// Buat jadwal latihan baru.
  static Future<WorkoutScheduleModel> createSchedule({
    required String title,
    required String scheduleDate,
    required String startTime,
    String? endTime,
    String? trainingZone,
    String? notes,
  }) async {
    final response = await ApiService.post(ApiConfig.workoutSchedules, {
      'title': title,
      'schedule_date': scheduleDate,
      'start_time': startTime,
      'end_time': endTime,
      'training_zone': trainingZone,
      'notes': notes,
    });

    return WorkoutScheduleModel.fromJson(response['data']);
  }

  /// Ambil detail 1 jadwal.
  static Future<WorkoutScheduleModel> getScheduleDetail(String id) async {
    final response = await ApiService.get('${ApiConfig.workoutSchedules}/$id');

    return WorkoutScheduleModel.fromJson(response['data']);
  }

  /// Update jadwal latihan.
  static Future<WorkoutScheduleModel> updateSchedule(
    String id,
    Map<String, dynamic> data,
  ) async {
    final response = await ApiService.put(
      '${ApiConfig.workoutSchedules}/$id',
      data,
    );

    return WorkoutScheduleModel.fromJson(response['data']);
  }

  /// Hapus jadwal latihan.
  static Future<void> deleteSchedule(String id) async {
    await ApiService.delete('${ApiConfig.workoutSchedules}/$id');
  }
}
