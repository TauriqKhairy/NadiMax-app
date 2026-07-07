import 'package:flutter/material.dart';
import '../models/device_model.dart';
import '../services/api_service.dart';
import '../services/device_service.dart';

class DeviceProvider extends ChangeNotifier {
  List<DeviceModel> _devices = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<DeviceModel> get devices => _devices;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Ambil semua device milik user.
  Future<void> fetchDevices() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _devices = await DeviceService.getDevices();
      _isLoading = false;
      notifyListeners();
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Registrasikan device baru, otomatis tambahkan ke list lokal.
  Future<bool> registerDevice({
    required String deviceName,
    required String deviceCode,
    String? deviceType,
    String? firmwareVersion,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newDevice = await DeviceService.registerDevice(
        deviceName: deviceName,
        deviceCode: deviceCode,
        deviceType: deviceType,
        firmwareVersion: firmwareVersion,
      );

      _devices = [..._devices, newDevice];
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
