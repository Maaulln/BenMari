import 'package:http/http.dart' as http;
import 'dart:convert';

const String apiBaseUrl = 'http://localhost:3000';

// For Android emulator
const String apiBaseUrlAndroid = 'http://10.0.2.2:3000';

String getApiBaseUrl() {
  // This can be overridden with dart-define: flutter run -d emulator-5554 --dart-define=API_BASE_URL=http://10.0.2.2:3000
  return const String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: apiBaseUrl,
  );
}

class LoginResponse {
  final bool success;
  final String? message;
  final String? token;
  final Map<String, dynamic>? user;

  LoginResponse({
    required this.success,
    this.message,
    this.token,
    this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] ?? false,
      message: json['message'],
      token: json['token'],
      user: json['user'] as Map<String, dynamic>?,
    );
  }
}

class AuthApi {
  static const Duration _timeout = Duration(seconds: 30);

  /// Login as Pasien (Patient)
  static Future<LoginResponse> loginPasien({
    required String email,
    required String password,
  }) async {
    return _login('/api/auth/login-pasien', email, password);
  }

  /// Login as Dokter (Doctor)
  static Future<LoginResponse> loginDokter({
    required String email,
    required String password,
  }) async {
    return _login('/api/auth/login-dokter', email, password);
  }

  /// Login as Admin
  static Future<LoginResponse> loginAdmin({
    required String email,
    required String password,
  }) async {
    return _login('/api/auth/login-admin', email, password);
  }

  /// Verify JWT token
  static Future<LoginResponse> verifyToken(String token) async {
    try {
      final baseUrl = getApiBaseUrl();
      final url = Uri.parse('$baseUrl/api/auth/verify');

      final response = await http
          .get(
            url,
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          )
          .timeout(_timeout);

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return LoginResponse.fromJson(json);
    } catch (e) {
      return LoginResponse(
        success: false,
        message: 'Gagal memverifikasi token: $e',
      );
    }
  }

  // Private method
  static Future<LoginResponse> _login(
    String endpoint,
    String email,
    String password,
  ) async {
    try {
      final baseUrl = getApiBaseUrl();
      final url = Uri.parse('$baseUrl$endpoint');

      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'email': email.trim(),
              'password': password,
            }),
          )
          .timeout(_timeout);

      if (response.statusCode == 200 || response.statusCode == 401) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return LoginResponse.fromJson(json);
      } else {
        return LoginResponse(
          success: false,
          message: 'Server error: ${response.statusCode}',
        );
      }
    } catch (e) {
      return LoginResponse(
        success: false,
        message: 'Koneksi error: $e',
      );
    }
  }
}
