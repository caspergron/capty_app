import 'package:app/models/common/end_user.dart';

class FeatureComment {
  int? id;
  String? message;
  EndUser? user;
  String? createdAt;

  FeatureComment({this.id, this.message, this.user, this.createdAt});

  FeatureComment.fromJson(json) {
    id = json['id'];
    message = json['message'];
    user = json['user'] != null ? EndUser.fromJson(json['user']) : null;
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['message'] = message;
    if (user != null) map['user'] = user?.toJson();
    map['created_at'] = createdAt;
    return map;
  }
}
