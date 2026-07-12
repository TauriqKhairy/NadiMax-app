import '../models/user_model.dart';
import '../models/device_model.dart';
import '../models/heart_rate_model.dart';
import '../models/workout_schedule_model.dart';
import '../models/subscription_model.dart';

/// Kumpulan data dummy untuk Mode Demo (presentasi tanpa koneksi ke server).
class MockData {
  // ==========================================================
  // USER & SUBSCRIPTION
  // ==========================================================
  static SubscriptionModel subscription = SubscriptionModel(
    id: 'demo-sub-001',
    plan: 'free',
    startedAt: '2026-07-01T08:00:00+00:00',
    expiredAt: null,
    isActive: true,
    isValid: true,
  );

  static UserModel user = UserModel(
    id: 'demo-user-001',
    name: 'Tauriq Khairy',
    email: 'tauriq@nadimax.com',
    age: 21,
    height: 170,
    weight: 65,
    gender: 'male',
    activeSubscription: subscription,
    createdAt: '2026-07-01T08:00:00+00:00',
  );

  static const String dummyToken = 'demo-token-static-12345';

  // ==========================================================
  // DEVICES
  // ==========================================================
  static List<DeviceModel> devices = [
    DeviceModel(
      id: 'demo-device-001',
      deviceName: 'ESP32 NadiMax #1',
      deviceCode: 'AA:BB:CC:DD:EE:01',
      deviceType: 'ESP32-MAX30102',
      firmwareVersion: '1.0.2',
      isActive: true,
      lastConnectedAt: '2026-07-12T14:30:00+00:00',
      createdAt: '2026-07-01T08:00:00+00:00',
    ),
    DeviceModel(
      id: 'demo-device-002',
      deviceName: 'ESP32 NadiMax #2 (Cadangan)',
      deviceCode: 'AA:BB:CC:DD:EE:02',
      deviceType: 'ESP32-MAX30102',
      firmwareVersion: '1.0.2',
      isActive: true,
      lastConnectedAt: '2026-07-10T09:15:00+00:00',
      createdAt: '2026-07-03T08:00:00+00:00',
    ),
  ];

  // ==========================================================
  // HEART RATE HISTORY (15 data, biar grafik keliatan bagus)
  // ==========================================================
  static List<HeartRateModel> heartRateHistory = [
    HeartRateModel(
      id: 'hr-015',
      deviceId: 'demo-device-001',
      deviceName: 'ESP32 NadiMax #1',
      bpm: 78,
      spo2: 98,
      measuredAt: '2026-07-12T14:30:00+00:00',
    ),
    HeartRateModel(
      id: 'hr-014',
      deviceId: 'demo-device-001',
      deviceName: 'ESP32 NadiMax #1',
      bpm: 82,
      spo2: 97,
      measuredAt: '2026-07-12T12:15:00+00:00',
    ),
    HeartRateModel(
      id: 'hr-013',
      deviceId: 'demo-device-001',
      deviceName: 'ESP32 NadiMax #1',
      bpm: 95,
      spo2: 97,
      measuredAt: '2026-07-12T09:00:00+00:00',
    ),
    HeartRateModel(
      id: 'hr-012',
      deviceId: 'demo-device-001',
      deviceName: 'ESP32 NadiMax #1',
      bpm: 135,
      spo2: 96,
      measuredAt: '2026-07-11T17:45:00+00:00',
    ),
    HeartRateModel(
      id: 'hr-011',
      deviceId: 'demo-device-001',
      deviceName: 'ESP32 NadiMax #1',
      bpm: 142,
      spo2: 95,
      measuredAt: '2026-07-11T17:30:00+00:00',
    ),
    HeartRateModel(
      id: 'hr-010',
      deviceId: 'demo-device-001',
      deviceName: 'ESP32 NadiMax #1',
      bpm: 128,
      spo2: 96,
      measuredAt: '2026-07-11T17:15:00+00:00',
    ),
    HeartRateModel(
      id: 'hr-009',
      deviceId: 'demo-device-001',
      deviceName: 'ESP32 NadiMax #1',
      bpm: 88,
      spo2: 98,
      measuredAt: '2026-07-11T08:00:00+00:00',
    ),
    HeartRateModel(
      id: 'hr-008',
      deviceId: 'demo-device-001',
      deviceName: 'ESP32 NadiMax #1',
      bpm: 75,
      spo2: 98,
      measuredAt: '2026-07-10T22:00:00+00:00',
    ),
    HeartRateModel(
      id: 'hr-007',
      deviceId: 'demo-device-001',
      deviceName: 'ESP32 NadiMax #1',
      bpm: 80,
      spo2: 97,
      measuredAt: '2026-07-10T14:20:00+00:00',
    ),
    HeartRateModel(
      id: 'hr-006',
      deviceId: 'demo-device-001',
      deviceName: 'ESP32 NadiMax #1',
      bpm: 110,
      spo2: 97,
      measuredAt: '2026-07-10T07:30:00+00:00',
    ),
    HeartRateModel(
      id: 'hr-005',
      deviceId: 'demo-device-001',
      deviceName: 'ESP32 NadiMax #1',
      bpm: 150,
      spo2: 94,
      measuredAt: '2026-07-09T18:00:00+00:00',
    ),
    HeartRateModel(
      id: 'hr-004',
      deviceId: 'demo-device-001',
      deviceName: 'ESP32 NadiMax #1',
      bpm: 92,
      spo2: 97,
      measuredAt: '2026-07-09T09:10:00+00:00',
    ),
    HeartRateModel(
      id: 'hr-003',
      deviceId: 'demo-device-001',
      deviceName: 'ESP32 NadiMax #1',
      bpm: 76,
      spo2: 98,
      measuredAt: '2026-07-08T21:00:00+00:00',
    ),
    HeartRateModel(
      id: 'hr-002',
      deviceId: 'demo-device-001',
      deviceName: 'ESP32 NadiMax #1',
      bpm: 84,
      spo2: 98,
      measuredAt: '2026-07-08T13:00:00+00:00',
    ),
    HeartRateModel(
      id: 'hr-001',
      deviceId: 'demo-device-001',
      deviceName: 'ESP32 NadiMax #1',
      bpm: 72,
      spo2: 99,
      measuredAt: '2026-07-08T07:00:00+00:00',
    ),
  ];

