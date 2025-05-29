import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:minder_frontend/helpers/constants/colors.dart';
import 'package:minder_frontend/helpers/constants/images.dart';
import 'package:minder_frontend/helpers/styles/text_style.dart';
import 'package:minder_frontend/modules/home/views/widgets/course_card.dart';
import 'package:minder_frontend/modules/login-register/controllers/auth_controller.dart';
import 'package:minder_frontend/modules/start%20meditation/controllers/meditation_session_controller.dart';
import 'package:minder_frontend/modules/start%20meditation/views/player_view.dart';
import 'package:minder_frontend/services/audio_service.dart';
import 'package:minder_frontend/services/web_socket_service.dart';
import 'package:minder_frontend/widgets/custom_app_bar.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final authController = Get.find<AuthController>();
  final sessionController = Get.find<MeditationSessionController>();
  String name = "Selen";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackground,
      appBar: CustomAppBar(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              // reactively re-reads currentUser.firstName
              final firstName =
                  authController.currentUser.value?.firstName ?? 'Guest';
              return Text(
                'Good Morning, ${firstName.capitalizeFirst}',
                style: AppTextStyles.heading,
              );
            }),
            SizedBox(height: 10),
            Text(
              "We wish you have a good day",
              style: AppTextStyles.lightheading,
            ),
            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 1,
                ),
                CourseCard(
                  backgroundColor: Color.fromARGB(255, 118, 116, 236),
                  image: Image.asset(HOME_HEART),
                  imageSize: 120,
                  title: 'Basics',
                  subtitle: 'for beginners',
                  duration: '8–10 MIN',
                  onTap: () async => {
                    await sessionController.startSession(
                      "relaxation",
                      7,
                      "just starting the meditation",
                    ),
                    Get.to(() => const PlayerView())
                  },
                ),
                CourseCard(
                  backgroundColor: Color.fromARGB(255, 174, 142, 169),
                  image: Image.asset(HOME_OWELS),
                  imageSize: 140,
                  title: 'Sleep',
                  subtitle: 'Relaxation',
                  duration: '3–5 MIN',
                  onTap: () async => {
                    await sessionController.startSession(
                      "better sleep",
                      4,
                      "wants to start sleep",
                    ),
                    Get.to(() => const PlayerView())
                  },
                ),
                SizedBox(
                  width: 1,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
