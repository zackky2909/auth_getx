import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_register/model/usermodel.dart';

class ChatRoomController extends GetxController {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  late TextEditingController chatController;
  late ScrollController scrollController;

  Stream<QuerySnapshot<Map<String, dynamic>>> streamChats(String chat_id) {
    CollectionReference chats = firebaseFirestore.collection("chats");

    return chats.doc(chat_id).collection("chat").orderBy("time").snapshots();
  }

  Stream<DocumentSnapshot<Object?>> streamFriendData(String friendEmail) {
    CollectionReference users = firebaseFirestore.collection("users");

    return users.doc(friendEmail).snapshots();
  }

  void newChat(String email, Map<String, dynamic> argument, String chat) async {
    if (chat != '') {
      CollectionReference chats = firebaseFirestore.collection("chats");
      CollectionReference users = firebaseFirestore.collection("users");
      String date = DateTime.now().toIso8601String();

      await chats.doc(argument["chat_id"]).collection("chat").add({
        "email": email,
        "talkTo": argument["friendEmail"],
        "msg": chat,
        "time": date,
      });

      Timer(
        Duration.zero,
        () =>
            scrollController.jumpTo(scrollController.position.maxScrollExtent),
      );

      chatController.clear();

      await users
          .doc(email)
          .collection("chats")
          .doc(argument["chat_id"])
          .update({
        "lastTime": date,
      });
    }
  }

  @override
  void onInit() {
    super.onInit();
    chatController = TextEditingController();
    scrollController = ScrollController();
  }

  @override
  void onClose() {
    chatController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
