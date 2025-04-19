import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minder_frontend/modules/login-register/controllers/auth_controller.dart';

class ProfileView extends StatefulWidget {
  ProfileView({super.key}) {
    Get.put(AuthController());
  }

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                  icon: const Icon(Icons.logout),
                  label: const Text("Logout"),
                  onPressed: () {
                    Get.defaultDialog(
                      title: "Confirm Logout",
                      middleText: "Are you sure you want to log out?",
                      textCancel: "Cancel",
                      textConfirm: "Logout",
                      confirmTextColor: Colors.white,
                      onConfirm: () {
                        AuthController().logout();
                        Get.back(); // Close dialog
                      },
                    );
                  },
                ),
              ],
            )),
      ),
    );
  }
}
