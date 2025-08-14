// lib/modules/start meditation/views/meditate_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minder_frontend/helpers/constants/colors.dart';
import 'package:minder_frontend/helpers/constants/strings.dart';
import 'package:minder_frontend/helpers/styles/text_style.dart';
import 'package:minder_frontend/modules/start meditation/controllers/meditation_session_controller.dart';
import 'package:minder_frontend/modules/start meditation/views/player_view.dart';
import 'package:minder_frontend/modules/start meditation/views/widgets/parameter_dropdown.dart';
import 'package:minder_frontend/widgets/custom_app_bar.dart';
import 'package:minder_frontend/widgets/custom_blue_button.dart';

class MeditateView extends StatefulWidget {
  const MeditateView({Key? key}) : super(key: key);

  @override
  State<MeditateView> createState() => _MeditateViewState();
}

class _MeditateViewState extends State<MeditateView> {
  final sessionController = Get.find<MeditationSessionController>();

  final List<String> _types = [
    TYPE_RELAXATION,
    TYPE_PERSONAL_GROWTH,
    TYPE_BETTER_SLEEP,
    TYPE_REDUCE_STRESS,
    TYPE_IMPROVE_PERFORMANCE,
  ];

  String _selectedType = TYPE_RELAXATION;
  double _selectedDuration = 5;
  final TextEditingController _feelingController = TextEditingController();

  @override
  void dispose() {
    _feelingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(CHOOSE_PARAMETERS, style: AppTextStyles.heading),
            const SizedBox(height: 16),
            Text(TOPIC, style: AppTextStyles.lightheading),
            const SizedBox(height: 8),
            ParameterDropdown(
              title: CATEGORY,
              items: _types,
              selected: _selectedType,
              onChanged: (type) => setState(() => _selectedType = type),
            ),
            const SizedBox(height: 48),
            Text(
              "$DURATION (${_selectedDuration.toInt()} $MINUTES_SHORT)",
              style: AppTextStyles.lightheading,
            ),
            Slider(
              min: 1,
              max: 5,
              divisions: 5,
              value: _selectedDuration,
              label: "${_selectedDuration.toInt()}",
              onChanged: (v) => setState(() => _selectedDuration = v),
              activeColor: appPrimary,
              inactiveColor: appTertiary.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(HOW_ARE_YOU_FEELING, style: AppTextStyles.lightheading),
            const SizedBox(height: 16),
            TextFormField(
              controller: _feelingController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: HINT_FEELING,
                hintStyle: AppTextStyles.lightheading,
                filled: true,
                fillColor: appTertiary.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: CustomBlueButton(
                text: START_MEDITATION,
                onPressed: () async {
                  await sessionController.startSession(
                    _selectedType,
                    _selectedDuration.toInt(),
                    _feelingController.text,
                  );
                  Get.to(() => const PlayerView());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
