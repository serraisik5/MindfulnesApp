import 'package:flutter/material.dart';
import 'package:minder_frontend/helpers/constants/colors.dart';
import 'package:minder_frontend/modules/favorites/views/favorites_view.dart';
import 'package:minder_frontend/modules/home/views/home_view.dart';
import 'package:minder_frontend/modules/profile/views/profile_view.dart';
import 'package:minder_frontend/modules/settings/views/settings_view.dart';

class BaseView extends StatefulWidget {
  const BaseView({super.key});

  @override
  State<BaseView> createState() => _BaseViewState();
}

class _BaseViewState extends State<BaseView> {
  int selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeView(),
    const FavoritesView(),
    const SettingsView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: appBackground,
        selectedItemColor: appPrimary,
        unselectedItemColor: appTertiary,
        currentIndex: selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings')
        ],
      ),
    );
  }
}
