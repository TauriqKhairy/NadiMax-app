class HeartRateModel {
  final String id;
  final String deviceId;
  final String? deviceName;
  final int bpm;
  final int? spo2;
  final String measuredAt;

  HeartRateModel({
    required this.id,
    required this.deviceId,
    this.deviceName,
    required this.bpm,
    this.spo2,
    required this.measuredAt,
  });

  factory HeartRateModel.fromJson(Map<String, dynamic> json) {
    return HeartRateModel(
      id: json['id'],
      deviceId: json['device_id'],
      deviceName: json['device_name'],
      bpm: json['bpm'],
      spo2: json['spo2'],
      measuredAt: json['measured_at'],
    );
  }
}
