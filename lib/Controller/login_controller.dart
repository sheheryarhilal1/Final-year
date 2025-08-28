import 'package:final_year/View/NAV_BAR/Nav_bar.dart';
import 'package:final_year/View/qr_generator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  var email = ''.obs;
  var password = ''.obs;
  var isPasswordHidden = true.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.value.trim(),
        password: password.value.trim(),
      );

      await Future.delayed(const Duration(milliseconds: 800));
      Get.to(() => QRGeneratorScreen());

      Get.snackbar("Success", "Logged in successfully!",
          snackPosition: SnackPosition.TOP,
          colorText: Colors.greenAccent);
    } catch (e) {
      Get.snackbar("Login Failed", e.toString(),
          snackPosition: SnackPosition.TOP,
          // backgroundColor: Colors.redAccent,
          colorText: Colors.greenAccent);
    }
  }
}