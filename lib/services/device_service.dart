import '../config/api_config.dart';
import '../models/device_model.dart';
import 'api_service.dart';

class DeviceService {
  /// Ambil semua device milik user yang sedang login.
  static Future<List<DeviceModel>> getDevices() async {
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
    final response = await ApiService.get('${ApiConfig.devices}/$deviceId');

    return DeviceModel.fromJson(response['data']);
  }

  /// Update informasi device.
  static Future<DeviceModel> updateDevice(
    String deviceId,
    Map<String, dynamic> data,
  ) async {
    final response = await ApiService.put(
      '${ApiConfig.devices}/$deviceId',
      data,
    );

    return DeviceModel.fromJson(response['data']);
  }
}
