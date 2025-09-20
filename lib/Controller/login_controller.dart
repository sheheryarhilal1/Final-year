import 'package:final_year/View/qr_generator.dart';
import 'package:final_year/View/qr_scanner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'singup_controler.dart';

class LoginController extends GetxController {
  var email = ''.obs;
  var password = ''.obs;
  var isPasswordHidden = true.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void login() async {
    try {
      // ✅ Firebase login
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.value.trim(),
        password: password.value.trim(),
      );

      // ✅ Save email & password to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("user_email", email.value.trim());
      await prefs.setString("user_password", password.value.trim());

      // ✅ Load back into SignupController for global access
      SignupController.savedUsername =
          prefs.getString("username") ?? email.value.split('@')[0];
      SignupController.savedPassword =
          prefs.getString("user_password") ?? password.value.trim();

      // ✅ Navigate to QR Generator screen
      await Future.delayed(const Duration(milliseconds: 800));
      Get.to(() =>QRManagerScreen() );

      // ✅ Success snackbar
      Get.snackbar(
        "Success",
        "Logged in successfully!",
        snackPosition: SnackPosition.TOP,
        colorText: Colors.greenAccent,
      );
    } catch (e) {
      // ❌ Error snackbar
      Get.snackbar(
        "Login Failed",
        e.toString(),
        snackPosition: SnackPosition.TOP,
        colorText: Colors.greenAccent,
      );
    }
  }
}
