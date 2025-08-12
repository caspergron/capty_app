import 'package:app/models/friend/friend_info.dart';

class Friend {
  int? id;
  int? requestBy;
  int? requestTo;
  FriendInfo? requestByUser;
  FriendInfo? requestToUser;
  int? status;
  String? createdAt;
  String? updatedAt;

  Friend({
    this.id,
    this.requestBy,
    this.requestTo,
    this.requestByUser,
    this.requestToUser,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  Friend.fromJson(json) {
    id = json['id'];
    requestBy = json['request_by'];
    requestTo = json['request_to'];
    requestByUser = json['request_by_user'] != null ? FriendInfo.fromJson(json['request_by_user']) : null;
    requestToUser = json['request_to_user'] != null ? FriendInfo.fromJson(json['request_to_user']) : null;
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['request_by'] = requestBy;
    map['request_to'] = requestTo;
    if (requestByUser != null) map['request_by_user'] = requestByUser?.toJson();
    if (requestToUser != null) map['request_to_user'] = requestToUser?.toJson();
    map['status'] = status;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }

  Map<String, dynamic> get analyticParams => {'request_id': id, 'request_by_id': requestBy, 'request_to_id': requestTo};
}
