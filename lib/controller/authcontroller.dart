// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_register/model/usermodel.dart';
import 'package:test_register/routes/route.dart';
import '../root.dart';

class AuthController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  var isSignedIn = false.obs;
  var user = UserModel().obs;
  UserCredential? userCredential;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  User? get currentUser => auth.currentUser;

  @override
  void onInit() {
    isSignedIn.value = currentUser != null;
    print(user);
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
    emailController.clear();
    passwordController.clear();
  }

  void signUp(String email, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
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
    try {
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        userCredential = value;
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

    CollectionReference users = firebaseFirestore.collection('users');

    final setDataUser = await users.doc(currentUser!.email).get();
    if (setDataUser.data() == null) {
      await users.doc(currentUser!.email).set({
        'uuid': userCredential!.user!.uid,
        'name': currentUser!.displayName,
        'email': currentUser!.email,
        'photoUrl': currentUser!.photoURL ?? 'noimage',
        "creationTime":
            userCredential!.user!.metadata.creationTime!.toIso8601String(),
        "lastSignInTime":
            userCredential!.user!.metadata.lastSignInTime!.toIso8601String(),
        "updatedTime": DateTime.now().toIso8601String(),
      });

      await users.doc(currentUser!.email).collection("chats");
    } else {
      await users.doc(currentUser!.email).update({
        "lastSignInTime":
            userCredential!.user!.metadata.lastSignInTime!.toIso8601String(),
      });
    }

    await users.doc(currentUser!.email).update({
      'lastTimeSignedIn':
          userCredential!.user!.metadata.lastSignInTime!.toIso8601String()
    });

    final curUser = await users.doc(currentUser!.email).get();
    final curUserData = curUser.data() as Map<String, dynamic>;

    user(UserModel.fromJson(curUserData));
    user.refresh();

    final listChats =
        await users.doc(currentUser!.email).collection('chats').get();

    if (listChats.docs.isNotEmpty) {
      List<ChatUser> dataListChats = [];
      listChats.docs.forEach((element) {
        var dataDocChat = element.data();
        var dataDocChatId = element.id;
        dataListChats.add(ChatUser(
          chatId: dataDocChat['chatId'],
          lastTime: dataDocChat['lastTime'],
          talkTo: dataDocChat['talkTo'],
        ));
      });

      user.update((user) {
        user!.chats = dataListChats;
      });
    } else {
      user.update((user) {
        user!.chats = [];
      });
    }
    user.refresh();
    print(user.value.email);
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

  void updatePhotoUrl(String url) async {
    String date = DateTime.now().toIso8601String();
    CollectionReference users = firebaseFirestore.collection('users');
    await users.doc(currentUser!.photoURL).update({
      'photoUrl': url,
      'updatedTime': date,
    });

    user.update((user) {
      user!.photoUrl = url;
      user.updatedTime = date;
    });
    user.refresh();
    Get.defaultDialog(
        title: "Success", middleText: "Change photo profile success");
  }

  void addNewConnection(String friendEmail) async {
    bool haveNewFriend = false;
    var chatId;
    String date = DateTime.now().toIso8601String();
    CollectionReference chats = firebaseFirestore.collection("chats");
    CollectionReference users = firebaseFirestore.collection("users");

    final docChats =
        await users.doc(currentUser!.email).collection('chats').get();

    if (docChats.docs.isNotEmpty) {
      final checkConnection = await users
          .doc(currentUser!.email)
          .collection('chats')
          .where('connection', isEqualTo: friendEmail)
          .get();

      if (checkConnection.docs.isNotEmpty) {
        haveNewFriend = false;
        chatId = checkConnection.docs[0].id;
      } else {
        haveNewFriend = true;
      }
    } else {
      haveNewFriend = true;
    }

    if (haveNewFriend) {
      final chatsDocs = await chats.where(
        "connection",
        whereIn: [
          [
            currentUser!.email,
            friendEmail,
          ],
          [
            friendEmail,
            currentUser!.email,
          ],
        ],
      ).get();

      if (chatsDocs.docs.isNotEmpty) {
        final chatDataId = chatsDocs.docs[0].id;
        final chatsData = chatsDocs.docs[0].data() as Map<String, dynamic>;

        await users
            .doc(currentUser!.email)
            .collection('chats')
            .doc(chatDataId)
            .set({
          'connection': friendEmail,
          'lastTime': chatsData['lastTime'],
        });

        final listChats =
            await users.doc(currentUser!.email).collection("chats").get();
        if (listChats.docs.isNotEmpty) {
          List<ChatUser> dataListChats = List<ChatUser>.empty();
          listChats.docs.forEach((element) {
            var dataDocChat = element.data();
            var dataDocChatId = element.id;
            dataListChats.add(ChatUser(
              talkTo: dataDocChat['connection'],
              lastTime: dataDocChat['lastTime'],
              chatId: dataDocChatId,
            ));
          });
          user.update((user) {
            user!.chats = dataListChats;
          });
        } else {
          user.update((user) {
            user!.chats = [];
          });
        }

        chatId = chatDataId;

        user.refresh();
      } else {
        final newChatDoc = await chats.add({
          "connection": [
            currentUser!.email,
            friendEmail,
          ],
        });

        await chats.doc(newChatDoc.id).collection("chat");

        await users
            .doc(currentUser!.email)
            .collection("chats")
            .doc(newChatDoc.id)
            .set({
          "connection": friendEmail,
          "lastTime": date,
        });

        final listChats =
            await users.doc(currentUser!.email).collection("chats").get();
        if (listChats.docs.isNotEmpty) {
          List<ChatUser> dataListChats = List<ChatUser>.empty();
          listChats.docs.forEach((element) {
            var dataDocChat = element.data();
            var dataDocChatId = element.id;
            dataListChats.add(ChatUser(
              talkTo: dataDocChat['connection'],
              lastTime: dataDocChat['lastTime'],
              chatId: dataDocChatId,
            ));
          });
          user.update((user) {
            user!.chats = dataListChats;
          });
        } else {
          user.update((user) {
            user!.chats = [];
          });
        }

        chatId = newChatDoc.id;

        user.refresh();
      }
    }
    Get.toNamed(
      AppRoute.chatroom,
      arguments: {
        "chatId": "$chatId",
        "friendEmail": friendEmail,
      },
    );
  }
}

extension StringExtension on String {
  String capitalizeString() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
