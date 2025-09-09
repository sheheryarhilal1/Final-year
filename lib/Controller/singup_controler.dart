import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  var email = ''.obs;
  var password = ''.obs;
  var confirmPassword = ''.obs;
  var username = ''.obs;

  // ✅ static variables jo globally accessible rahenge
  static String savedUsername = "";
  static String savedPassword = "";

  var isPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  void signup() async {
    if (password.value != confirmPassword.value) {
      Get.snackbar("Error", "Passwords do not match");
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.value.trim(),
        password: password.value.trim(),
      );

      // ✅ Save username & password globally
      savedUsername = username.value.trim();
      savedPassword = password.value.trim();

      Get.snackbar("Success", "Account created for ${email.value}");
      Get.offNamed('/login');
    } catch (e) {
      Get.snackbar("Sign Up Failed", e.toString(),
          snackPosition: SnackPosition.TOP,
          colorText: Colors.greenAccent);
    }
  }

  void goToLogin() {
    Get.toNamed('/login');
  }
}
