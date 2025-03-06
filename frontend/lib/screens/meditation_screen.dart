import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../services/websocket_service.dart';
import '../services/audio_service.dart';

class MeditationScreen extends StatefulWidget {
  @override
  _MeditationScreenState createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  final WebSocketService _webSocketService = WebSocketService();
  final AudioService _audioService = AudioService();

  @override
  void initState() {
    super.initState();
    _webSocketService.connect(); // Connect to WebSocket
    _webSocketService.stream.listen((audioChunk) {
      _audioService.playAudioChunk(audioChunk); // Play streamed audio
    });
  }

  void startMeditation() {
    String prompt = "Generate a mindfulness meditation session for relaxation.";
    _webSocketService.sendPrompt(prompt);
  }

  @override
  void dispose() {
    _webSocketService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mindfulness Meditation")),
      body: Center(
        child: ElevatedButton(
          onPressed: startMeditation,
          child: Text("Start Meditation"),
        ),
      ),
    );
  }
}
