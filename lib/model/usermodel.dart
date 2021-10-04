class UserModel {
  String? uuid;
  String? name;
  String? photoUrl;
  String? email;
  String? creationTime;
  String? updatedTime;
  String? lastSignInTime;
  List<ChatUser>? chats;

  UserModel(
      {this.uuid,
      this.name,
      this.photoUrl,
      this.email,
      this.creationTime,
      this.updatedTime,
      this.lastSignInTime});

  factory UserModel.fromJson(dynamic json) => UserModel(
        uuid: json['uuid'],
        name: json['name'],
        photoUrl: json['photoUrl'],
        email: json['email'],
        creationTime: json['creationTime'],
        updatedTime: json['updatedTime'],
        lastSignInTime: json['lastSignInTime'],
      );

  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'name': name,
        'photoUrl': photoUrl,
        'email': email,
      };
}

class ChatUser {
  String? talkTo;
  String? chatId;
  String? lastTime;

  ChatUser({this.talkTo, this.chatId, this.lastTime});

  factory ChatUser.fromJson(dynamic json) => ChatUser(
        talkTo: json['talkTo'],
        chatId: json['chatId'],
        lastTime: json['lastTime'],
      );

  Map<String, dynamic> toJson(dynamic json) => {
        'talkTo': talkTo,
        'chatId': chatId,
        'lastTime': lastTime,
      };
}
