import 'package:app/models/chat/chat_message.dart';

class ChatsApi {
  bool? success;
  String? message;
  List<ChatMessage>? chats;

  ChatsApi({this.success, this.message, this.chats});

  ChatsApi.fromJson(json) {
    success = json['success'];
    message = json['message'];
    chats = [];
    if (json['data'] != null) json['data'].forEach((v) => chats?.add(ChatMessage.fromJson(v)));
  }

  ChatsApi copyWith({bool? success, String? message, List<ChatMessage>? chats}) {
    return ChatsApi(
      success: success ?? this.success,
      message: message ?? this.message,
      chats: chats ?? this.chats,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    if (chats != null) map['data'] = chats?.map((v) => v.toJson()).toList();
    return map;
  }
}
