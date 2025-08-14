import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minder_frontend/helpers/constants/colors.dart';
import 'package:minder_frontend/helpers/constants/strings.dart';
import 'package:minder_frontend/modules/settings/controllers/voice_controller.dart';

class VoiceView extends StatefulWidget {
  const VoiceView({super.key});

  @override
  State<VoiceView> createState() => _VoiceViewState();
}

class _VoiceViewState extends State<VoiceView> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<VoiceController>(builder: (voiceController) {
      return Scaffold(
          backgroundColor: appBackground,
          appBar: AppBar(
            backgroundColor: appBackground,
            title: Text(VOICE,
                style: Get.theme.textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: appDarkGrey)),
            centerTitle: true,
            elevation: 0,
            leading: GestureDetector(
              onTap: () async => Get.back(),
              child: Container(
                margin:
                    const EdgeInsets.only(left: 9, top: 9, right: 5, bottom: 5),
                height: 40,
                width: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  // color: kF7F7F7,
                ),
                child: BackButton(),
              ),
            ),
          ),
          body: Container(
            padding: EdgeInsets.all(12),
            child: Column(
              children: List.generate(
                voiceController.voices.length,
                (index) {
                  final voice = voiceController.voices[index];
                  return VoiceSelectWidget(
                    voiceController: voiceController,
                    voice: voice,
                    selectItem: () {
                      voiceController.selectVoice(voice.name ?? '');
                    },
                  );
                },
              ),
            ),
          ));
    });
  }
}

class VoiceSelectWidget extends StatelessWidget {
  const VoiceSelectWidget({
    super.key,
    required this.voice,
    required this.selectItem,
    required this.voiceController,
  });
  final VoiceItemModel voice;
  final VoiceController voiceController;
  final void Function() selectItem;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: selectItem,
      child: Container(
          padding: EdgeInsets.all(12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: voice.selectStatus == true
                  ? appSecondary
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20)),
          child: Row(
            children: [
              Icon(
                Icons.check_rounded,
                color: voice.selectStatus ?? false
                    ? appPrimary
                    : Colors.transparent,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(voice.label ?? ""),
              ),
              Spacer(),
              GestureDetector(
                child: CircleAvatar(
                    radius: 13,
                    backgroundColor: appPrimary,
                    child: SizedBox.shrink()
                    // voiceController.isPlaying(voice)
                    //     ? Icon(
                    //         Icons.pause_rounded,
                    //         size: 20,
                    //         weight: 20,
                    //         color: Get.isDarkMode ? k1A1A1A : kFFFFFF,
                    //       )
                    //     : Icon(
                    //         Icons.play_arrow_rounded,
                    //         size: 20,
                    //         weight: 20,
                    //         color: Get.isDarkMode ? k1A1A1A : kFFFFFF,
                    //       ),
                    ),
                onTap: () {
                  //voiceController.togglePlayPause(voice);
                  voiceController.update();
                },
              ),
            ],
          )),
    );
  }
}
