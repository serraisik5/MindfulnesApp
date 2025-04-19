import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:minder_frontend/models/user_model.dart';

class AuthResponse {
  final UserModel user;
  final String accessToken;
  final String refreshToken;

  AuthResponse({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });
}

class AuthService {
  static const _baseUrl = 'http://localhost:8000/api'; // Replace this
  static const _storage = FlutterSecureStorage();

  static Future<AuthResponse?> register(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/user/create/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final decoded = jsonDecode(response.body);

      final user = UserModel.fromJson(decoded['user']);
      final access = decoded['access'];
      final refresh = decoded['refresh'];

      // Save tokens securely
      await _storage.write(key: 'access', value: access);
      await _storage.write(key: 'refresh', value: refresh);

      return AuthResponse(
          user: user, accessToken: access, refreshToken: refresh);
    }

    return null;
  }

  static Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/token/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final tokens = jsonDecode(response.body);
      await _storage.write(key: 'access', value: tokens['access']);
      await _storage.write(key: 'refresh', value: tokens['refresh']);
      print('Login success: ${response.body}');
      return true;
    }

    return false;
  }

  static Future<void> logout() async {
    await _storage.deleteAll();
  }

  static Future<String?> getAccessToken() async {
    return await _storage.read(key: 'access');
  }
}
