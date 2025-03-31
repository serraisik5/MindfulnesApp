import 'package:flutter/material.dart';
import 'package:minder_frontend/helpers/constants/colors.dart';
import 'package:minder_frontend/services/audio_service.dart';

class AudioSeekBar extends StatefulWidget {
  const AudioSeekBar({super.key});

  @override
  State<AudioSeekBar> createState() => _AudioSeekBarState();
}

class _AudioSeekBarState extends State<AudioSeekBar> {
  Duration currentPosition = Duration.zero;
  final Duration totalDuration = MyAudioHandler().totalDuration;

  @override
  void initState() {
    super.initState();
    MyAudioHandler().playerPositionStream.listen((pos) {
      if (mounted) {
        setState(() {
          currentPosition = pos;
        });
      }
    });
  }

  void _onSeek(double seconds) {
    final position = Duration(seconds: seconds.toInt());
    MyAudioHandler().seek(position);
  }

  @override
  Widget build(BuildContext context) {
    final totalSeconds = totalDuration.inSeconds;
    final currentSeconds = currentPosition.inSeconds.clamp(0, totalSeconds);

    return Column(
      children: [
        Slider(
          min: 0,
          max: totalSeconds.toDouble(),
          value: currentSeconds.toDouble(),
          onChanged: null,
          activeColor: appPrimary,
          inactiveColor: appTertiary.withOpacity(0.3),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_formatDuration(currentPosition),
                  style: const TextStyle(color: Colors.white70, fontSize: 12)),
              Text(_formatDuration(totalDuration),
                  style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
        )
      ],
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes);
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}
