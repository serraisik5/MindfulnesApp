import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minder_frontend/helpers/constants/colors.dart';
import 'package:minder_frontend/modules/profile/views/profile_view.dart';
import 'package:minder_frontend/modules/settings/controllers/settings_controller.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final SettingsController controller = Get.put(SettingsController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Column(
        children: [
          settingItem("Selen Bilgiç", "Go to your profile", Icon(Icons.person),
              () => Get.to(ProfileView())),
        ],
      ),
    );
  }
}

Widget settingItem(String title, String subtitle, Icon icon, Function() onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.all(17),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: appPrimary, borderRadius: BorderRadius.circular(18)),
      child: Row(
        children: [
          icon,
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              Text(
                subtitle,
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
