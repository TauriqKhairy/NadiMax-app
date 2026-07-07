import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiException implements Exception {
  final String message;
  final Map<String, dynamic>? errors;
  final int statusCode;

  ApiException({required this.message, this.errors, required this.statusCode});

  @override
  String toString() => message;
}

class ApiService {
  /// Ambil token yang tersimpan di local storage HP.
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  /// Simpan token setelah Login/Register berhasil.
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  /// Hapus token saat Logout.
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  /// Header standar untuk request yang butuh token.
  static Future<Map<String, String>> _authHeaders() async {
    final token = await getToken();

    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// Header standar untuk request publik (Register, Login).
  static Map<String, String> _publicHeaders() {
    return {'Content-Type': 'application/json', 'Accept': 'application/json'};
  }

  /// GET request dengan autentikasi.
  static Future<dynamic> get(String url) async {
    final response = await http.get(
      Uri.parse(url),
      headers: await _authHeaders(),
    );

    return _handleResponse(response);
  }

  /// POST request dengan autentikasi.
  static Future<dynamic> post(String url, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse(url),
      headers: await _authHeaders(),
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  /// POST request TANPA autentikasi (buat Register/Login).
  static Future<dynamic> postPublic(
    String url,
    Map<String, dynamic> body,
  ) async {
    final response = await http.post(
      Uri.parse(url),
      headers: _publicHeaders(),
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  /// PUT request dengan autentikasi.
  static Future<dynamic> put(String url, Map<String, dynamic> body) async {
    final response = await http.put(
      Uri.parse(url),
      headers: await _authHeaders(),
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  /// DELETE request dengan autentikasi.
  static Future<dynamic> delete(String url) async {
    final response = await http.delete(
      Uri.parse(url),
      headers: await _authHeaders(),
    );

    return _handleResponse(response);
  }

  /// Proses response dari Laravel, lempar ApiException kalau gagal.
  static dynamic _handleResponse(http.Response response) {
    final decoded = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded;
    }

    throw ApiException(
      message: decoded['message'] ?? 'Terjadi kesalahan.',
      errors: decoded['errors'],
      statusCode: response.statusCode,
    );
  }
}
