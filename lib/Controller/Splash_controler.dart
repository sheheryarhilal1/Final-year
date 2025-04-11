import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  void goToNext() {
    // Show Snackbar
    Get.snackbar(
      "Login",
      "Redirecting to login screen...",
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFFADFF2F),
      colorText: Colors.black,
      duration: const Duration(seconds: 1),
    );

    // Navigate after slight delay
    Future.delayed(const Duration(milliseconds: 800), () {
      // Get.toNamed('/LoginView');
      Get.toNamed('/LoginView');

    });
  }
}
