import 'package:flutter/material.dart';
import 'package:minder_frontend/helpers/constants/colors.dart';
import 'package:minder_frontend/modules/favorites/views/favorites_view.dart';
import 'package:minder_frontend/modules/home/views/home_view.dart';
import 'package:minder_frontend/modules/profile/views/profile_view.dart';
import 'package:minder_frontend/modules/start%20meditation/views/start_meditation_view.dart';

class BaseView extends StatefulWidget {
  const BaseView({super.key});

  @override
  State<BaseView> createState() => _BaseViewState();
}

class _BaseViewState extends State<BaseView> {
  int selectedIndex = 0;

  final List<Widget> _screens = [
    HomeView(),
    const StartMeditationView(),
    const ProfileView(),
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        height: 90,
        child: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          color: appBackground,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.home,
                    size: 30,
                    color: selectedIndex == 0 ? appPrimary : appTertiary),
                onPressed: () => _onItemTapped(0),
              ),
              const SizedBox(width: 20), // Space for the FAB
              IconButton(
                icon: Icon(Icons.person,
                    size: 30,
                    color: selectedIndex == 2 ? appPrimary : appTertiary),
                onPressed: () => _onItemTapped(2),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        backgroundColor: appPrimary, // Customize as needed
        shape: const CircleBorder(),
        onPressed: () => _onItemTapped(1), // Tap to select Favorites
        child: const Icon(size: 40, Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
