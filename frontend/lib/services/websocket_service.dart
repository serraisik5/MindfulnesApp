import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  late WebSocketChannel _channel;

  void connect() {
    _channel = IOWebSocketChannel.connect(
      'ws://your-backend-url/ws/stream_audio/', // Replace with your actual WebSocket URL
    );
  }

  void sendPrompt(String prompt) {
    _channel.sink.add(prompt);
  }

  Stream get stream => _channel.stream;

  void disconnect() {
    _channel.sink.close();
  }
}
