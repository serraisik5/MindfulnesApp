// lib/modules/profile/views/profile_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minder_frontend/helpers/constants/colors.dart';
import 'package:minder_frontend/helpers/constants/strings.dart';
import 'package:minder_frontend/helpers/styles/text_style.dart';
import 'package:minder_frontend/modules/login-register/controllers/auth_controller.dart';
import 'package:minder_frontend/modules/login-register/views/login_view.dart';
import 'package:minder_frontend/modules/profile/views/widgets/favorite_list_view.dart';
import 'package:minder_frontend/modules/profile/views/widgets/journal_list_view.dart';
import 'package:minder_frontend/modules/settings/views/settings_view.dart';
import 'package:minder_frontend/modules/start meditation/controllers/favorite_controller.dart';
import 'package:minder_frontend/widgets/custom_app_bar.dart';
import 'package:minder_frontend/widgets/login_popup.dart';

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
    _tabController.addListener(() {
      if (_tabController.index == 0) _refreshFavorites();
    });
  }

  // ... _refreshFavorites(), didChangeDependencies() same as yours ...

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
            icon: const Icon(Icons.settings, color: appPrimary),
            onPressed: () => Get.to(() => SettingsView()),
          ),
        ],
      ),
      body: Stack(
        children: [
          // your main content (unchanged)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Obx(() {
                  final bool isGuest = !_authCtrl.isLoggedIn.value ||
                      _authCtrl.currentUser.value == null;
                  final String displayName = isGuest
                      ? 'hooman'
                      : (_authCtrl.currentUser.value?.firstName ?? '');
                  final String nameToShow =
                      (displayName.isNotEmpty ? displayName : 'hooman')
                              .capitalizeFirst ??
                          'Hooman';
                  return Text(nameToShow, style: AppTextStyles.heading);
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

          // overlay (AnimatedOpacity + IgnorePointer)
          Obx(() {
            final isGuest = !_authCtrl.isLoggedIn.value ||
                _authCtrl.currentUser.value == null;
            return LoginGateOverlay(
              visible: isGuest,
              title: 'Please login to display this page',
            );
          }),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
