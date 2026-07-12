class ApiConfig {
  // ==========================================================
  // MODE DEMO — set true kalau mau pakai data dummy (offline),
  // set false untuk connect ke Laravel API beneran.
  // ==========================================================
  static const bool isDemoMode = true;
  // IP address PC (WiFi) — pastikan HP & PC terhubung ke WiFi yang sama
  static const String baseUrl = 'http://192.168.100.118:8000/api';

  // Endpoints - Auth
  static const String register = '$baseUrl/auth/register';
  static const String login = '$baseUrl/auth/login';
  static const String logout = '$baseUrl/auth/logout';
  static const String me = '$baseUrl/auth/me';

  // Endpoints - Profile
  static const String profile = '$baseUrl/profile';

  // Endpoints - Device
  static const String devices = '$baseUrl/devices';

  // Endpoints - Heart Rate
  static const String heartRates = '$baseUrl/heart-rates';
  static const String heartRateHistory = '$baseUrl/heart-rates/history';
  static const String heartRateLatest = '$baseUrl/heart-rates/latest';

  // Endpoints - Analytics
  static const String trainingZones = '$baseUrl/analytics/training-zones';
  static const String detectZone = '$baseUrl/analytics/detect-zone';

  // Endpoints - Workout Schedule
  static const String workoutSchedules = '$baseUrl/workout-schedules';

  // Endpoints - Subscription
  static const String subscription = '$baseUrl/subscription';
  static const String subscriptionUpgrade = '$baseUrl/subscription/upgrade';
  static const String subscriptionDowngrade = '$baseUrl/subscription/downgrade';
}
