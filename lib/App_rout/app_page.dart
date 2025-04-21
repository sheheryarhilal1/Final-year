import 'package:final_year/View/Splash_view.dart';
import 'package:final_year/View/login_view.dart';
import 'package:final_year/View/singup_view.dart';
import 'package:final_year/binding/Splash_bind.dart';
import 'package:final_year/binding/login_binding.dart';
import 'package:final_year/binding/singup_binding.dart';
import 'package:get/get.dart';

class AppPages {
  static const initial = '/splash';

  static final routes = [
    GetPage(
        name: '/splash', page: () => SplashView(), binding: SplashBinding()),
    GetPage(name: '/login', page: () => LoginView(), binding: LoginBinding()),
    GetPage(
      name: '/signup',
      page: () => SignupView(),
      binding: SignupBinding(),
    )
  ];
}
