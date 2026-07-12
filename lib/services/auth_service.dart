import '../config/api_config.dart';
import '../config/mock_data.dart';
import '../models/user_model.dart';
import 'api_service.dart';

class AuthService {
  /// Register user baru.
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    int? age,
    double? height,
    double? weight,
    String? gender,
  }) async {
    if (ApiConfig.isDemoMode) {
      await Future.delayed(const Duration(milliseconds: 800));
      await ApiService.saveToken(MockData.dummyToken);
      return {'user': MockData.user, 'token': MockData.dummyToken};
    }

    final response = await ApiService.postPublic(ApiConfig.register, {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'age': age,
      'height': height,
      'weight': weight,
      'gender': gender,
    });

    final user = UserModel.fromJson(response['data']['user']);
    final token = response['data']['token'] as String;

    await ApiService.saveToken(token);

    return {'user': user, 'token': token};
  }

  /// Login user.
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    if (ApiConfig.isDemoMode) {
      await Future.delayed(const Duration(milliseconds: 800));
      await ApiService.saveToken(MockData.dummyToken);
      return {'user': MockData.user, 'token': MockData.dummyToken};
    }

    final response = await ApiService.postPublic(ApiConfig.login, {
      'email': email,
      'password': password,
    });

    final user = UserModel.fromJson(response['data']['user']);
    final token = response['data']['token'] as String;

    await ApiService.saveToken(token);

    return {'user': user, 'token': token};
  }

  /// Logout user.
  static Future<void> logout() async {
    if (ApiConfig.isDemoMode) {
      await ApiService.clearToken();
      return;
    }

    await ApiService.post(ApiConfig.logout, {});
    await ApiService.clearToken();
  }

  /// Ambil data user yang sedang login.
  static Future<UserModel> getMe() async {
    if (ApiConfig.isDemoMode) {
      await Future.delayed(const Duration(milliseconds: 300));
      return MockData.user;
    }

    final response = await ApiService.get(ApiConfig.me);

    return UserModel.fromJson(response['data']);
  }

  /// Cek apakah user sudah pernah login (ada token tersimpan).
  static Future<bool> isLoggedIn() async {
    final token = await ApiService.getToken();
    return token != null;
  }
}
