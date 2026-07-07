import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _user != null;

  /// Cek status login saat app pertama kali dibuka (dipanggil dari Splash Screen).
  Future<bool> checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      final hasToken = await AuthService.isLoggedIn();

      if (!hasToken) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      _user = await AuthService.getMe();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      // Token invalid/expired, hapus token yang tersimpan
      await ApiService.clearToken();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Register user baru.
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    int? age,
    double? height,
    double? weight,
    String? gender,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await AuthService.register(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        age: age,
        height: height,
        weight: weight,
        gender: gender,
      );

      _user = result['user'];
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

  /// Login user.
  Future<bool> login({required String email, required String password}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await AuthService.login(email: email, password: password);

      _user = result['user'];
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

  /// Logout user.
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await AuthService.logout();
    } catch (e) {
      // Tetap lanjut clear data lokal walau request logout ke server gagal
      // (misal karena tidak ada koneksi internet)
    }

    _user = null;
    _isLoading = false;
    notifyListeners();
  }

  /// Update data user secara lokal (dipanggil setelah update profile berhasil).
  void updateUserData(UserModel updatedUser) {
    _user = updatedUser;
    notifyListeners();
  }

  /// Bersihkan pesan error (dipanggil sebelum submit form baru).
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
