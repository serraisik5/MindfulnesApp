import 'dart:developer';

import 'package:get/get.dart';
import 'package:minder_frontend/services/local_storage.dart';

class VoiceController extends GetxController {
  static const String baseUrl =
      'https://storage.googleapis.com/city-guide-5399e.appspot.com/voices';
  static const String defaultVersion = '20250112';
  static const List<String> supportedLanguages = [
    'en',
    'es',
    'fr',
    'pt',
    'ru',
    'tr',
    'uk'
  ];
  static const String defaultVoiceName = 'ash';

  final RxList<VoiceItemModel> voiceItems = <VoiceItemModel>[].obs;
  //final AudioPlayer audioPlayer = AudioPlayer();
  //Rx<VoiceItemModel?> currentlyPlayingVoice = Rx<VoiceItemModel?>(null);
  String currentLanguage = "en";
  List<VoiceItemModel> voices = [];

  // List of voices to display in the UI
  final List<VoiceItemModel> _voices = [
    // Available in TTS and Realtime API
    VoiceItemModel(
      label: "Alloy",
      name: "alloy",
      selectStatus: false,
    ),
    // Available in TTS and Realtime API
    VoiceItemModel(
      label: "Ash",
      name: "ash",
      selectStatus: false,
    ),
    // Available in TTS and Realtime API
    VoiceItemModel(
      label: "Coral",
      name: "coral",
      selectStatus: false,
    ),
    // Available in TTS and Realtime API
    VoiceItemModel(
      label: "Echo",
      name: "echo",
      selectStatus: false,
    ),
    // // Available in TTS only
    // VoiceItemModel(
    //   label: "Iris",
    //   name: "fable",
    //   selectStatus: false,
    // ),
    // // Available in TTS only
    // VoiceItemModel(
    //   label: "Ezra",
    //   name: "onyx",
    //   selectStatus: false,
    // ),
    // // Available in TTS only
    // VoiceItemModel(
    //   label: "Minerva",
    //   name: "nova",
    //   selectStatus: false,
    // ),
    // Available in TTS and Realtime API
    VoiceItemModel(
      label: "Sage",
      name: "sage",
      selectStatus: false,
    ),
    // Available in TTS and Realtime API
    VoiceItemModel(
      label: "Shimmer",
      name: "shimmer",
      selectStatus: false,
    ),
    // // Available in Realtime API only
    // VoiceItemModel(
    //   label: "Ballad",
    //   name: "ballad",
    //   selectStatus: false,
    // ),
    // // Available in Realtime API only
    // VoiceItemModel(
    //   label: "Verse",
    //   name: "verse",
    //   selectStatus: false,
    // ),
  ];

  @override
  void onInit() {
    super.onInit();

    currentLanguage =
        LocalStorage.getLocalParameter("language") ?? "en"; // e.g., "en"
    loadVoicesForLanguage(currentLanguage);

    // Listen for playback completion
    // audioPlayer.playerStateStream.listen((playerState) {
    //   if (playerState.processingState == ProcessingState.completed) {
    //     currentlyPlayingVoice.value = null;
    //     update();
    //   }
    // });

    // Set the default language from the main
    _initializeDefaultVoice();
  }

  void loadVoicesForLanguage(String language) {
    voices = _voices.map((voice) {
      final url = getVoiceUrl(voice.name ?? defaultVoiceName, language);
      return VoiceItemModel(
        label: voice.label,
        name: voice.name,
        url: url,
      );
    }).toList();
    update();
  }

  String getVoiceUrl(String voiceName, String languageCode) {
    // If the requested language is not supported, fallback to English
    final String effectiveLanguage =
        supportedLanguages.contains(languageCode) ? languageCode : 'en';

    // Construct the URL using the template
    // Example: https://storage.googleapis.com/city-guide-5399e.appspot.com/voices/en/alloy-20250112.mp3
    return '$baseUrl/$effectiveLanguage/$voiceName-$defaultVersion.mp3';
  }

  // bool isPlaying(VoiceItemModel voice) {
  //   return currentlyPlayingVoice.value == voice;
  // }

  // Future<void> togglePlayPause(VoiceItemModel voice) async {
  //   if (isPlaying(voice)) {
  //     await audioPlayer.pause();
  //     currentlyPlayingVoice.value = null;
  //   } else {

  //   if (myAudioHandler.player.playing) {
  //     log("Pausing active audio in MyAudioHandler before playing preview...");
  //     await myAudioHandler.pause();
  //   }

  //     await audioPlayer.stop();
  //     currentlyPlayingVoice.value = voice;
  //     try {
  //       await audioPlayer.setUrl(voice.url ?? getVoiceUrl(defaultVoiceName, 'en'));
  //       await audioPlayer.play();
  //     } catch (e) {
  //       log("Error playing audio: $e");
  //     }
  //   }
  //   update();
  // }

  Future<void> _initializeDefaultVoice() async {
    // Get the saved voice name from local storage or default ("ash")
    log("local voice is ${LocalStorage.getLocalParameter("voice")}");
    String voiceName =
        LocalStorage.getLocalParameter("voice") ?? defaultVoiceName;
    selectVoice(voiceName);
  }

  // Update the selected voice
  void selectVoice(String name) {
    for (var voice in voices) {
      voice.selectStatus = voice.name == name;
    }
    LocalStorage.setLocalParameter("voice", name);

    final selectedVoice = getSelectedVoice();

    log("SELECTED VOICE: ${selectedVoice?.label} ($name)");
    update(); // Notify listeners
  }

  // Get the currently selected voice
  VoiceItemModel? getSelectedVoice() {
    return voices.firstWhereOrNull((voice) => voice.selectStatus == true);
  }

  @override
  void onClose() {
    super.onClose();
    //audioPlayer.dispose();
  }
}

class VoiceItemModel {
  String? label;
  String? name;
  bool? selectStatus;
  String? url;

  VoiceItemModel({
    this.label,
    this.name,
    this.selectStatus,
    this.url,
  });
}
