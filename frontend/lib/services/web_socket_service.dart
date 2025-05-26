import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:async';
import 'package:minder_frontend/services/auth_service.dart';
import 'package:minder_frontend/services/local_storage.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class WebSocketService {
  final String wsUrl = "ws://localhost:8000/ws/meditation/";
  WebSocketChannel? _channel;

  final _messageController = StreamController<dynamic>.broadcast();
  Stream<dynamic> get messageStream => _messageController.stream;

  bool _isConnected = false;

  Future<void> connect() async {
    if (_isConnected) return;

    final token = await AuthService.getAccessToken();

    // 2️⃣ build headers for the handshake
    final headers = <String, dynamic>{};
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    final socket = await WebSocket.connect(
      wsUrl,
      headers: headers,
    );
    _channel = IOWebSocketChannel(socket);

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

  /// ② Now await the connection before sending your payload.
  Future<void> sendMeditationRequest(
      String title, int duration, String feeling) async {
    await connect();
    final request = jsonEncode({
      "title": title,
      "duration": duration,
      "voice": LocalStorage.getLocalParameter("voice"),
      "how_you_feel": feeling
    });
    _channel?.sink.add(request);
  }

  void dispose() {
    _channel?.sink.close(status.goingAway);
    _isConnected = false;
  }
}
