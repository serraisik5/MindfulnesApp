import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minder_frontend/helpers/constants/colors.dart';
import 'package:minder_frontend/modules/start%20meditation/controllers/meditation_session_controller.dart';
import 'package:minder_frontend/services/audio_service.dart';

class CustomPlayPauseButton extends StatefulWidget {
  final double size;

  const CustomPlayPauseButton({
    super.key,
    this.size = 64,
  });

  @override
  State<CustomPlayPauseButton> createState() => _CustomPlayPauseButtonState();
}

class _CustomPlayPauseButtonState extends State<CustomPlayPauseButton> {
  bool isPlaying = MyAudioHandler().isPlaying;
  late final Stream<MyPlayerState> _playerStateStream;
  final sessionController = Get.find<MeditationSessionController>();

  @override
  void initState() {
    super.initState();
    _playerStateStream = MyAudioHandler().playerStateStream;
    _playerStateStream.listen((state) {
      if (mounted) {
        setState(() {
          isPlaying = state.playing;
        });
      }
    });
  }

  void _onPressed() {
    isPlaying ? MyAudioHandler().pause() : MyAudioHandler().play();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onPressed,
      child: Center(
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: appDarkGrey,
            border: Border.all(
              color: appBackground.withAlpha(200),
              width: widget.size * 0.1,
            ),
          ),
          child: Obx(() {
            final isLoading = sessionController.isLoading.value;
            return Center(
              child: isLoading
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: appBackground,
                      ),
                    )
                  : Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      color: appBackground,
                      size: 28,
                    ),
            );
          }),
        ),
      ),
    );
  }
}
