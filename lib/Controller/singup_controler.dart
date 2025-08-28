import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupController extends GetxController {
  var email = ''.obs;
  var password = ''.obs;
  var confirmPassword = ''.obs;
  var username = ''.obs;

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

      Get.snackbar("Success", "Account created for ${email.value}");
      Get.offNamed('/login'); // or wherever you want to take them after signup
    } catch (e) {
      Get.snackbar("Sign Up Failed", e.toString(),
          snackPosition: SnackPosition.TOP,
          // backgroundColor: Colors.redAccent,
          colorText: Colors.greenAccent);
    }
  }

  void goToLogin() {
    Get.toNamed('/login');
  }
}