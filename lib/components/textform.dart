// ignore_for_file: prefer_const_constructors
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_register/controller/authcontroller.dart';
import 'package:test_register/setup/constant.dart';

class TextForm extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final void Function() press;
  final IconData icon1;
  final IconData icon2;
  final bool obscureText;

  TextForm({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.press,
    required this.icon1,
    required this.icon2,
    required this.obscureText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: TextInputType.emailAddress,
      controller: controller,
      decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          labelText: labelText,
          hintText: hintText,
          suffixIcon: Padding(
            padding: EdgeInsets.only(right: 5),
            child: IconButton(
                onPressed: () {
                  press;
                },
                icon: controller.text.isEmpty
                    ? Icon(icon1, color: color1.withOpacity(0.5))
                    : Icon(icon2, color: color1.withOpacity(0.5))),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(width: 1.5, color: color1.withOpacity(0.5)),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(width: 1.5, color: color1))),
    );
  }
}
