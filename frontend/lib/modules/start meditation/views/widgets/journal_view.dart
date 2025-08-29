// lib/modules/journal/views/journal_create_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minder_frontend/helpers/constants/colors.dart';
import 'package:minder_frontend/helpers/constants/strings.dart';
import 'package:minder_frontend/helpers/styles/text_style.dart';
import 'package:minder_frontend/modules/login-register/controllers/auth_controller.dart';
import 'package:minder_frontend/modules/login-register/views/login_view.dart';
import 'package:minder_frontend/modules/start%20meditation/controllers/journal_controller.dart';
import 'package:minder_frontend/widgets/custom_blue_button.dart';
import 'package:minder_frontend/widgets/login_popup.dart'; // <-- the overlay widget

class JournalCreateView extends StatefulWidget {
  const JournalCreateView({super.key});

  @override
  _JournalCreateViewState createState() => _JournalCreateViewState();
}

class _JournalCreateViewState extends State<JournalCreateView> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  final journalCtl = Get.put(JournalController());
  final _authCtrl = Get.find<AuthController>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _formContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: Form(
              key: _formKey,
              child: TextFormField(
                textAlignVertical: TextAlignVertical.top,
                controller: _controller,
                style: AppTextStyles.body,
                decoration: InputDecoration(
                  hintText: WRITE_JOURNAL_HINT,
                  fillColor: appTertiary.withAlpha(50),
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: appPrimary),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLines: null,
                expands: true,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? VALIDATOR_CANNOT_BE_EMPTY
                    : null,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Obx(() {
            final saving = journalCtl.isLoading.value;
            return CustomBlueButton(
              text: saving ? BUTTON_SAVING : BUTTON_SAVE_ENTRY,
              onPressed: () {
                if (saving) return;
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

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool isGuest =
          !_authCtrl.isLoggedIn.value || _authCtrl.currentUser.value == null;

      return Stack(
        children: [
          // Main content; dim it slightly when overlay is shown (optional)
          Opacity(
            opacity: isGuest ? 0.4 : 1.0,
            child: _formContent(),
          ),

          // Overlay MUST be a child of Stack
          LoginGateOverlay(
            visible: isGuest,
            title: 'Please login to display this page',
            onLogin: () => Get.to(() => LoginView()),
          ),
        ],
      );
    });
  }
}
