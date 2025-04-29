// lib/modules/start meditation/controllers/favorite_controller.dart
import 'package:get/get.dart';
import 'package:minder_frontend/services/favorite_service.dart';

class FavoriteController extends GetxController {
  final favorites = <int>{}.obs; // set of session IDs

  /// Toggle: if not in favorites, call API and add; otherwise remove locally.
  Future<void> toggle(int sessionId) async {
    if (favorites.contains(sessionId)) {
      // optional: call an API to remove favorite if you have one
      favorites.remove(sessionId);
    } else {
      try {
        final created = await FavoriteService.addFavorite(sessionId);
        if (created) {
          favorites.add(sessionId);
          Get.snackbar('Favorited', 'Session added to favorites');
        } else {
          favorites.add(sessionId);
          Get.snackbar('Already favorited',
              'This session was already in your favorites');
        }
      } catch (e) {
        Get.snackbar('Error', 'Could not add favorite');
      }
    }
  }

  bool isFav(int sessionId) => favorites.contains(sessionId);
}
