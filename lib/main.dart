import 'package:final_year/Controller/singup_controler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Controller/Splash_controler.dart';
import 'Controller/login_controller.dart';
import 'View/splash_view.dart';
import 'View/login_view.dart';

void main() {
  Get.lazyPut<LoginController>(() => LoginController());
  Get.lazyPut<SignupController>(
      () => SignupController()); // Register it once app starts
  // Register it once app starts

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
      //  GetPage(
      //   name: '/Singup',
      //   // page: () => SignupView(),
      //   binding: BindingsBuilder(() {
      //     Get.put(SignupController());
      //   }),
      // ),
    ],
  ));
}
