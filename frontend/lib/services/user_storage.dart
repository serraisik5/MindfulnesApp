import 'dart:convert';

import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:minder_frontend/models/user_model.dart';
import 'package:minder_frontend/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserStorage {
  static const _key = 'stored_user';

  static Future<void> saveUserLocally(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_key, jsonEncode(user.toJson()));
  }

  static Future<UserModel?> getUserFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_key);
    if (data == null) return null;
    final map = jsonDecode(data) as Map<String, dynamic>;
    return UserModel.fromJson(map);
  }
}
