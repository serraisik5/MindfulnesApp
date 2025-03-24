import 'dart:convert';
import 'dart:typed_data';
import 'package:minder_frontend/services/audio_service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class WebSocketService {
  final String wsUrl = "ws://localhost:8000/ws/meditation/";
  late WebSocketChannel _channel;
  Function(String)? onMessageReceived;

  bool _hasStartedPlayer = false;

  WebSocketService({this.onMessageReceived}) {
    _connect();
  }

  void _connect() {
    _channel = WebSocketChannel.connect(Uri.parse(wsUrl));

    _channel.stream.listen((message) {
      if (message is String) {
        final data = jsonDecode(message);

        // Handle text message
        if (data['type'] == 'text' && onMessageReceived != null) {
          onMessageReceived!(data['content']);
        }

        // Handle audio message (base64 string)
        if (data['type'] == 'audio' && data['content'] != null) {
          final audioBase64 = data['content'] as String;
          final audioBytes = base64Decode(audioBase64);
          // 🔥 Start player only once, when first audio chunk is received
          if (!_hasStartedPlayer) {
            _hasStartedPlayer = true;
            //MyAudioHandler().startPlayer(song: null);
          }
          MyAudioHandler().addStream(audioBytes);
        }
      } else if (message is Uint8List) {
        // Optional: if backend sends raw binary audio directly (not JSON-wrapped)
        MyAudioHandler().addStream(message);
      } else {
        print("⚠️ Unknown message type: $message");
      }
    }, onDone: () {
      print("WebSocket closed");
    }, onError: (error) {
      print("WebSocket error: $error");
    });
  }

  void sendMeditationRequest(String title, int duration) {
    final request = jsonEncode({
      "title": title,
      "duration": duration,
    });

    _channel.sink.add(request);

    //MyAudioHandler().startPlayer(song: null);
  }

  void dispose() {
    _channel.sink.close(status.goingAway);
  }
}
