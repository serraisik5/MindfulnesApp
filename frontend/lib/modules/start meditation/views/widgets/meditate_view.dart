import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minder_frontend/helpers/constants/colors.dart';
import 'package:minder_frontend/helpers/styles/text_style.dart';
import 'package:minder_frontend/modules/start%20meditation/controllers/meditation_session_controller.dart';
import 'package:minder_frontend/modules/start%20meditation/views/player_view.dart';
import 'package:minder_frontend/modules/start%20meditation/views/widgets/parameter_dropdown.dart';
import 'package:minder_frontend/widgets/custom_app_bar.dart';
import 'package:minder_frontend/widgets/custom_blue_button.dart';

class MeditateView extends StatefulWidget {
  const MeditateView({Key? key}) : super(key: key);

  @override
  State<MeditateView> createState() => _MeditateViewState();
}

class _MeditateViewState extends State<MeditateView> {
  // your controller:
  final sessionController = Get.put(MeditationSessionController());

  // Available meditation types
  final List<String> _types = [
    "Relaxation",
    "Personal Growth",
    "Better Sleep",
    "Reduce Stress",
    "Improve Performance",
  ];

  String _selectedType = "Relaxation";
  double _selectedDuration = 5; // in minutes

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackground,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Choose a topic to focuse on", style: AppTextStyles.heading),
            const SizedBox(height: 16),

            // — Type selector as a list
            Text("Type", style: AppTextStyles.lightheading),
            const SizedBox(height: 8),
            ParameterDropdown(
              title: "Category",
              //leading: Image.asset(PLAYER_ELLIPSE, width: 24, height: 24), // or your meditation icon
              items: _types,
              selected: _selectedType,
              onChanged: (type) => setState(() => _selectedType = type),
            ),

            const SizedBox(height: 48),
            Text("Duration (${_selectedDuration.toInt()} min)",
                style: AppTextStyles.lightheading),
            Slider(
              min: 1,
              max: 60,
              divisions: 59,
              value: _selectedDuration,
              label: "${_selectedDuration.toInt()}",
              onChanged: (v) => setState(() => _selectedDuration = v),
              activeColor: appPrimary,
              inactiveColor: appTertiary.withOpacity(0.3),
            ),

            const SizedBox(height: 24),
            SizedBox(
                width: double.infinity,
                child: CustomBlueButton(
                    text: "Start Meditation",
                    onPressed: () {
                      // Send to backend + navigate
                      sessionController.startSession(
                        _selectedType,
                        _selectedDuration.toInt(),
                      );
                      Get.to(() => const PlayerView());
                    })),
          ],
        ),
      ),
    );
  }
}
