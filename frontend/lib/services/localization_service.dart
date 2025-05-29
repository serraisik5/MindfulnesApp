import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get/get.dart';
import 'package:minder_frontend/services/local_storage.dart';

class LocalizationService extends GetxController {
  static late LocalizationDelegate delegate;
  // Make the locale reactive
  static final localeRx = Rx<Locale>(Locale('en'));

  static Future<void> initialize() async {
    delegate = await LocalizationDelegate.create(
      fallbackLocale: 'en',
      supportedLocales: ['en', 'fr', 'tr', 'de', 'it', 'ru', 'bg'],
    );
    await _setInitialLocale();
  }

  static Future<void> _setInitialLocale() async {
    String? languageCode = LocalStorage.getLocalParameter("language");
    log("Stored Language Code at startup: $languageCode");

    if (languageCode == null) {
      languageCode = Get.deviceLocale?.languageCode ?? 'en';
      LocalStorage.setLocalParameter("language", languageCode);
    }

    Locale locale = Locale.fromSubtags(languageCode: languageCode);
    log("Applying locale at startup: $locale");

    // Update GetX locale immediately
    Get.updateLocale(locale);
    localeRx.value = locale;
    await delegate.changeLocale(locale);
  }

  static Future<void> changeLocale(String languageCode) async {
    Locale locale = Locale.fromSubtags(languageCode: languageCode);

    // Save new language code
    LocalStorage.setLocalParameter("language", languageCode);
    log("Changing language to: $languageCode");

    // Schedule the locale update for after the current build completes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.updateLocale(locale);
      localeRx.value = locale;
    });

    try {
      await delegate.changeLocale(locale);
      log("Flutter Translate locale changed");
    } catch (e) {
      log("Error in delegate.changeLocale(): $e");
    }
  }
}
