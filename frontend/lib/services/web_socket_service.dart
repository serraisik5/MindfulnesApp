import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class WebSocketService {
  final String wsUrl = "ws://localhost:8000/ws/meditation/";
  late WebSocketChannel _channel;
  Function(String)? onMessageReceived;

  WebSocketService({this.onMessageReceived}) {
    _connect();
  }

  void _connect() {
    _channel = WebSocketChannel.connect(Uri.parse(wsUrl));

    _channel.stream.listen((message) {
      print("Received: $message");

      final data = jsonDecode(message);
      if (data['type'] == 'text' && onMessageReceived != null) {
        onMessageReceived!(data['content']);
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
  }

  void dispose() {
    _channel.sink.close(status.goingAway);
  }
}
