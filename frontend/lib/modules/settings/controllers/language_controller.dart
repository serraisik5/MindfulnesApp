import 'dart:developer';
import 'dart:ui';

import 'package:get/get.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter/services.dart';
import 'package:minder_frontend/services/local_storage.dart';
import 'package:minder_frontend/services/localization_service.dart';

class LanguagesController extends GetxController {
  final RxList<LanguageItemModel> _languages = [
    LanguageItemModel(
        code: 'en',
        title: 'English',
        selectStatus: false,
        locale: const Locale('en', 'US')),
    LanguageItemModel(
        code: 'tr',
        title: 'Türkçe',
        selectStatus: false,
        locale: const Locale('tr', 'TR')),
    LanguageItemModel(
        code: 'fr',
        title: 'Français',
        selectStatus: false,
        locale: const Locale('fr', 'FR')),
    LanguageItemModel(
        code: 'it',
        title: 'Italiano',
        selectStatus: false,
        locale: const Locale('it', 'IT')),
    LanguageItemModel(
        code: 'de',
        title: 'Deutsch',
        selectStatus: false,
        locale: const Locale('de', 'DE')),
    LanguageItemModel(
        code: 'ru',
        title: 'Русский',
        selectStatus: false,
        locale: const Locale('ru', 'RU')),
    LanguageItemModel(
        code: 'bg',
        title: 'български',
        selectStatus: false,
        locale: const Locale('bg', 'BG')),
  ].obs;

  // Observable list of languages
  List<LanguageItemModel> get languages => _languages;

  @override
  void onInit() {
    super.onInit();
    // Set the default language from the main
    _initializeDefaultLanguage();
  }

  Future<void> _initializeDefaultLanguage() async {
    try {
      // Get the saved language code from local storage, device locale or default to English (en)
      String languageCode = LocalStorage.getLocalParameter("language") ??
          Get.deviceLocale?.languageCode ??
          'en';

      // If language is not supported, default to English
      if (!isLanguageSupported(languageCode)) {
        log("DEVICE LANGUAGE CODE ($languageCode) NOT SUPPORTED, defaulting to English");
        languageCode = 'en';
      }

      // Always select a language
      selectLanguage(languageCode);
    } catch (e) {
      log("Error in _initializeDefaultLanguage: $e");
      // Fallback to English
      selectLanguage('en');
    }
  }

  // Update the selected language
  void selectLanguage(String code) async {
    for (var language in _languages) {
      language.selectStatus = language.code == code;
    }
    LocalStorage.setLocalParameter("language", code);

    await LocalizationService.changeLocale(code);

    log("SELECTED LANGUAGE: ${getSelectedLanguage()?.title}");

    final selectedLanguage = getSelectedLanguage();

    log("SELECTED LANGUAGE: ${selectedLanguage?.title}");

    update(); // Notify listeners
  }

  // Get the currently selected language
  LanguageItemModel? getSelectedLanguage() {
    try {
      final selectedLanguage = _languages
          .firstWhereOrNull((language) => language.selectStatus == true);

      // If no language is selected, default to English
      if (selectedLanguage == null) {
        final englishLanguage =
            _languages.firstWhereOrNull((language) => language.code == 'en');
        if (englishLanguage != null) {
          englishLanguage.selectStatus = true;
          return englishLanguage;
        }
      }

      return selectedLanguage;
    } catch (e) {
      log("Error in getSelectedLanguage: $e");
      // Fallback to first language if available
      return _languages.isNotEmpty ? _languages.first : null;
    }
  }

  // Check if a language is supported
  bool isLanguageSupported(String languageCode) {
    return _languages.any((language) => language.code == languageCode);
  }
}

class LanguageItemModel {
  String? code;
  String? title;
  bool? selectStatus;
  Locale? locale;

  LanguageItemModel({this.code, this.title, this.selectStatus, this.locale});
}
