import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'package:audio_service/audio_service.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:logger/logger.dart';

class MyAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  static final MyAudioHandler _instance = MyAudioHandler._internal();

  factory MyAudioHandler() => _instance;

  MyAudioHandler._internal() {
    _initializePlayer();
  }

  final FlutterSoundPlayer audioPlayer =
      FlutterSoundPlayer(logLevel: Level.error);

  bool isPlaying = false;
  bool isCompleted = false;

  final StreamController<MyPlayerState> _playerStateStreamController =
      StreamController<MyPlayerState>.broadcast();

  Stream<MyPlayerState> get playerStateStream =>
      _playerStateStreamController.stream;

  final StreamController<Duration> _positionStreamController =
      StreamController<Duration>.broadcast();

  Stream<Duration> get playerPositionStream => _positionStreamController.stream;

  final Duration totalDuration = const Duration(minutes: 2); // Fixed duration
  Timer? _positionTimer;
  Duration currentPosition = Duration.zero;

  void startPositionUpdates({bool resetPosition = false}) {
    if (resetPosition) {
      currentPosition =
          Duration.zero; // Only reset when needed (e.g., new audio)
    }
    _positionStreamController.add(currentPosition);

    _positionTimer?.cancel();
    _positionTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (isPlaying) {
        currentPosition += const Duration(milliseconds: 200);
        _positionStreamController.add(currentPosition);
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _initializePlayer() async {
    try {
      await audioPlayer.openPlayer();
      _setupMediaControls();
      _emitPlayerState(playing: false, processingState: ProcessingState.idle);
      print("FlutterSoundPlayer initialized");
    } catch (e) {
      print("Error initializing FlutterSoundPlayer: $e");
    }
  }

  void addStream(Uint8List stream) {
    if (audioPlayer.foodSink != null) {
      audioPlayer.foodSink?.add(FoodData(stream));
      log("food added");
    } else {
      print("Error: foodSink is null. Ensure player is initialized.");
    }
  }

  Future<void> startPlayer({required MediaItem? song}) async {
    try {
      if (isPlaying) {
        print(
            "Another audio is playing. Stopping it before starting a new one.");
        await stop();
      }
      print("player started");
      if (!isPlaying) {
        isCompleted = false;
        isPlaying = true;
        _emitPlayerState(
            playing: true, processingState: ProcessingState.loading);

        await audioPlayer.startPlayerFromStream(
          codec: Codec.pcm16,
          sampleRate: 24000,
          numChannels: 1,
          interleaved: true,
          bufferSize: 4096,
          onBufferUnderlow: () {
            isPlaying = false;
            isCompleted = true;
            _emitPlayerState(
                playing: false, processingState: ProcessingState.completed);
            log("Playback finished");
          },
        );
        startPositionUpdates();

        isPlaying = true;
        _emitPlayerState(playing: true, processingState: ProcessingState.ready);
        updateNowPlayingInfo(song);
        print("Player started in streaming mode");
      } else {
        print("player is already playing");
      }
    } catch (e) {
      print("Error starting player: $e");
    }
  }

  void _setupMediaControls() {
    // Just update playbackState — no background audio needed
    playbackState.add(playbackState.value.copyWith(
      playing: isPlaying,
      controls: [
        MediaControl.play,
        MediaControl.pause,
        MediaControl.stop,
      ],
      processingState:
          isPlaying ? AudioProcessingState.ready : AudioProcessingState.idle,
    ));
  }

  void updateNowPlayingInfo(MediaItem? song) {
    mediaItem.add(song);

    playbackState.add(playbackState.value.copyWith(
      playing: isPlaying,
      controls: [
        MediaControl.play,
        MediaControl.pause,
        MediaControl.stop,
      ],
    ));
  }

  Future<void> resetPlayer() async {
    try {
      await stop(); // Ensure the player is stopped
      await audioPlayer.closePlayer(); // Close the player
      await audioPlayer.openPlayer(); // Reopen the player
      log("Player reset and ready for new stream");
    } catch (e) {
      log("Error resetting player: $e");
    }
  }

  void resetFoodSink() {
    if (audioPlayer.foodSink != null) {
      audioPlayer.foodSink?.close();
      log("foodSink reset");
    }
  }

  Future<void> stop() async {
    try {
      if (isPlaying) {
        await audioPlayer.stopPlayer();
        isPlaying = false;
        _positionTimer?.cancel();
        currentPosition = Duration.zero;
        _emitPlayerState(playing: false, processingState: ProcessingState.idle);
        log("Player stopped");
      }
    } catch (e) {
      log("Error stopping player: $e");
    }
  }

  @override
  Future<void> play() async {
    print("selen13");
    try {
      if (!audioPlayer.isOpen()) {
        log("Audio player is not open. Reinitializing...");
        await resetPlayer();
      }

      if (!isPlaying) {
        print("selen12");
        if (isCompleted) {
          log("Playback completed, starting from the beginning...");
          //await startPlayer(); // Restart playback
        } else {
          await audioPlayer.resumePlayer();
          isPlaying = true;

          // Notify the lock screen
          playbackState.add(playbackState.value.copyWith(
            playing: true,
            controls: [MediaControl.pause, MediaControl.stop],
          ));

          _emitPlayerState(
              playing: true, processingState: ProcessingState.ready);
          log("Playback resumed");
        }
      }
    } catch (e) {
      log("Error resuming playback: $e");
    }
  }

  @override
  Future<void> seek(Duration position) {
    log("user seek the player, $position");
    return audioPlayer.seekToPlayer(position);
  }

  @override
  Future<void> pause() async {
    try {
      if (isPlaying) {
        await audioPlayer.pausePlayer();
        isPlaying = false;
        // Notify the lock screen (Ensure play button remains enabled)
        playbackState.add(playbackState.value.copyWith(
          playing: false,
          controls: [MediaControl.play, MediaControl.stop],
        ));
        _emitPlayerState(
            playing: false, processingState: ProcessingState.ready);
        log("Playback paused");
      }
    } catch (e) {
      log("Error pausing playback: $e");
    }
  }

  void CompletePlayerstate({
    required bool playing,
  }) {
    _emitPlayerState(
        playing: playing, processingState: ProcessingState.completed);
  }

  void _emitPlayerState({
    required bool playing,
    required ProcessingState processingState,
  }) {
    _playerStateStreamController.add(MyPlayerState(
      playing: playing,
      processingState: processingState,
    ));
  }

  Future<void> dispose() async {
    await stop();
    _positionTimer?.cancel();
    _playerStateStreamController.close();
    _playerStateStreamController.close();
    audioPlayer.closePlayer();
  }
}

class MyPlayerState {
  final bool playing; // Whether audio is playing
  final ProcessingState processingState; // The current processing state

  MyPlayerState({required this.playing, required this.processingState});

  @override
  String toString() => 'playing=$playing, processingState=$processingState';
}

enum ProcessingState {
  idle,
  loading,
  buffering,
  ready,
  completed,
}
