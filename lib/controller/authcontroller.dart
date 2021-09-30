// ignore_for_file: prefer_const_constructors
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../root.dart';

class AuthController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  var isSignedIn = false.obs;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();

  User? get user => auth.currentUser;

  @override
  void onInit() {
    isSignedIn.value = user != null;
    emailController = TextEditingController();
    passwordController = TextEditingController();
    TextEditingController confirmpasswordController = TextEditingController();
    super.onInit();
  }

  void signUp(String email, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      Get.offAll(() => Root());
    } on FirebaseAuthException catch (e) {
      String title = e.code.replaceAll(RegExp('-'), ' ').capitalize!;
      String message = '';

      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = ('The account already exists for that email.');
      } else {
        message = e.message.toString();
      }

      Get.snackbar(title, message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black,
          colorText: Colors.yellow);
    } catch (e) {
      Get.snackbar('Error occured!', e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black,
          colorText: Colors.yellow);
    }
  }

  void signIn(String email, String password) async {
    print('a');
    try {
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        print(auth.currentUser);
      });

      update();
    } on FirebaseAuthException catch (e) {
      String title = e.code.replaceAll(RegExp('-'), ' ').capitalize!;

      String message = '';

      if (e.code == 'wrong-password') {
        message = 'Invalid Password. Please try again!';
      } else if (e.code == 'user-not-found') {
        message =
            ('The account does not exists for $email. Create your account by signing up.');
      } else {
        message = e.message.toString();
      }

      Get.snackbar(title, message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black,
          colorText: Colors.yellow);
    } catch (e) {
      Get.snackbar(
        'Error occured!',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black,
        colorText: Colors.yellow,
      );
    }
  }

  void signout() async {
    try {
      print('trang kim');
      await auth.signOut();
      isSignedIn.value = false;
      update();
      Get.offAll(() => Root());
    } catch (e) {
      Get.snackbar('Error occured!', e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black,
          colorText: Colors.yellow);
    }
  }
}

extension StringExtension on String {
  String capitalizeString() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
