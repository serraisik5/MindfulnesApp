import 'package:flutter/material.dart';
import 'package:minder_frontend/helpers/constants/colors.dart';

class AppTextStyles {
  static const TextStyle heading = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    letterSpacing: 1,
  );

  static const TextStyle subheading = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.8,
  );

  static const TextStyle lightheading = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w300,
      letterSpacing: 0.8,
      color: appTertiary);

  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.5,
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
}