  static HeartRateModel get latestHeartRate => heartRateHistory.first;

  // ==========================================================
  // WORKOUT SCHEDULES
  // ==========================================================
  static List<WorkoutScheduleModel> workoutSchedules = [
    WorkoutScheduleModel(
      id: 'demo-workout-001',
      title: 'Lari Pagi',
      scheduleDate: '2026-07-13',
      startTime: '06:00:00',
      endTime: '06:45:00',
      trainingZone: 'cardio',
      notes: 'Lari keliling komplek, target 5K',
      isCompleted: false,
      createdAt: '2026-07-10T08:00:00+00:00',
    ),
    WorkoutScheduleModel(
      id: 'demo-workout-002',
      title: 'Latihan Beban',
      scheduleDate: '2026-07-11',
      startTime: '17:00:00',
      endTime: '18:00:00',
      trainingZone: 'fat_burn',
      notes: 'Fokus upper body',
      isCompleted: true,
      createdAt: '2026-07-09T08:00:00+00:00',
    ),
    WorkoutScheduleModel(
      id: 'demo-workout-003',
      title: 'HIIT Session',
      scheduleDate: '2026-07-14',
      startTime: '16:30:00',
      endTime: '17:00:00',
      trainingZone: 'peak',
      notes: 'Interval training 30 detik on/off',
      isCompleted: false,
      createdAt: '2026-07-11T08:00:00+00:00',
    ),
  ];

  // ==========================================================
  // ANALYTICS (HR Max & Training Zones, dihitung dari age = 21)
  // ==========================================================
  static Map<String, dynamic> trainingZones = {
    'hr_max': 199, // 220 - 21
    'zones': {
      'recovery': {
        'label': 'Recovery',
        'min_bpm': 100,
        'max_bpm': 119,
        'min_percent': 50,
        'max_percent': 60,
      },
      'fat_burn': {
        'label': 'Fat Burn',
        'min_bpm': 120,
        'max_bpm': 139,
        'min_percent': 60,
        'max_percent': 70,
      },
      'cardio': {
        'label': 'Cardio',
        'min_bpm': 140,
        'max_bpm': 159,
        'min_percent': 70,
        'max_percent': 80,
      },
      'peak': {
        'label': 'Peak',
        'min_bpm': 160,
        'max_bpm': 179,
        'min_percent': 80,
        'max_percent': 90,
      },
      'maximum': {
        'label': 'Maximum',
        'min_bpm': 180,
        'max_bpm': 199,
        'min_percent': 90,
        'max_percent': 100,
      },
    },
  };
}
