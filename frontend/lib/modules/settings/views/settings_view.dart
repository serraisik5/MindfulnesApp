// lib/modules/profile/views/settings_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:minder_frontend/helpers/styles/text_style.dart';
import 'package:minder_frontend/helpers/constants/colors.dart';
import 'package:minder_frontend/modules/profile/controllers/voice_controller.dart';
import 'package:minder_frontend/modules/settings/views/pages/voice_selection_view.dart';
import 'package:minder_frontend/services/local_storage.dart';

class SettingsView extends StatelessWidget {
  SettingsView({super.key});

  // make sure the VoiceController is in memory
  final voiceCtl = Get.put(VoiceController());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Language selector ─────────────────────────────────────────
          GetBuilder<VoiceController>(
            builder: (_) {
              final selectedLabel = _.getSelectedVoice()?.label ?? '';
              return SettingItem(
                icon: Icons.language,
                title: "Language",
                subtitle: selectedLabel,
                onTap: () => Get.to(() => const VoiceView()),
              );
            },
          ),

          // ─── Voice selector ────────────────────────────────────────────
          GetBuilder<VoiceController>(
            builder: (_) {
              final selectedLabel = _.getSelectedVoice()?.label ?? '';
              return SettingItem(
                icon: Icons.record_voice_over,
                title: "Voice",
                subtitle: selectedLabel,
                onTap: () => Get.to(() => const VoiceView()),
              );
            },
          ),
        ],
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
