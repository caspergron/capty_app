import 'dart:convert';

import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/models/chat/chat_buddy.dart';
import 'package:app/models/chat/chat_content.dart';
import 'package:app/models/common/end_user.dart';
import 'package:app/models/marketplace/sales_ad.dart';
import 'package:app/preferences/user_preferences.dart';

class ChatMessage {
  int? id;
  int? senderId;
  int? receiverId;
  bool? isOnline;
  String? type;
  String? message;
  String? data;
  EndUser? endUser;
  String? sendTime;
  String? readTime;
  String? updatedAt;
  String? createdAt;
  List<ChatContent>? contents;
  String? chatStatus;
  int? sendTimeInMS;
  int dateMilliSecond = 00000;
  SalesAd? salesAd;

  bool get is_read => senderId == UserPreferences.user.id || readTime != null;
  bool get is_online => isOnline != null && isOnline == true;

  ChatBuddy get chat_buddy => ChatBuddy(id: endUser?.id, name: endUser?.name, media: endUser?.media, isOnline: isOnline);
  bool get chat_status => id != null && chatStatus != null && (chatStatus.toKey == 'sent'.toKey || chatStatus.toKey == 'received'.toKey);

  List<ChatContent> get chat_images {
    if (type == null || type != 'mixed' || !contents.haveList) return [];
    return contents!.where((item) => item.type != null && item.type!.split('/').first.toKey == 'image'.toKey).toList();
  }

  List<ChatContent> get chat_files {
    if (type == null || type != 'mixed' || !contents.haveList) return [];
    return contents!.where((item) => item.type != null && item.type!.split('/').first.toKey == 'application'.toKey).toList();
  }

  SalesAd? get sales_ad_info {
    if ((type.toKey != 'json'.toKey) || data == null) return null;
    return SalesAd.fromJson(jsonDecode(data!));
  }

  ChatMessage({
    this.id,
    this.senderId,
    this.receiverId,
    this.isOnline,
    this.type,
    this.message,
    this.data,
    this.endUser,
    this.sendTime,
    this.readTime,
    this.updatedAt,
    this.createdAt,
    this.contents,
    this.chatStatus,
    this.sendTimeInMS,
    this.dateMilliSecond = 00000,
    this.salesAd,
  });

  ChatMessage.fromJson(json) {
    id = json['id'];
    senderId = json['sender_id'];
    receiverId = json['receiver_id'];
    isOnline = json['is_online'];
    type = json['type'];
    message = json['msg'];
    data = json['data'];
    endUser = json['sender_user'] != null ? EndUser.fromJson(json['sender_user']) : null;
    sendTime = json['send_t'];
    readTime = json['read_t'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    contents = [];
    if (json['contents'] != null) json['contents'].forEach((v) => contents?.add(ChatContent.fromJson(v)));
    chatStatus = json['direction'];
    sendTimeInMS = json['send_time_in_sec'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['sender_id'] = senderId;
    map['receiver_id'] = receiverId;
    map['is_online'] = isOnline;
    map['type'] = type;
    map['msg'] = message;
    map['data'] = data;
    if (endUser != null) map['sender_user'] = endUser?.toJson();
    map['send_t'] = sendTime;
    map['read_t'] = readTime;
    map['updated_at'] = updatedAt;
    map['created_at'] = createdAt;
    if (contents != null) map['contents'] = contents?.map((v) => v.toJson()).toList();
    map['direction'] = chatStatus;
    map['send_time_in_sec'] = sendTimeInMS;
    map['sales_ad'] = salesAd?.toJson();
    return map;
  }
}
