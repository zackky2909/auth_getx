// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:test_register/UI/authentication/splash_screen.dart';
import 'package:test_register/UI/screens/home_screen.dart';

import 'controller/authcontroller.dart';

class Root extends StatelessWidget {
  const Root({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<AuthController>(
        builder: (_) {
          print(_.isSignedIn);
          return SafeArea(
            child: _.isSignedIn.value ? ChatHomeScreen() : SplashScreen(),
          );
        },
      ),
    );
  }
}
