import 'package:flutter/material.dart';
import 'package:minder_frontend/helpers/constants/colors.dart';

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final double scale;
  final double borderRadius;
  final Color activeColor;
  final Color borderColor;

  const CustomCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.scale = 1.2,
    this.borderRadius = 4.0,
    this.activeColor = appPrimary,
    this.borderColor = appPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: Checkbox(
        value: value,
        onChanged: onChanged,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        activeColor: activeColor,
        side: BorderSide(color: borderColor, width: 1),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
