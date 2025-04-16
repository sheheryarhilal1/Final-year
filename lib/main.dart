import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Controller/singup_controler.dart';
import 'Controller/Splash_controler.dart';
import 'Controller/login_controller.dart';
import 'View/splash_view.dart';
import 'View/login_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // 🔥 Firebase Init

  // Register Controllers lazily
  Get.lazyPut<LoginController>(() => LoginController());
  Get.lazyPut<SignupController>(() => SignupController());

  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/splash',
    getPages: [
      GetPage(
        name: '/splash',
        page: () => SplashView(),
        binding: BindingsBuilder(() {
          Get.put(SplashController());
        }),
      ),
      GetPage(
        name: '/login',
        page: () => LoginView(),
        binding: BindingsBuilder(() {
          Get.put(LoginController());
          Get.put(SignupController());
        }),
      ),
    ],
  ));
}
