// lib/modules/profile/views/widgets/favorite_list_section.dart
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:minder_frontend/modules/start%20meditation/controllers/favorite_controller.dart';
import 'package:minder_frontend/services/audio_service.dart';

class FavoriteListSection extends StatelessWidget {
  FavoriteListSection({super.key});

  // Get the controller that should already be initialized by the parent
  final ctl = Get.find<FavoriteController>();

  Future<bool> _testAudioUrl(String url) async {
    try {
      final response = await http.head(Uri.parse(url));
      print("Audio URL test - Status: ${response.statusCode}");
      return response.statusCode == 200;
    } catch (e) {
      print("Audio URL test failed: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (ctl.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (ctl.errorMessage.value != null) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(ctl.errorMessage.value!),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ctl.loadFavorites(),
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      }
      if (ctl.favorites.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('No favorites yet.'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ctl.loadFavorites(),
                child: const Text('Refresh'),
              ),
            ],
          ),
        );
      }
      return RefreshIndicator(
        onRefresh: () async {
          await ctl.loadFavorites();
        },
        child: ListView.separated(
          shrinkWrap: true, // <-- important
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: ctl.favorites.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, idx) {
            final s = ctl.favorites[idx];
            return ListTile(
              title: Text(s.title),
              subtitle: Text(
                '${s.duration} min • ${s.voice} • ${s.backgroundNoise}',
              ),
              trailing: Icon(Icons.play_arrow),
              onTap: () async {
                if (s.audioUrl.isNotEmpty == true) {
                  print("Testing audio URL: ${s.audioUrl}");

                  // Test if the URL is accessible
                  final isAccessible = await _testAudioUrl(s.audioUrl);
                  if (!isAccessible) {
                    print("Warning: Audio URL is not accessible!");
                    Get.snackbar(
                      "Error",
                      "Audio file not accessible. Please try again later.",
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    return;
                  }

                  // Ensure audio operations are performed on the main thread
                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    print("Playing audio URL: ${s.audioUrl}");
                    MyAudioHandler().playFromUrl(s.audioUrl);
                  });
                }
                print("selen isepmty");
              },
            );
          },
        ),
      );
    });
  }
}
