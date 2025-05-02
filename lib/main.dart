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
  await Firebase.initializeApp();
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

// // import 'package:final_year/View/Home_qr_view.dart';
// // import 'package:final_year/View/qr_vie.dart';
// // import 'package:final_year/binding/attendence_binding.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';

// // void main() {
// //   runApp(MyApp());
// // }

// // class MyApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return GetMaterialApp(
// //       initialBinding: AttendanceBinding(),
// //       home: QRGeneratorScreen(),
// //     );
// //   }
// // }

// import 'package:final_year/View/qr_popup.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// // import 'views/attendance_form_view.dart';

// void main() {
//   runApp(GetMaterialApp(
//     home: Scaffold(
//       appBar: AppBar(title: Text('QR Scanner Demo')),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             Get.dialog(AttendanceFormView());
//           },
//           child: Text('Simulate QR Scan'),
//         ),
//       ),
//     ),
//   ));
// }
