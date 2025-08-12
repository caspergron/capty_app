import 'package:app/models/chat/chat_message.dart';

class PusherMessage {
  ChatMessage? message;

  PusherMessage({this.message});

  PusherMessage.fromJson(json) {
    message = json['message'] != null ? ChatMessage.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (message != null) map['message'] = message?.toJson();
    return map;
  }
}
