import 'package:get/get.dart';

class BoolController extends GetxController {
  bool isVisible = false;

  void changeVisible() {
    isVisible = !isVisible;
    update();
  }
}
