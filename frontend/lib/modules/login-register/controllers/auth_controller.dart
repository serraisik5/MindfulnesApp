import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:convert';

import 'package:minder_frontend/models/user_model.dart';
import 'package:minder_frontend/modules/base/views/base_view.dart';
import 'package:minder_frontend/modules/login-register/views/login_view.dart';
import 'package:minder_frontend/services/auth_service.dart';
import 'package:minder_frontend/services/user_storage.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  var isLoggedIn = false.obs;
  var accessToken = ''.obs;
  var refreshToken = ''.obs;
  UserModel? currentUser;

  Future<void> register(UserModel user) async {
    isLoading.value = true;

    final response = await AuthService.register(user.toRegisterJson());

    isLoading.value = false;

    if (response != null) {
      accessToken.value = response.accessToken;
      refreshToken.value = response.refreshToken;
      currentUser = response.user;
      isLoggedIn.value = true;
      update();

      await UserStorage.saveUserLocally(currentUser!);

      Get.offAll(() => const BaseView());
    } else {
      Get.snackbar("Error", "Registration failed.");
    }
  }

  Future<void> login(String email, String password) async {
    isLoading.value = true;

    final response = await AuthService.login(email, password);

    isLoading.value = false;

    if (response != null) {
      accessToken.value = response.accessToken;
      refreshToken.value = response.refreshToken;
      currentUser = response.user;
      isLoggedIn.value = true;
      update();

      print(currentUser?.firstName ?? "nul123");

      await UserStorage.saveUserLocally(currentUser!);

      Get.offAll(() => const BaseView());
    } else {
      Get.snackbar("Login Failed", "Invalid credentials or server error.");
    }
  }

  Future<void> logout() async {
    await AuthService.logout();
    isLoggedIn.value = false;
    accessToken.value = '';
    refreshToken.value = '';
    currentUser = null;
    Get.offAll(LoginView());
  }

  Future<void> tryAutoLogin() async {
    final token = await AuthService.getAccessToken();
    if (token != null && !JwtDecoder.isExpired(token)) {
      isLoggedIn.value = true;
      accessToken.value = token;
      //refreshToken.value = await AuthService.getRefreshToken();

      // ← Load the saved user model
      currentUser = await UserStorage.getUserFromStorage();
    } else {
      //await logout();
    }
  }
}
