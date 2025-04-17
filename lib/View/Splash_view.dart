import 'package:final_year/Controller/Splash_controler.dart';
import 'package:final_year/Controller/login_controller.dart';
import 'package:final_year/View/login_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashView extends GetView<SplashController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🟢 App name badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                // decoration: BoxDecoration(
                //   color: Colors.greenAccent.shade400,
                //   borderRadius: BorderRadius.circular(20),
                // ),
                // child: const Text(
                //   "Personal AI Buddy",
                //   style: TextStyle(
                //     color: Colors.black,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
              ),

              const SizedBox(height: 40),

              // 🤖 Robot Icon
              Container(
                height: 130,
                width: 130,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [Color(0xFFADFF2F), Colors.black],
                    radius: 0.8,
                  ),
                ),
                child: const Icon(Icons.android, size: 80, color: Colors.black),
              ),

              // 📃 Text after the image
              const SizedBox(height: 30),
              const Text(
                "BIOSYNC\n"
                "How may I help you!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFADFF2F),
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 50),

              ElevatedButton(
                onPressed: () {
                  Get.snackbar(
                    "Login",
                    "Redirecting to login screen...",
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: const Color(0xFFADFF2F),
                    colorText: Colors.black,
                    duration: const Duration(milliseconds: 1000),
                  );

                  Future.delayed(const Duration(milliseconds: 100), () {
                    Get.put(LoginController());
                    Get.to(
                      () => LoginView(),
                      transition: Transition.rightToLeft,
                      duration: const Duration(milliseconds: 600),
                    );
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFADFF2F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: const Text(
                  "Get Started",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
