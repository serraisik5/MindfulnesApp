import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    super.key,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        "Minder",
        style: const TextStyle(color: Colors.black),
      ),
      centerTitle: true,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(bottom == null ? kToolbarHeight : kToolbarHeight + 40);
}
