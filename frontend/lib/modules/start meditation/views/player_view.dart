import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minder_frontend/helpers/constants/colors.dart';
import 'package:minder_frontend/helpers/constants/images.dart';
import 'package:minder_frontend/helpers/styles/text_style.dart';
import 'package:minder_frontend/modules/start%20meditation/controllers/favorite_controller.dart';
import 'package:minder_frontend/modules/start%20meditation/widgets/audio_seek_bar.dart';
import 'package:minder_frontend/widgets/buttons/close_button.dart';
import 'package:minder_frontend/widgets/buttons/favorite_button.dart';
import 'package:minder_frontend/widgets/custom_play_button.dart';

class PlayerView extends StatefulWidget {
  const PlayerView({super.key});

  @override
  State<PlayerView> createState() => _PlayerViewState();
}

class _PlayerViewState extends State<PlayerView> {
  final favCtl = Get.put(FavoriteController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: appSecondary,
        body: Stack(
          children: [
            Positioned(
                top: -15,
                left: -10,
                width: 200,
                child: Image.asset(
                  PLAYER_ELLIPSE,
                )),
            Positioned(
                top: 0,
                right: 0,
                width: 200,
                child: Image.asset(
                  PLAYER_VECTOR,
                )),
            Positioned(
              bottom: -15,
              right: -20,
              width: 200,
              child: Transform.rotate(
                angle: 1.4, // 180 degrees (PI radians)
                child: Image.asset(
                  PLAYER_ELLIPSE,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: -15,
              left: -20,
              width: 200,
              child: Transform.rotate(
                angle: 3.14, // 180 degrees (PI radians)
                child: Image.asset(
                  PLAYER_VECTOR,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
                top: 60,
                left: 35,
                child: Column(
                  children: [
                    Row(
                      children: [
                        CustomFavoriteButton(
                          size: 40,
                          iconColor:
                              favCtl.isFav(1) ? Colors.red : Colors.black,
                          onPressed: () => favCtl.toggle(1),
                        ),
                        SizedBox(
                          width: 250,
                        ),
                        CustomCloseButton(),
                      ],
                    )
                  ],
                )),
            Positioned(
                bottom: 150,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Text(
                      "Focus Attention",
                      style: AppTextStyles.heading,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "7 days of calm",
                      style: AppTextStyles.lightheading,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    CustomPlayPauseButton(size: 80),
                    SizedBox(
                      height: 40,
                    ),
                    AudioSeekBar()
                  ],
                ))
          ],
        ));
  }
}
