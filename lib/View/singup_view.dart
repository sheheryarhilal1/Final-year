import 'package:final_year/Controller/singup_controler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';

class SignupView extends GetView<SignupController> {
  final SignupController controller = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image at the top
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
                  child: Icon(Icons.android, size: 80, color: Colors.black),
                ),

                const SizedBox(height: 20),

                Center(
                  child: const Text(
                    " Register with BIOSYNC",
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      // letterSpacing: 2,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.85,
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.greenAccent,
                            width: 3,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              "Sign Up",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.greenAccent,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 30),
                            TextField(
                              onChanged: (val) => controller.email.value = val,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                hintText: 'Email',
                                hintStyle: TextStyle(color: Colors.greenAccent),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.greenAccent),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextField(
                              onChanged: (val) =>
                                  controller.username.value = val,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                hintText: 'Username',
                                hintStyle: TextStyle(color: Colors.greenAccent),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.greenAccent),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Obx(() => TextField(
                                  onChanged: (val) =>
                                      controller.password.value = val,
                                  obscureText:
                                      controller.isPasswordHidden.value,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: 'Password',
                                    hintStyle: const TextStyle(
                                        color: Colors.greenAccent),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        controller.isPasswordHidden.value
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.greenAccent,
                                      ),
                                      onPressed:
                                          controller.togglePasswordVisibility,
                                    ),
                                    enabledBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.greenAccent),
                                    ),
                                  ),
                                )),
                            const SizedBox(height: 20),
                            Obx(() => TextField(
                                  onChanged: (val) =>
                                      controller.confirmPassword.value = val,
                                  obscureText:
                                      controller.isPasswordHidden.value,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: ' Confirm Password',
                                    hintStyle: const TextStyle(
                                        color: Colors.greenAccent),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        controller.isPasswordHidden.value
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.greenAccent,
                                      ),
                                      onPressed:
                                          controller.togglePasswordVisibility,
                                    ),
                                    enabledBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.greenAccent),
                                    ),
                                  ),
                                )),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: controller.signup,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.greenAccent,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text("Sign Up"),
                            ),
                            TextButton(
                              onPressed: () => Get.toNamed('/login'),
                              child: const Text(
                                "Already have an account? Login",
                                style: TextStyle(color: Colors.greenAccent),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}