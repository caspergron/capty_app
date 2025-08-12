import 'package:app/models/common/meta.dart';
import 'package:app/models/friend/friend.dart';

class FriendsApi {
  bool? success;
  String? message;
  Meta? meta;
  List<Friend>? friends;

  FriendsApi({this.success, this.message, this.meta, this.friends});

  FriendsApi.fromJson(json) {
    success = json['success'];
    message = json['message'];
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
    friends = [];
    if (json['data'] != null) json['data'].forEach((v) => friends?.add(Friend.fromJson(v)));
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    if (meta != null) map['meta'] = meta?.toJson();
    if (friends != null) map['data'] = friends?.map((v) => v.toJson()).toList();
    return map;
  }
}
