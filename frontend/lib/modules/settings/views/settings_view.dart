// lib/modules/profile/views/settings_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minder_frontend/helpers/constants/colors.dart';
import 'package:minder_frontend/helpers/constants/strings.dart';
import 'package:minder_frontend/helpers/styles/text_style.dart';
import 'package:minder_frontend/modules/login-register/controllers/auth_controller.dart';
import 'package:minder_frontend/modules/settings/controllers/language_controller.dart';
import 'package:minder_frontend/modules/settings/controllers/voice_controller.dart';
import 'package:minder_frontend/modules/settings/views/pages/language_selection_view.dart';
import 'package:minder_frontend/modules/settings/views/pages/voice_selection_view.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final voiceCtl = Get.put(VoiceController());
  final _authCtrl = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    // Initialize LanguagesController if not already initialized
    if (!Get.isRegistered<LanguagesController>()) {
      Get.put(LanguagesController());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackground,
      appBar: AppBar(
        backgroundColor: appBackground,
        elevation: 0,
        title: Text(SETTINGS, style: AppTextStyles.heading),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GetBuilder<LanguagesController>(builder: (_) {
              final selectedLang = _.getSelectedLanguage()?.title ?? "";
              return SettingItem(
                icon: Icons.language,
                title: LANGUAGE,
                subtitle: selectedLang,
                onTap: () => Get.to(
                  () => const LanguageSelectionView(),
                  transition: Transition.rightToLeft,
                ),
              );
            }),
            const SizedBox(height: 24),
            GetBuilder<VoiceController>(builder: (_) {
              final selectedVoice = _.getSelectedVoice()?.label ?? "";
              return SettingItem(
                icon: Icons.record_voice_over,
                title: VOICE,
                subtitle: selectedVoice,
                onTap: () => Get.to(
                  () => const VoiceView(),
                  transition: Transition.rightToLeft,
                ),
              );
            }),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              icon: const Icon(Icons.logout, color: appBackground),
              label: Text(LOGOUT, style: AppTextStyles.button),
              style: ElevatedButton.styleFrom(
                backgroundColor: appPrimary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onPressed: () {
                Get.defaultDialog(
                  title: CONFIRM_LOGOUT_TITLE,
                  middleText: CONFIRM_LOGOUT_MESSAGE,
                  textCancel: CANCEL,
                  textConfirm: LOGOUT_ACTION,
                  confirmTextColor: Colors.white,
                  onConfirm: () {
                    _authCtrl.logout();
                    Get.back();
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SettingItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const SettingItem({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: appPrimary),
      title:
          Text(title, style: AppTextStyles.button.copyWith(color: appDarkGrey)),
      subtitle: Text(subtitle ?? "", style: AppTextStyles.body),
      trailing: const Icon(Icons.keyboard_arrow_right),
      onTap: onTap,
    );
  }
}
