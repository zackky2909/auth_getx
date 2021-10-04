// ignore_for_file: prefer_const_constructors, file_names
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_register/UI/screens/home_screen.dart';
import 'package:test_register/components/button.dart';
import 'package:test_register/components/textform.dart';
import 'package:test_register/controller/authcontroller.dart';
import 'package:test_register/controller/boolcontroller.dart';
import 'package:test_register/setup/constant.dart';

class SignUp extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());
  SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BoolController boolController = Get.put(BoolController());
    final AuthController authController = Get.put(AuthController());
    return Scaffold(
      backgroundColor: color3,
      appBar: AppBar(
        title: Text('Sign up',
            style: TextStyle(
                color: color1, fontWeight: FontWeight.bold, fontSize: 16)),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              SizedBox(height: 120),
              Column(
                children: [
                  Form(
                    child: Column(children: [
                      TextForm(
                        controller: authController.emailController,
                        labelText: 'Email',
                        hintText: 'Enter your email',
                        icon: Icon(Icons.email_rounded,
                            color: color1.withOpacity(0.5)),
                        press: () {},
                        obscureText: false,
                      ),
                      SizedBox(height: 20),
                      GetBuilder<BoolController>(
                          init: boolController,
                          builder: (context) {
                            return TextForm(
                              controller: authController.passwordController,
                              labelText: 'Password',
                              hintText: 'At least 8 characters',
                              obscureText: !boolController.isVisible,
                              icon: !boolController.isVisible
                                  ? Icon(Icons.visibility_off,
                                      color: color1.withOpacity(0.5))
                                  : Icon(Icons.visibility,
                                      color: color1.withOpacity(0.5)),
                              press: () {
                                boolController.changeVisible();
                              },
                            );
                          }),
                    ]),
                  ),
                  SizedBox(height: 100),
                  BottomButton(
                    press: () {
                      authController.signUp(
                        authController.emailController.text,
                        authController.passwordController.text,
                      );
                      Get.to(() => ChatHomeScreen());
                    },
                    color: color1,
                    text: 'Continue',
                    textColor: Colors.white,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
