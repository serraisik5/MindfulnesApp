import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get/get.dart';
import 'package:minder_frontend/modules/base/views/base_view.dart';
import 'package:minder_frontend/modules/login-register/controllers/auth_controller.dart';
import 'package:minder_frontend/modules/login-register/views/login_view.dart';
import 'package:minder_frontend/modules/start%20meditation/controllers/favorite_controller.dart';
import 'package:minder_frontend/modules/start%20meditation/controllers/meditation_session_controller.dart';
import 'package:minder_frontend/services/audio_service.dart';
import 'package:minder_frontend/services/local_storage.dart';
import 'package:minder_frontend/services/localization_service.dart';

MyAudioHandler myAudioHandler = MyAudioHandler();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Get.put(MeditationSessionController(), permanent: true);
  Get.put(FavoriteController(), permanent: true);

  await LocalStorage.initalizeStorage();

  final authController = Get.put(AuthController(), permanent: true);
  final isLoggedIn = await authController.tryAutoLogin();
  if (!isLoggedIn) {
    LocalStorage.setLocalParameter<bool>("isGuest", true);
  } else {
    LocalStorage.setLocalParameter<bool>("isGuest", false);
  }

  await LocalizationService.initialize();
  Get.put(LocalizationService());

  runApp(LocalizedApp(LocalizationService.delegate, MyApp()));
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
    final auth = Get.find<AuthController>();

    return GetMaterialApp(
      title: 'Mindfulness',
      // ⬇️ make sure you register your translations, localizations, etc
      locale: LocalizationService.localeRx.value,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        LocalizationService.delegate,
      ],
      supportedLocales: LocalizationService.delegate.supportedLocales,
      home: Obx(() {
        if (auth.isLoading.value) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return BaseView();
      }),
    );
  }
}
