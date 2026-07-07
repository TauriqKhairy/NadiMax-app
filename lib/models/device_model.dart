class DeviceModel {
  final String id;
  final String deviceName;
  final String deviceCode;
  final String deviceType;
  final String? firmwareVersion;
  final bool isActive;
  final String? lastConnectedAt;
  final String createdAt;

  DeviceModel({
    required this.id,
    required this.deviceName,
    required this.deviceCode,
    required this.deviceType,
    this.firmwareVersion,
    required this.isActive,
    this.lastConnectedAt,
    required this.createdAt,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      id: json['id'],
      deviceName: json['device_name'],
      deviceCode: json['device_code'],
      deviceType: json['device_type'],
      firmwareVersion: json['firmware_version'],
      isActive: json['is_active'],
      lastConnectedAt: json['last_connected_at'],
      createdAt: json['created_at'] ?? '',
    );
  }
}
