import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:test_register/controller/authcontroller.dart';
import 'package:test_register/model/usermodel.dart';
import 'package:test_register/routes/route.dart';

class HomeController extends GetxController {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  AuthController authController = Get.put(AuthController());
  RxList<UserModel> chatStreamUser = <UserModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    chatStreamUser
        .bindStream(chatStream(authController.user.value.email ?? 'abc'));
  }

  Stream<List<UserModel>> chatStream(String email) {
    return firebaseFirestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get()
        .then((value) => value.docs.map((e) => UserModel.fromJson(e)).toList())
        .asStream();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> friendStream(String email) {
    return firebaseFirestore.collection('users').doc(email).snapshots();
  }

  void goToChatRoom(String chatId, String email, String friendEmail) async {
    CollectionReference chats = firebaseFirestore.collection('chats');
    CollectionReference users = firebaseFirestore.collection('users');

    Get.toNamed(
      AppRoute.chatroom,
      arguments: {
        "chat_id": chatId,
        "friendEmail": friendEmail,
      },
    );
  }
}
