import 'package:final_year/View/QR_CODE.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  var email = ''.obs;
  var password = ''.obs;
  var isPasswordHidden = true.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void login() async {
    // You can replace this with real login logic
    Get.snackbar("Login", "Logged in as ${email.value}");
    Future.delayed(const Duration(seconds: 500000));
    await Get.to(() => QRCodeScanner());
  }

  void goToSignUp() {
    Get.snackbar("Sign Up", "Navigate to Sign Up screen");
    // Navigate to SignUpView here (if created)
  }
}
