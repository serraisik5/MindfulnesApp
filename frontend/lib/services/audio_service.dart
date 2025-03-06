import 'package:just_audio/just_audio.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();

  void playAudioChunk(List<int> audioChunk) async {
    final uri = Uri.dataFromBytes(audioChunk);
    await _player.setAudioSource(AudioSource.uri(uri));
    _player.play();
  }

  void stopAudio() {
    _player.stop();
  }
}
