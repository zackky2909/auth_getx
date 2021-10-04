import 'package:get/get.dart';
import 'package:test_register/controller/chatcontroller.dart';

class ChatRoomBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatRoomController>(
      () => ChatRoomController(),
    );
  }
}
