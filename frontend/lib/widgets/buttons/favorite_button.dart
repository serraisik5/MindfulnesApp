import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minder_frontend/helpers/constants/colors.dart';

class CustomFavoriteButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double size;
  final Color borderColor;
  final Color iconColor;
  final Color backgroundColor;

  const CustomFavoriteButton({
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
      onTap: onPressed ?? () => print("added to favorites"),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
          border: Border.all(color: borderColor, width: 0.5),
        ),
        child: Center(
          child: Icon(
            Icons.favorite,
            color: iconColor,
            size: size * 0.5, // Scales icon size
          ),
        ),
      ),
    );
  }
}
