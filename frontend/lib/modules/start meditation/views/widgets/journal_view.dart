// lib/modules/journal/views/journal_create_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minder_frontend/helpers/constants/colors.dart';
import 'package:minder_frontend/helpers/styles/text_style.dart';
import 'package:minder_frontend/modules/start%20meditation/controllers/journal_controller.dart';
import 'package:minder_frontend/widgets/custom_blue_button.dart';

class JournalCreateView extends StatefulWidget {
  const JournalCreateView({super.key});

  @override
  _JournalCreateViewState createState() => _JournalCreateViewState();
}

class _JournalCreateViewState extends State<JournalCreateView> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  final journalCtl = Get.put(JournalController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Form(
            key: _formKey,
            child: Expanded(
              child: TextFormField(
                textAlignVertical: TextAlignVertical.top,
                controller: _controller,
                style: AppTextStyles.body,
                decoration: InputDecoration(
                  hintText: 'Write about your day…',
                  fillColor: appTertiary.withAlpha(50),
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: appPrimary),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLines: null,
                expands: true,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Cannot be empty' : null,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Obx(() {
            return CustomBlueButton(
              text: journalCtl.isLoading.value ? 'Saving…' : 'Save Entry',
              onPressed: () {
                // If we're already saving, just bail out
                if (journalCtl.isLoading.value) return;

                // Otherwise validate & submit
                if (_formKey.currentState!.validate()) {
                  journalCtl.addEntry(_controller.text.trim());
                  _controller.clear();
                }
              },
            );
          }),
        ],
      ),
    );
  }
}
