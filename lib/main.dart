import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Controller/singup_controler.dart';
import 'Controller/Splash_controler.dart';
import 'Controller/login_controller.dart';
import 'View/splash_view.dart';
import 'View/login_view.dart';
import 'firebase_options.dart'; // ✅ Add this

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize Firebase for all platforms
  FirebaseApp app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 🔥 Debug print for checking project
  print("🔥 Connected Firebase Project: ${app.options.projectId}");
  print("📂 Database URL: ${app.options.databaseURL}");
  print("🔑 App ID: ${app.options.appId}");

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
