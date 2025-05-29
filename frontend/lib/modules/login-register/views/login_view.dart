import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minder_frontend/helpers/constants/colors.dart';
import 'package:minder_frontend/helpers/constants/images.dart';
import 'package:minder_frontend/helpers/constants/strings.dart';
import 'package:minder_frontend/modules/login-register/controllers/auth_controller.dart';
import 'package:minder_frontend/modules/login-register/views/register_view.dart';
import 'package:minder_frontend/widgets/custom_blue_button.dart';
import 'package:minder_frontend/widgets/custom_text_field.dart';

class LoginView extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _authCtrl = Get.find<AuthController>();

  LoginView({super.key}) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackground,
      body: Stack(
        children: [
          Positioned(
              top: -15,
              child: Image.asset(
                LOGIN_TOP_WAVE,
              )),
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Logo
                Text(
                  APP_NAME,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(
                  height: 55,
                ),
                // Illustration
                Image.asset(
                  MEDITATION_GIRL, // Add this image to your assets
                  height: 245,
                ),
              ],
            ),
          ),
          Positioned(bottom: 0, child: Image.asset(LOGIN_BOTTOM_RECTANGLE)),
          Positioned(
            bottom: 80,
            left: 20,
            right: 20,
            child: Column(
              children: [
                CustomTextField(
                  hintText: EMAIL,
                  backgroundColor: appBackground,
                  borderColor: appPrimary.withAlpha(150),
                  controller: emailController,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  hintText: PASSWORD,
                  backgroundColor: appBackground,
                  borderColor: appPrimary.withAlpha(150),
                  isPassword: true,
                  controller: passwordController,
                ),
                const SizedBox(height: 25),
                CustomBlueButton(
                  text: LOG_IN,
                  onPressed: () {
                    String email = emailController.text;
                    String password = passwordController.text;
                    _authCtrl.login(email, password);
                    print('Email: $email, Password: $password');
                    //Get.offAll(() => const BaseView());
                    // Perform authentication logic
                  },
                ),
                const SizedBox(height: 45),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DONT_HAVE_ACCOUNT,
                      style: TextStyle(color: appTertiary),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to the registration screen
                        Get.to(() => RegisterView());
                      },
                      child: Text(
                        SIGN_UP,
                        style: TextStyle(
                          color: appPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
