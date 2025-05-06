import 'dart:convert';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:minder_frontend/models/meditation_session_model.dart';
import 'package:minder_frontend/modules/start%20meditation/views/player_view.dart';
import 'package:minder_frontend/services/audio_service.dart';
import 'package:minder_frontend/services/web_socket_service.dart';

class MeditationSessionController extends GetxController {
  final WebSocketService webSocketService = WebSocketService();
  final RxString transcript = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool hasStartedPlayer = false.obs;
  final List<Uint8List> _bufferedChunks = [];

  final Rxn<MeditationSessionModel> currentSession =
      Rxn<MeditationSessionModel>();

  @override
  void onInit() {
    super.onInit();
    _listenToMessages();
  }

  void _listenToMessages() {
    webSocketService.messageStream.listen((message) {
      if (message is String) {
        final data = jsonDecode(message);

        switch (data['type']) {
          case 'text':
            transcript.value += '${data['content']}\n';
            break;

          case 'audio':
            final audioBytes = base64Decode(data['content']);
            _handleAudio(audioBytes);
            break;

          case 'session_complete':
            // parse and store the session object
            final sessionJson = data['session'] as Map<String, dynamic>;
            currentSession.value = MeditationSessionModel.fromJson(sessionJson);
            isLoading.value = false;
            print("Selen selennn " + sessionJson.toString());
            break;
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

  Future<void> startSession(String title, int duration) async {
    disposeSession();
    MyAudioHandler().resetFoodSink();
    MyAudioHandler().startPlayer(song: null);
    isLoading.value = true;
    await webSocketService.sendMeditationRequest(title, duration);
    Get.to(() => const PlayerView());
  }

  void disposeSession() {
    webSocketService.dispose();
    MyAudioHandler().stop();
    hasStartedPlayer.value = false;
  }
}
