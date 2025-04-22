import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minder_frontend/modules/base/views/base_view.dart';
import 'package:minder_frontend/modules/home/views/home_view.dart';
import 'package:minder_frontend/modules/login-register/controllers/auth_controller.dart';
import 'package:minder_frontend/modules/login-register/views/login_view.dart';
import 'package:minder_frontend/modules/login-register/views/register_view.dart';
import 'package:minder_frontend/services/audio_service.dart';

MyAudioHandler myAudioHandler = MyAudioHandler();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authController = Get.put(AuthController(), permanent: true);
  await authController.tryAutoLogin();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      log("App Resumed");
    } else if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      log("App Paused");
    } else if (state == AppLifecycleState.detached) {
      // When the app enters the detached state, it is about to be terminated.
      //Any active resources, such as background tasks
      //must be stopped and released to prevent resource leaks and avoid crashes.
      myAudioHandler.stop();
      myAudioHandler.dispose();
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Mindfulness',
      home: LoginView(),
    );
  }
}
