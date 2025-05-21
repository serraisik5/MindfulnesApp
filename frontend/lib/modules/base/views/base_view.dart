import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minder_frontend/helpers/constants/colors.dart';
import 'package:minder_frontend/helpers/styles/text_style.dart';
import 'package:minder_frontend/modules/favorites/views/favorites_view.dart';
import 'package:minder_frontend/modules/home/views/home_view.dart';
import 'package:minder_frontend/modules/profile/views/profile_view.dart';
import 'package:minder_frontend/modules/start%20meditation/controllers/meditation_session_controller.dart';
import 'package:minder_frontend/modules/start%20meditation/views/player_view.dart';
import 'package:minder_frontend/modules/start%20meditation/views/start_meditation_view.dart';
import 'package:minder_frontend/services/audio_service.dart';

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
    ProfileView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: IndexedStack(
              index: selectedIndex,
              children: _screens,
            ),
          ),
          // our new mini-player
          const PlayerBar(),
        ],
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

class PlayerBar extends StatelessWidget {
  const PlayerBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sessionCtl = Get.find<MeditationSessionController>();
    final audioHandler = MyAudioHandler();

    return Obx(() {
      // show only a thin bar always; you can hide if no session.start
      final title = sessionCtl.currentSession.value?.title ?? 'Nothing playing';
      return GestureDetector(
        onTap: () => Get.to(() => const PlayerView()),
        child: Container(
          color: appSecondary,
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // Title
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.body.copyWith(color: appPrimary),
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // play/pause button
              StreamBuilder<MyPlayerState>(
                stream: audioHandler.playerStateStream,
                initialData: MyPlayerState(
                    playing: false, processingState: ProcessingState.idle),
                builder: (context, snap) {
                  final playing = snap.data?.playing ?? false;
                  if (playing) {
                    return IconButton(
                      icon: Icon(Icons.pause, color: appPrimary),
                      onPressed: () => audioHandler.pause(),
                    );
                  } else {
                    return IconButton(
                      icon: Icon(Icons.play_arrow, color: appPrimary),
                      onPressed: () => audioHandler.play(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}
