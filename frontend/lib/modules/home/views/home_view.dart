import 'package:flutter/material.dart';
import 'package:minder_frontend/helpers/constants/colors.dart';
import 'package:minder_frontend/helpers/styles/text_style.dart';
import 'package:minder_frontend/services/audio_service.dart';
import 'package:minder_frontend/services/web_socket_service.dart';
import 'package:minder_frontend/widgets/custom_app_bar.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late WebSocketService _webSocketService;
  String receivedTranscript = "";
  String name = "Selen";
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _webSocketService = WebSocketService(
      onMessageReceived: (message) {
        setState(() {
          receivedTranscript += "$message \n";
        });
      },
    );
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
            Text(
              "Good Morning, $name",
              style: AppTextStyles.heading,
            ),
            SizedBox(height: 10),
            Text(
              "We wish you have a good day",
              style: AppTextStyles.lightheading,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _webSocketService.sendMeditationRequest("Relaxation", 5);
              },
              child: Text("Start Meditation"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                print("Transcript: \n$receivedTranscript");
              },
              child: Text("Print Transcript"),
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
