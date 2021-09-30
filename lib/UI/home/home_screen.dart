// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:test_register/controller/authcontroller.dart';
import 'package:test_register/setup/constant.dart';
import 'package:test_register/components/button.dart';

class HomeScreen extends GetWidget {
  List<Color> listColor = [study, work, entertain, family];
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");

  final AuthController authController = Get.put(AuthController());
  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Today',
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold)),
                            SizedBox(height: 10),
                            Text(
                              dateFormat.format(DateTime.now()).toString(),
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ],
                        )),
                        SizedBox(
                          height: 50,
                          width: 100,
                          child: BottomButton(
                              text: 'Log out',
                              color: buttonColor,
                              textColor: Colors.white,
                              press: () {
                                print('a');
                                authController.signout();
                              }),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    DatePicker(DateTime.now(),
                        initialSelectedDate: DateTime.now(),
                        selectedTextColor: Colors.white,
                        selectionColor: buttonColor,
                        deactivatedColor: Colors.grey,
                        dateTextStyle: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                    SizedBox(height: 20),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(
                            listColor.length,
                            (index) => Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Container(
                                    width: 100,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: listColor[index],
                                    ),
                                  ),
                                )),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                  flex: 3,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: List.generate(
                          listColor.length,
                          (index) => Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: Container(
                                  width: double.infinity,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: listColor[index],
                                  ),
                                ),
                              )),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
