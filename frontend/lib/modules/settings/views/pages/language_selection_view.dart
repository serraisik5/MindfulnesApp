import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:minder_frontend/helpers/constants/colors.dart';
import 'package:minder_frontend/helpers/constants/strings.dart';
import 'package:minder_frontend/helpers/styles/text_style.dart';
import 'package:minder_frontend/modules/settings/controllers/language_controller.dart';

class LanguageSelectionView extends StatefulWidget {
  const LanguageSelectionView({super.key});

  @override
  State<LanguageSelectionView> createState() => _LanguageViewState();
}

class _LanguageViewState extends State<LanguageSelectionView> {
  @override
  void initState() {
    super.initState();
    // ← this makes sure Get.find<LanguagesController>() will work
    Get.put(LanguagesController());
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LanguagesController>(builder: (voiceController) {
      return Scaffold(
          backgroundColor: appBackground,
          appBar: AppBar(
            backgroundColor: appBackground,
            title: Text(LANGUAGE,
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
                voiceController.languages.length,
                (index) {
                  final language = voiceController.languages[index];
                  return VoiceSelectWidget(
                    voiceController: voiceController,
                    voice: language,
                    selectItem: () {
                      voiceController.selectLanguage(language.code ?? '');
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
  final LanguageItemModel voice;
  final LanguagesController voiceController;
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
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(voice.title ?? ""),
              ),
              Spacer(),
              Icon(
                Icons.check_rounded,
                color: voice.selectStatus ?? false
                    ? appPrimary
                    : Colors.transparent,
              ),
            ],
          )),
    );
  }
}
