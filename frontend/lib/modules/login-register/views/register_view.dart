import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minder_frontend/helpers/constants/colors.dart';
import 'package:minder_frontend/helpers/constants/images.dart';
import 'package:minder_frontend/modules/base/views/base_view.dart';
import 'package:minder_frontend/widgets/back_button.dart';
import 'package:minder_frontend/widgets/custom_blue_button.dart';
import 'package:minder_frontend/widgets/custom_text_field.dart';

class RegisterView extends StatelessWidget {
  RegisterView({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackground,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: -45,
            child: Transform.rotate(
              angle: 4, // 180 degrees (PI radians)
              child: Image.asset(
                REGISTER_WAVE,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: -85,
            child: Transform.rotate(
              angle: 5.5, // 180 degrees (PI radians)
              child: Image.asset(
                REGISTER_WAVE,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 180,
            left: -25,
            child: Transform.rotate(
              angle: 0, // 180 degrees (PI radians)
              child: Image.asset(
                REGISTER_WAVE,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 220,
            right: -85,
            child: Transform.rotate(
              angle: 0.5, // 180 degrees (PI radians)
              child: Image.asset(
                REGISTER_WAVE,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
              top: 200,
              left: 20,
              right: 20,
              child: Column(
                children: [
                  Text("Create your account",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      )),
                  SizedBox(
                    height: 105,
                  ),
                  CustomTextField(
                    hintText: "Name",
                    backgroundColor: appTertiary.withAlpha(70),
                    borderColor: Colors.transparent,
                    controller: nameController,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                    hintText: "Email",
                    backgroundColor: appTertiary.withAlpha(70),
                    borderColor: Colors.transparent,
                    controller: emailController,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                    hintText: 'Password',
                    backgroundColor: appTertiary.withAlpha(70),
                    borderColor: Colors.transparent,
                    isPassword: true,
                    controller: passwordController,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  CustomBlueButton(
                      text: "Get Started",
                      onPressed: () {
                        print(nameController.text);
                        Get.offAll(() => const BaseView());
                      })
                ],
              )),
          Positioned(
              top: 60, // Adjust as needed
              left: 25,
              child: CustomBackButton()),
        ],
      ),
    );
  }
}
