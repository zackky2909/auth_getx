// ignore_for_file: prefer_const_constructors
import 'package:get/get.dart';
import 'package:test_register/UI/authentication/Sign_in.dart';
import 'package:test_register/UI/authentication/Sign_up.dart';
import 'package:test_register/UI/authentication/splash_screen.dart';
import 'package:test_register/UI/home/home_screen.dart';
part 'approute.dart';

class Routes {
  static final routes = [
    GetPage(name: AppRoute.signin, page: () => SignIn()),
    GetPage(name: AppRoute.signup, page: () => SignUp()),
    GetPage(name: AppRoute.homescreen, page: () => HomeScreen()),
    GetPage(name: AppRoute.splash, page: () => SplashScreen()),
  ];
}
