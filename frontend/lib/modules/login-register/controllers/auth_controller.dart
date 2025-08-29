import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:convert';

import 'package:minder_frontend/models/user_model.dart';
import 'package:minder_frontend/modules/base/views/base_view.dart';
import 'package:minder_frontend/modules/login-register/views/login_view.dart';
import 'package:minder_frontend/modules/start%20meditation/controllers/favorite_controller.dart';
import 'package:minder_frontend/modules/start%20meditation/controllers/journal_controller.dart';
import 'package:minder_frontend/services/auth_service.dart';
import 'package:minder_frontend/services/user_storage.dart';

class AuthController extends GetxController {
  final isLoading = false.obs;
  final isLoggedIn = false.obs;
  final accessToken = ''.obs;
  final refreshToken = ''.obs;
  final currentUser = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
    tryAutoLogin();
  }

  Future<bool> tryAutoLogin() async {
    isLoading.value = true;

    final token = await AuthService.getAccessToken();
    if (token != null && !JwtDecoder.isExpired(token)) {
      accessToken.value = token;
      final stored = await UserStorage.getUserFromStorage();
      if (stored != null) {
        currentUser.value = stored;
        isLoggedIn.value = true;
        isLoading.value = false;
        return true;
      }
    }
    isLoading.value = false;
    return false;
  }

  Future<void> login(String email, String pw) async {
    isLoading.value = true;
    final resp = await AuthService.login(email, pw);
    isLoading.value = false;

    if (resp != null) {
      accessToken.value = resp.accessToken;
      refreshToken.value = resp.refreshToken;
      currentUser.value = resp.user;
      isLoggedIn.value = true;

      await UserStorage.saveUserLocally(resp.user);
      Get.find<FavoriteController>().loadFavorites();
      Get.find<JournalController>().loadEntries();
      Get.offAll(() => const BaseView());
    } else {
      Get.snackbar('Error', 'Login failed');
    }
  }

  Future<void> register(UserModel user) async {
    isLoading.value = true;

    final response = await AuthService.register(user.toRegisterJson());

    isLoading.value = false;

    if (response != null) {
      accessToken.value = response.accessToken;
      refreshToken.value = response.refreshToken;
      currentUser.value = response.user;
      isLoggedIn.value = true;
      update();

      await UserStorage.saveUserLocally(currentUser.value!);

      Get.offAll(() => BaseView());
    } else {
      Get.snackbar("Error", "Registration failed.");
    }
  }

  // Future<void> login(String email, String password) async {
  //   isLoading.value = true;

  //   final response = await AuthService.login(email, password);

  //   isLoading.value = false;

  //   if (response != null) {
  //     accessToken.value = response.accessToken;
  //     refreshToken.value = response.refreshToken;
  //     currentUser.value = response.user;
  //     isLoggedIn.value = true;
  //     update();

  //     print(currentUser.value?.firstName ?? "nul123");

  //     await UserStorage.saveUserLocally(currentUser.value!);

  //     Get.offAll(() => const BaseView());
  //   } else {
  //     Get.snackbar("Login Failed", "Invalid credentials or server error.");
  //   }
  // }

  Future<void> logout() async {
    await AuthService.logout();
    isLoggedIn.value = false;
    accessToken.value = '';
    refreshToken.value = '';
    currentUser.value = null;
    Get.offAll(LoginView());
  }

  // Future<void> tryAutoLogin() async {
  //   final token = await AuthService.getAccessToken();
  //   if (token != null && !JwtDecoder.isExpired(token)) {
  //     // we’re already logged in
  //     isLoggedIn.value = true;
  //     accessToken.value = token;
  //     // load the saved user
  //     currentUser.value = await UserStorage.getUserFromStorage();
  //   }
  // }
}
