import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minder_frontend/helpers/constants/colors.dart';
import 'package:minder_frontend/helpers/constants/images.dart';
import 'package:minder_frontend/modules/base/views/base_view.dart';
import 'package:minder_frontend/modules/login-register/views/register_view.dart';
import 'package:minder_frontend/widgets/custom_blue_button.dart';
import 'package:minder_frontend/widgets/custom_text_field.dart';

class LoginView extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
                  'Minder',
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
                  hintText: 'Email address',
                  backgroundColor: appBackground,
                  borderColor: appPrimary.withAlpha(150),
                  controller: emailController,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  hintText: 'Password',
                  backgroundColor: appBackground,
                  borderColor: appPrimary.withAlpha(150),
                  isPassword: true,
                  controller: passwordController,
                ),
                const SizedBox(height: 25),
                CustomBlueButton(
                  text: 'LOG IN',
                  onPressed: () {
                    String email = emailController.text;
                    String password = passwordController.text;
                    print('Email: $email, Password: $password');
                    Get.offAll(() => const BaseView());
                    // Perform authentication logic
                  },
                ),
                const SizedBox(height: 45),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(color: appTertiary),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to the registration screen
                        Get.to(() => RegisterView());
                      },
                      child: Text(
                        'Sign up',
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
