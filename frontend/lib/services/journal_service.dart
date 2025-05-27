// lib/services/journal_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:minder_frontend/models/journal_entry_model.dart';
import 'package:minder_frontend/services/auth_service.dart';

class JournalService {
  static const _baseUrl = 'http://localhost:8000/api';

  /// Creates a new journal entry.
  static Future<JournalEntryModel> createEntry(String text) async {
    final token = await AuthService.getAccessToken();
    final resp = await http.post(
      Uri.parse('$_baseUrl/journal/create/'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'entry': text}),
    );
    if (resp.statusCode == 201 || resp.statusCode == 200) {
      final data = jsonDecode(resp.body);
      return JournalEntryModel.fromJson(data);
    }
    throw Exception('Failed to create journal (${resp.statusCode})');
  }

  /// Fetches all user journal entries.
  static Future<List<JournalEntryModel>> fetchEntries() async {
    final token = await AuthService.getAccessToken();
    final resp = await http.get(
      Uri.parse('$_baseUrl/journal/'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
    if (resp.statusCode == 200) {
      final List decoded = jsonDecode(resp.body) as List;
      return decoded.map((e) => JournalEntryModel.fromJson(e)).toList();
    }
    throw Exception('Failed to load journals (${resp.statusCode})');
  }
}
