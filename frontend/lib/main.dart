import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minder_frontend/modules/base/views/base_view.dart';
import 'package:minder_frontend/modules/home/views/home_view.dart';
import 'package:minder_frontend/modules/login-register/views/login_view.dart';
import 'package:minder_frontend/modules/login-register/views/register_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Mindfulness',
      home: LoginView(),
    );
  }
}
