import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:minder_frontend/helpers/constants/colors.dart';
import 'package:minder_frontend/helpers/styles/text_style.dart';
import 'package:minder_frontend/modules/login-register/controllers/auth_controller.dart';
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
            Text(
              "Your favorite sessions will be displayed here",
              style: AppTextStyles.lightheading,
            ),
          ],
        ),
      ),
    );
  }
}
