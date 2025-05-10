// lib/modules/profile/views/profile_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minder_frontend/helpers/constants/colors.dart';
import 'package:minder_frontend/helpers/styles/text_style.dart';
import 'package:minder_frontend/modules/login-register/controllers/auth_controller.dart';
import 'package:minder_frontend/modules/profile/views/widgets/favorite_list_view.dart';
import 'package:minder_frontend/widgets/custom_app_bar.dart';

class ProfileView extends StatefulWidget {
  ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with SingleTickerProviderStateMixin {
  final _authCtrl = Get.find<AuthController>();

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackground,
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Text(_authCtrl.currentUser?.firstName.capitalizeFirst ?? "",
                style: AppTextStyles.heading),
            SizedBox(
              height: 20,
            ),
            TabBar(
              controller: _tabController,
              indicatorColor: appPrimary,
              indicator: const UnderlineTabIndicator(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(width: 3.0, color: appPrimary),
                insets: EdgeInsets.symmetric(horizontal: 5.0),
              ),
              labelColor: appPrimary,
              unselectedLabelColor: appTertiary,
              tabs: const [
                Tab(
                  text: "Favorites",
                ),
                Tab(text: "Settings"),
              ],
            ),

            // Give TabBarView a height by wrapping it in Expanded
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  FavoriteListSection(),
                  const Center(child: Text("Settings Content")),
                ],
              ),
            ),
            //Expanded(child: FavoriteListSection()),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text("Logout"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
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
