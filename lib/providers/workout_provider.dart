import 'package:flutter/material.dart';
import '../models/workout_schedule_model.dart';
import '../services/api_service.dart';
import '../services/workout_service.dart';

class WorkoutProvider extends ChangeNotifier {
  List<WorkoutScheduleModel> _schedules = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<WorkoutScheduleModel> get schedules => _schedules;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Ambil semua jadwal latihan milik user.
  Future<void> fetchSchedules() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _schedules = await WorkoutService.getSchedules();
      _isLoading = false;
      notifyListeners();
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Buat jadwal baru, otomatis tambahkan ke list lokal.
  Future<bool> createSchedule({
    required String title,
    required String scheduleDate,
    required String startTime,
    String? endTime,
    String? trainingZone,
    String? notes,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newSchedule = await WorkoutService.createSchedule(
        title: title,
        scheduleDate: scheduleDate,
        startTime: startTime,
        endTime: endTime,
        trainingZone: trainingZone,
        notes: notes,
      );

      _schedules = [..._schedules, newSchedule];
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

  /// Update jadwal, otomatis update di list lokal.
  Future<bool> updateSchedule(String id, Map<String, dynamic> data) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedSchedule = await WorkoutService.updateSchedule(id, data);

      _schedules = _schedules.map((schedule) {
        return schedule.id == id ? updatedSchedule : schedule;
      }).toList();

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

  /// Hapus jadwal, otomatis hilangkan dari list lokal.
  Future<bool> deleteSchedule(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await WorkoutService.deleteSchedule(id);

      _schedules = _schedules.where((schedule) => schedule.id != id).toList();

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
