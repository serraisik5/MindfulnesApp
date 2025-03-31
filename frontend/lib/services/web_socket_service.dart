import 'dart:convert';
import 'dart:typed_data';
import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class WebSocketService {
  final String wsUrl = "ws://localhost:8000/ws/meditation/";
  late WebSocketChannel _channel;

  final _messageController = StreamController<dynamic>.broadcast();
  Stream<dynamic> get messageStream => _messageController.stream;

  WebSocketService() {
    _connect();
  }

  void _connect() {
    _channel = WebSocketChannel.connect(Uri.parse(wsUrl));

    _channel.stream.listen((message) {
      _messageController.add(message); // pass raw messages to the controller
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
    _messageController.close();
  }
}
