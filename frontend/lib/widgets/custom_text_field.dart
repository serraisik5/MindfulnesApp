import 'package:flutter/material.dart';
import 'package:minder_frontend/helpers/constants/colors.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final Color backgroundColor;
  final Color borderColor;
  final bool isPassword;
  final TextEditingController? controller;

  const CustomTextField({
    Key? key,
    required this.hintText,
    this.backgroundColor = Colors.white,
    this.borderColor = Colors.grey,
    this.isPassword = false,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: appTertiary),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          border: InputBorder.none, // Removes default Flutter border
        ),
      ),
    );
  }
}
