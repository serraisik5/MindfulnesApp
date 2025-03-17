import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minder_frontend/helpers/constants/colors.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double size;
  final Color borderColor;
  final Color iconColor;
  final Color backgroundColor;

  const CustomBackButton({
    super.key,
    this.onPressed,
    this.size = 40.0,
    this.borderColor = appTertiary,
    this.iconColor = Colors.black,
    this.backgroundColor = appBackground,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //behavior: HitTestBehavior.translucent, // Expands the hit area
      onTap: onPressed ?? () => Get.back(), // Default action: Go back
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Center(
          child: Icon(
            Icons.arrow_back,
            color: iconColor,
            size: size * 0.5, // Scales icon size
          ),
        ),
      ),
    );
  }
}
