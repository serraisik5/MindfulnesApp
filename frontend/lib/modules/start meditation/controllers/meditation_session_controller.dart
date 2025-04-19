import 'dart:convert';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:minder_frontend/modules/start%20meditation/views/player_view.dart';
import 'package:minder_frontend/services/audio_service.dart';
import 'package:minder_frontend/services/web_socket_service.dart';

class MeditationSessionController extends GetxController {
  final WebSocketService webSocketService = WebSocketService();
  final RxString transcript = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool hasStartedPlayer = false.obs;
  final List<Uint8List> _bufferedChunks = [];

  @override
  void onInit() {
    super.onInit();
    _listenToMessages();
  }

  void _listenToMessages() {
    webSocketService.messageStream.listen((message) {
      if (message is String) {
        final data = jsonDecode(message);

        if (data['type'] == 'text') {
          transcript.value += '${data['content']}\n';
        } else if (data['type'] == 'audio' && data['content'] != null) {
          final audioBytes = base64Decode(data['content']);

          _handleAudio(audioBytes);
        }
      } else if (message is Uint8List) {
        _handleAudio(message);
      }
    });
  }

  void _handleAudio(Uint8List audioBytes) {
    if (!hasStartedPlayer.value) {
      hasStartedPlayer.value = true;
      isLoading.value = true;

      _bufferedChunks.add(audioBytes);

      MyAudioHandler().startPlayer(song: null).then((_) {
        isLoading.value = false;

        for (final chunk in _bufferedChunks) {
          MyAudioHandler().addStream(chunk);
        }
        _bufferedChunks.clear();
      });
    } else {
      MyAudioHandler().addStream(audioBytes);
    }
  }

  void startSession(String title, int duration) {
    disposeSession();
    MyAudioHandler().resetFoodSink();
    MyAudioHandler().startPlayer(song: null);
    isLoading.value = true;
    webSocketService.sendMeditationRequest(title, duration);
    Get.to(() => const PlayerView());
  }

  void disposeSession() {
    webSocketService.dispose();
    MyAudioHandler().stop();
    hasStartedPlayer.value = false;
  }
}
