import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:minder_frontend/helpers/constants/colors.dart';
import 'package:minder_frontend/helpers/styles/text_style.dart';
import 'package:minder_frontend/modules/start%20meditation/controllers/meditation_session_controller.dart';
import 'package:minder_frontend/modules/start%20meditation/views/player_view.dart';
import 'package:minder_frontend/services/audio_service.dart';
import 'package:minder_frontend/services/web_socket_service.dart';
import 'package:minder_frontend/widgets/custom_app_bar.dart';

class MeditateView extends StatefulWidget {
  const MeditateView({super.key});

  @override
  MeditateViewState createState() => MeditateViewState();
}

class MeditateViewState extends State<MeditateView> {
  late WebSocketService _webSocketService;
  String receivedTranscript = "";
  bool isPlaying = false;

  final sessionController = Get.put(
    MeditationSessionController(),
  );

  @override
  void initState() {
    super.initState();
    _webSocketService = WebSocketService();
  }

  @override
  void dispose() {
    _webSocketService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackground,
      appBar: CustomAppBar(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                sessionController.startSession("Relaxation", 5);
                Get.to(PlayerView());
              },
              child: Text("Start Meditation"),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  receivedTranscript.isNotEmpty
                      ? receivedTranscript
                      : "No transcript received yet.",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Get.to(PlayerView());
                if (isPlaying) {
                  await MyAudioHandler().pause();
                } else {
                  await MyAudioHandler().play();
                }
              },
              child: Text(isPlaying ? "Pause" : "Play"),
            )
          ],
        ),
      ),
    );
  }
}
