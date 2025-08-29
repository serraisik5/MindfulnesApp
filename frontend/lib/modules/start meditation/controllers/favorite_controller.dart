// lib/modules/start_meditation/controllers/favorite_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minder_frontend/models/meditation_session_model.dart';
import 'package:minder_frontend/modules/login-register/controllers/auth_controller.dart';
import 'package:minder_frontend/modules/login-register/views/login_view.dart';
import 'package:minder_frontend/services/favorite_service.dart';

class FavoriteController extends GetxController {
  /// Reactive list of favorited sessions
  final favorites = <MeditationSessionModel>[].obs;

  /// Loading / error states for the list fetch
  final isLoading = false.obs;
  final errorMessage = RxnString();

  final _authCtrl = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  /// Loads the user’s favorite sessions from the backend
  Future<void> loadFavorites() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;
      final list = await FavoriteService.fetchFavorites();
      favorites.value = list;
      print(list);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// Returns true if the given session ID is currently in favorites
  bool isFav(int sessionId) {
    return favorites.any((s) => s.id == sessionId);
  }

  /// Toggles favorite status for a session. If it's already favorited,
  /// calls removeFavorite, otherwise calls addFavorite. Then updates `favorites`.
  Future<void> toggle(MeditationSessionModel? session) async {
    print(session);
    if (session != null) {
      final already = isFav(session.id);

      try {
        if (already) {
          await FavoriteService.removeFavorite(session.id);
          // Refresh the entire list from backend to ensure consistency
          await loadFavorites();
          Get.snackbar("Removed", "Session removed from favorites");
        } else {
          print("selen false");
          await FavoriteService.addFavorite(session.id);
          // Refresh the entire list from backend to ensure consistency
          await loadFavorites();
          Get.snackbar("Favorited", "Session added to favorites");
        }
      } catch (e) {
        print("Error in toggle: $e");

        final isGuest =
            !_authCtrl.isLoggedIn.value || _authCtrl.currentUser.value == null;

        !isGuest
            ? Get.snackbar(
                "Error", "Could not ${already ? 'remove' : 'add'} favorite")
            : Get.snackbar(
                "Error",
                "You need to log in to add favorite",
                duration: const Duration(seconds: 4),
                mainButton: isGuest
                    ? TextButton(
                        onPressed: () {
                          Get.to(LoginView()); // Or: Get.to(() => LoginView());
                        },
                        child: const Text("Log in",
                            style: TextStyle(color: Colors.black)),
                      )
                    : null,
              );
      }
    }
  }
}
