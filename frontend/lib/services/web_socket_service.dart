import 'dart:convert';
import 'dart:typed_data';
import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class WebSocketService {
  final String wsUrl = "ws://localhost:8000/ws/meditation/";
  WebSocketChannel? _channel;

  final _messageController = StreamController<dynamic>.broadcast();
  Stream<dynamic> get messageStream => _messageController.stream;

  bool _isConnected = false;

  void connect() {
    if (_isConnected) return;

    _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
    _isConnected = true;

    _channel!.stream.listen((message) {
      if (!_messageController.isClosed) {
        _messageController.add(message);
      }
    }, onDone: () {
      _isConnected = false;
      print("WebSocket closed");
    }, onError: (error) {
      _isConnected = false;
      print("WebSocket error: $error");
    });
  }

  void sendMeditationRequest(String title, int duration) {
    connect(); // ensure connected
    final request = jsonEncode({
      "title": title,
      "duration": duration,
    });
    _channel?.sink.add(request);
  }

  void dispose() {
    _channel?.sink.close(status.goingAway);
    _isConnected = false;
  }
}
