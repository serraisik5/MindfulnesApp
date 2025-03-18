import 'package:flutter/material.dart';
import 'package:minder_frontend/services/web_socket_service.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late WebSocketService _webSocketService;
  String receivedTranscript = "";

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
      appBar: AppBar(title: Text("Meditation")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
          ],
        ),
      ),
    );
  }
}
