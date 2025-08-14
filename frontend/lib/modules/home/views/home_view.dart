// lib/modules/home/views/home_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minder_frontend/helpers/constants/colors.dart';
import 'package:minder_frontend/helpers/constants/images.dart';
import 'package:minder_frontend/helpers/constants/strings.dart';
import 'package:minder_frontend/helpers/styles/text_style.dart';
import 'package:minder_frontend/modules/home/views/widgets/course_card.dart';
import 'package:minder_frontend/modules/login-register/controllers/auth_controller.dart';
import 'package:minder_frontend/modules/start meditation/controllers/meditation_session_controller.dart';
import 'package:minder_frontend/modules/start meditation/views/player_view.dart';
import 'package:minder_frontend/widgets/custom_app_bar.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final authController = Get.find<AuthController>();
  final sessionController = Get.find<MeditationSessionController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackground,
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              final firstName =
                  authController.currentUser.value?.firstName ?? 'Guest';
              return Text(
                '$GOOD_MORNING, ${firstName.capitalizeFirst}',
                style: AppTextStyles.heading,
              );
            }),
            const SizedBox(height: 10),
            Text(
              HOME_WISH,
              style: AppTextStyles.lightheading,
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 1),
                CourseCard(
                  backgroundColor: const Color.fromARGB(255, 118, 116, 236),
                  image: Image.asset(HOME_HEART),
                  imageSize: 120,
                  title: BASICS,
                  subtitle: FOR_BEGINNERS,
                  duration: RANGE_8_10_MIN,
                  onTap: () async {
                    await sessionController.startSession(
                      "relaxation",
                      7,
                      "just starting the meditation",
                    );
                    Get.to(() => const PlayerView());
                  },
                ),
                CourseCard(
                  backgroundColor: const Color.fromARGB(255, 174, 142, 169),
                  image: Image.asset(HOME_OWELS),
                  imageSize: 140,
                  title: SLEEP,
                  subtitle: RELAXATION,
                  duration: RANGE_3_5_MIN,
                  onTap: () async {
                    await sessionController.startSession(
                      "better sleep",
                      4,
                      "wants to start sleep",
                    );
                    Get.to(() => const PlayerView());
                  },
                ),
                const SizedBox(width: 1),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
