import '../config/api_config.dart';
import '../config/mock_data.dart';
import '../models/workout_schedule_model.dart';
import 'api_service.dart';

class WorkoutService {
  /// Ambil semua jadwal latihan milik user.
  static Future<List<WorkoutScheduleModel>> getSchedules() async {
    if (ApiConfig.isDemoMode) {
      await Future.delayed(const Duration(milliseconds: 500));
      return MockData.workoutSchedules;
    }

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
    if (ApiConfig.isDemoMode) {
      await Future.delayed(const Duration(milliseconds: 500));
      final newSchedule = WorkoutScheduleModel(
        id: 'demo-workout-${MockData.workoutSchedules.length + 1}',
        title: title,
        scheduleDate: scheduleDate,
        startTime: startTime,
        endTime: endTime,
        trainingZone: trainingZone,
        notes: notes,
        isCompleted: false,
        createdAt: DateTime.now().toIso8601String(),
      );
      MockData.workoutSchedules = [...MockData.workoutSchedules, newSchedule];
      return newSchedule;
    }

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
    if (ApiConfig.isDemoMode) {
      await Future.delayed(const Duration(milliseconds: 300));
      return MockData.workoutSchedules.firstWhere((s) => s.id == id);
    }

    final response = await ApiService.get('${ApiConfig.workoutSchedules}/$id');

    return WorkoutScheduleModel.fromJson(response['data']);
  }

  /// Update jadwal latihan.
  static Future<WorkoutScheduleModel> updateSchedule(
    String id,
    Map<String, dynamic> data,
  ) async {
    if (ApiConfig.isDemoMode) {
      await Future.delayed(const Duration(milliseconds: 400));

      final index = MockData.workoutSchedules.indexWhere((s) => s.id == id);
      final old = MockData.workoutSchedules[index];

      final updated = WorkoutScheduleModel(
        id: old.id,
        title: data['title'] ?? old.title,
        scheduleDate: data['schedule_date'] ?? old.scheduleDate,
        startTime: data['start_time'] ?? old.startTime,
        endTime: data['end_time'] ?? old.endTime,
        trainingZone: data['training_zone'] ?? old.trainingZone,
        notes: data['notes'] ?? old.notes,
        isCompleted: data['is_completed'] ?? old.isCompleted,
        createdAt: old.createdAt,
      );

      final newList = [...MockData.workoutSchedules];
      newList[index] = updated;
      MockData.workoutSchedules = newList;

      return updated;
    }

    final response = await ApiService.put(
      '${ApiConfig.workoutSchedules}/$id',
      data,
    );

    return WorkoutScheduleModel.fromJson(response['data']);
  }

  /// Hapus jadwal latihan.
  static Future<void> deleteSchedule(String id) async {
    if (ApiConfig.isDemoMode) {
      await Future.delayed(const Duration(milliseconds: 400));
      MockData.workoutSchedules = MockData.workoutSchedules
          .where((s) => s.id != id)
          .toList();
      return;
    }

    await ApiService.delete('${ApiConfig.workoutSchedules}/$id');
  }
}
