import 'dart:convert';

import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:minder_frontend/models/user_model.dart';
import 'package:minder_frontend/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserStorage {
  static Future<void> saveUserLocally(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', jsonEncode(user.toJson()));
    print(user.toString());
  }

  static Future<UserModel?> getUserFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      return UserModel.fromJson(jsonDecode(userJson));
    }
    return null;
  }
}
