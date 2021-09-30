// ignore_for_file: prefer_const_constructors
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_register/controller/authcontroller.dart';
import 'package:test_register/root.dart';
import 'package:test_register/routes/route.dart';
import 'package:test_register/setup/constant.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthController authController =
      Get.put(AuthController(), permanent: true);

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: themeData(),
        getPages: Routes.routes,
        home: Root());
  }
}

ThemeData themeData() {
  return ThemeData(
    fontFamily: 'Muli',
    appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: TextStyle(
            color: color1,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            fontFamily: 'Muli'),
        iconTheme: IconThemeData(color: color1)),
  );
}
