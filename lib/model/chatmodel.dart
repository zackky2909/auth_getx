class Chats {
  Chats({
    this.connection,
    this.chat,
  });

  List<String>? connection;
  List<Chat>? chat;

  factory Chats.fromJson(Map<String, dynamic> json) => Chats(
        connection: List<String>.from(json["connections"].map((x) => x)),
        chat: List<Chat>.from(json["chat"].map((x) => Chat.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "connections": List<dynamic>.from(connection!.map((x) => x)),
        "chat": List<dynamic>.from(chat!.map((x) => x.toJson())),
      };
}

class Chat {
  Chat({
    this.time,
  });

  String? time;

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        time: json["time"],
      );

  Map<String, dynamic> toJson() => {
        "time": time,
      };
}
