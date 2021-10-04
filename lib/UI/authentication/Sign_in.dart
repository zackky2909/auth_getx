// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names, prefer_const_constructors_in_immutables
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:test_register/UI/screens/home_screen.dart';
import 'package:test_register/components/button.dart';
import 'package:test_register/components/textform.dart';
import 'package:test_register/controller/authcontroller.dart';
import 'package:test_register/controller/boolcontroller.dart';

import 'package:test_register/setup/constant.dart';

class SignIn extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());

  SignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BoolController boolController = Get.put(BoolController());
    final AuthController authController = Get.put(AuthController());
    return Scaffold(
      backgroundColor: color3,
      appBar: AppBar(
        title: Text(
          'Sign in',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
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
                  SizedBox(height: 20),
                  SizedBox(height: 100),
                  BottomButton(
                    press: () {
                      authController.signIn(authController.emailController.text,
                          authController.passwordController.text);
                      Get.to(() => ChatHomeScreen());
                    },
                    color: color1,
                    text: 'Continue',
                    textColor: Colors.white,
                  ),
                ],
              ),
              SizedBox(height: 30),
              Text('or sign in with',
                  style:
                      TextStyle(fontSize: 14, color: color1.withOpacity(0.5))),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildSocialButton(
                      child: SvgPicture.asset('assets/icons/facebook-2.svg')),
                  buildSocialButton(
                      child: SvgPicture.asset('assets/icons/google-icon.svg')),
                  buildSocialButton(
                      child: SvgPicture.asset('assets/icons/twitter.svg')),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildSocialButton({required Widget child}) {
  return Container(
    height: 55,
    width: 55,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: color4,
    ),
    child: Padding(
      padding: EdgeInsets.all(15),
      child: child,
    ),
  );
}
