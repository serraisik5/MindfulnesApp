// lib/modules/profile/views/settings_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:minder_frontend/helpers/styles/text_style.dart';
import 'package:minder_frontend/helpers/constants/colors.dart';
import 'package:minder_frontend/modules/login-register/controllers/auth_controller.dart';
import 'package:minder_frontend/modules/settings/controllers/voice_controller.dart';
import 'package:minder_frontend/modules/settings/views/pages/language_selection_view.dart';
import 'package:minder_frontend/modules/settings/views/pages/voice_selection_view.dart';
import 'package:minder_frontend/services/local_storage.dart';

class SettingsView extends StatelessWidget {
  SettingsView({Key? key}) : super(key: key);

  final voiceCtl = Get.put(VoiceController());

  final _authCtrl = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackground,
      appBar: AppBar(
        title: Text("Settings", style: AppTextStyles.heading),
        backgroundColor: appBackground,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GetBuilder<VoiceController>(builder: (_) {
              final selectedLabel = _.getSelectedVoice()?.label ?? '';
              return SettingItem(
                icon: Icons.language,
                title: "Language",
                subtitle: "English",
                onTap: () => Get.to(
                  () => const LanguageSelectionView(),
                  transition: Transition.rightToLeft,
                ),
              );
            }),
            const SizedBox(height: 24),
            GetBuilder<VoiceController>(builder: (_) {
              final selectedLabel = _.getSelectedVoice()?.label ?? '';
              return SettingItem(
                icon: Icons.record_voice_over,
                title: "Voice",
                subtitle: selectedLabel,
                onTap: () => Get.to(
                  () => const VoiceView(),
                  transition: Transition.rightToLeft,
                ),
              );
            }),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              icon: const Icon(
                Icons.logout,
                color: appBackground,
              ),
              label: const Text(
                "Logout",
                style: AppTextStyles.button,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: appPrimary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onPressed: () {
                Get.defaultDialog(
                  title: "Confirm Logout",
                  middleText: "Are you sure?",
                  textCancel: "Cancel",
                  textConfirm: "Logout",
                  confirmTextColor: Colors.white,
                  onConfirm: () {
                    _authCtrl.logout(); // ← use the existing controller
                    Get.back(); // close dialog
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
      leading: Icon(icon, color: appPrimary),
      title:
          Text(title, style: AppTextStyles.button.copyWith(color: appDarkGrey)),
      subtitle: Text(subtitle ?? "null", style: AppTextStyles.body),
      trailing: const Icon(Icons.keyboard_arrow_right),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }
}
