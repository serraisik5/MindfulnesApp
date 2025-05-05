// lib/services/favorite_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:minder_frontend/models/meditation_session_model.dart';
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

  static Future<List<MeditationSessionModel>> fetchFavorites() async {
    final token = await AuthService.getAccessToken();
    final resp = await http.get(
      Uri.parse('$_baseUrl/sessions/favorites/'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
    if (resp.statusCode == 200) {
      final List decoded = jsonDecode(resp.body) as List;
      return decoded
          .map(
              (e) => MeditationSessionModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception('Failed to load favorites (${resp.statusCode})');
  }

  /// Remove a favorite
  static Future<void> removeFavorite(int sessionId) async {
    final token = await AuthService.getAccessToken();
    final resp = await http.delete(
      Uri.parse('$_baseUrl/sessions/favorite/remove/'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'session_id': sessionId}),
    );
    if (resp.statusCode != 200) {
      throw Exception('Failed to remove favorite (${resp.statusCode})');
    }
  }
}
