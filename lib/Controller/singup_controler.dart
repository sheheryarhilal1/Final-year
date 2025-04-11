import 'package:get/get.dart';

class SignupController extends GetxController {
  var email = ''.obs;
  var password = ''.obs;
  var isPasswordHidden = true.obs;

  var isConfirmPasswordHidden;

  var confirmPassword;

  var toggleConfirmPasswordVisibility;

  var username;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void signup() {
    Get.snackbar("Sign Up", "Account created for ${email.value}");
    Get.put(SignupController());
  }

  void goToLogin() {
    Get.toNamed('/login');
  }
}
