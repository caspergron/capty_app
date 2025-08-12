import 'package:app/models/common/meta.dart';
import 'package:app/models/friend/friend_info.dart';

class SearchFriendApi {
  bool? success;
  String? message;
  Meta? meta;
  List<FriendInfo>? friends;

  SearchFriendApi({this.success, this.message, this.meta, this.friends});

  SearchFriendApi.fromJson(json) {
    success = json['success'];
    message = json['message'];
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
    friends = [];
    if (json['data'] != null) json['data'].forEach((v) => friends?.add(FriendInfo.fromJson(v)));
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
