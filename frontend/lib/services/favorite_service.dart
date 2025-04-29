// lib/services/favorite_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:minder_frontend/services/auth_service.dart';

class FavoriteService {
  static const _baseUrl = 'http://localhost:8000/api';

  /// Returns `true` if favorited (created), `false` if already existed.
  static Future<bool> addFavorite(int sessionId) async {
    final token = await AuthService.getAccessToken();
    final resp = await http.post(
      Uri.parse('$_baseUrl/sessions/favorite/add/'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'session_id': sessionId}),
    );
    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body);
      return data['created'] as bool;
    }
    throw Exception('Failed to favorite (${resp.statusCode})');
  }
}
