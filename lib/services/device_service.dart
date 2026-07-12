import '../config/api_config.dart';
import '../config/mock_data.dart';
import '../models/device_model.dart';
import 'api_service.dart';

class DeviceService {
  /// Ambil semua device milik user yang sedang login.
  static Future<List<DeviceModel>> getDevices() async {
    if (ApiConfig.isDemoMode) {
      await Future.delayed(const Duration(milliseconds: 500));
      return MockData.devices;
    }

    final response = await ApiService.get(ApiConfig.devices);

    final List<dynamic> data = response['data'];
    return data.map((json) => DeviceModel.fromJson(json)).toList();
  }

  /// Registrasikan device ESP32 baru.
  static Future<DeviceModel> registerDevice({
    required String deviceName,
    required String deviceCode,
    String? deviceType,
    String? firmwareVersion,
  }) async {
    if (ApiConfig.isDemoMode) {
      await Future.delayed(const Duration(milliseconds: 600));
      final newDevice = DeviceModel(
        id: 'demo-device-${MockData.devices.length + 1}',
        deviceName: deviceName,
        deviceCode: deviceCode,
        deviceType: deviceType ?? 'ESP32-MAX30102',
        firmwareVersion: firmwareVersion,
        isActive: true,
        lastConnectedAt: null,
        createdAt: DateTime.now().toIso8601String(),
      );
      MockData.devices = [...MockData.devices, newDevice];
      return newDevice;
    }

    final response = await ApiService.post(ApiConfig.devices, {
      'device_name': deviceName,
      'device_code': deviceCode,
      'device_type': deviceType,
      'firmware_version': firmwareVersion,
    });

    return DeviceModel.fromJson(response['data']);
  }

  /// Ambil detail 1 device.
  static Future<DeviceModel> getDeviceDetail(String deviceId) async {
    if (ApiConfig.isDemoMode) {
      await Future.delayed(const Duration(milliseconds: 300));
      return MockData.devices.firstWhere((d) => d.id == deviceId);
    }

    final response = await ApiService.get('${ApiConfig.devices}/$deviceId');

    return DeviceModel.fromJson(response['data']);
  }

  /// Update informasi device.
  static Future<DeviceModel> updateDevice(
    String deviceId,
    Map<String, dynamic> data,
  ) async {
    if (ApiConfig.isDemoMode) {
      await Future.delayed(const Duration(milliseconds: 500));
      return MockData.devices.firstWhere((d) => d.id == deviceId);
    }

    final response = await ApiService.put(
      '${ApiConfig.devices}/$deviceId',
      data,
    );

    return DeviceModel.fromJson(response['data']);
  }
}
