// lib/modules/profile/views/profile_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minder_frontend/helpers/constants/colors.dart';
import 'package:minder_frontend/helpers/constants/strings.dart';
import 'package:minder_frontend/helpers/styles/text_style.dart';
import 'package:minder_frontend/modules/login-register/controllers/auth_controller.dart';
import 'package:minder_frontend/modules/profile/views/widgets/favorite_list_view.dart';
import 'package:minder_frontend/modules/profile/views/widgets/journal_list_view.dart';
import 'package:minder_frontend/modules/settings/views/settings_view.dart';
import 'package:minder_frontend/modules/start meditation/controllers/favorite_controller.dart';
import 'package:minder_frontend/widgets/custom_app_bar.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

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

    // Add listener to refresh favorites when tab changes
    _tabController.addListener(() {
      if (_tabController.index == 0) {
        // Favorites tab
        _refreshFavorites();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh favorites when the view becomes visible
    _refreshFavorites();
  }

  void _refreshFavorites() {
    try {
      final favoriteController = Get.find<FavoriteController>();
      favoriteController.loadFavorites();
    } catch (e) {
      print("Error refreshing favorites: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackground,
      appBar: CustomAppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: appPrimary),
            onPressed: () => Get.to(() => SettingsView()),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Obx(() {
              final name = _authCtrl.currentUser.value?.firstName ?? GUEST;
              return Text(
                name.capitalizeFirst ?? GUEST,
                style: AppTextStyles.heading,
              );
            }),
            const SizedBox(height: 20),
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
              tabs: [
                Tab(text: FAVORITES_TAB),
                Tab(text: JOURNALS_TAB),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  FavoriteListSection(),
                  JournalListView(),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
