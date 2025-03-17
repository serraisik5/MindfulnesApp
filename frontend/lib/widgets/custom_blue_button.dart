import 'package:flutter/material.dart';
import 'package:minder_frontend/helpers/constants/colors.dart';

class CustomBlueButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double width;
  final double height;

  const CustomBlueButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width = double.infinity, // Default to full width
    this.height = 58.0, // Default height
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: appPrimary, // Custom blue color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // Rounded corners
          ),
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white, // White text
          ),
        ),
      ),
    );
  }
}
