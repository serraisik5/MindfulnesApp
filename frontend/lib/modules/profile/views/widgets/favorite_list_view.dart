// lib/modules/profile/views/widgets/favorite_list_section.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minder_frontend/helpers/constants/colors.dart';
import 'package:minder_frontend/helpers/styles/text_style.dart';
import 'package:minder_frontend/modules/start%20meditation/controllers/favorite_controller.dart';

class FavoriteListSection extends StatelessWidget {
  FavoriteListSection({Key? key}) : super(key: key);

  final favCtl = Get.lazyPut<FavoriteController>(
    () => FavoriteController(),
    fenix: true,
  );
  // then find it for use:
  final ctl = Get.find<FavoriteController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (ctl.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (ctl.errorMessage.value != null) {
        return Center(child: Text(ctl.errorMessage.value!));
      }
      if (ctl.favorites.isEmpty) {
        return const Center(child: Text('No favorites yet.'));
      }
      return ListView.separated(
        shrinkWrap: true, // <-- important
        physics: NeverScrollableScrollPhysics(),
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
            onTap: () {
              if (s.audioUrl?.isNotEmpty == true) {
                // navigate to your player, passing s.audioFile
              }
            },
          );
        },
      );
    });
  }
}
