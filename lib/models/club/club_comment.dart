import 'package:app/models/user/user.dart';

class ClubComment {
  int? id;
  int? clubEventId;
  int? userId;
  String? comment;
  User? user;
  String? createdAt;
  int dateMS = 00000;

  ClubComment({this.id, this.clubEventId, this.userId, this.comment, this.user, this.createdAt, this.dateMS = 00000});

  ClubComment.fromJson(json) {
    id = json['id'];
    clubEventId = json['club_event_id'];
    userId = json['user_id'];
    comment = json['comment'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['club_event_id'] = clubEventId;
    map['user_id'] = userId;
    map['comment'] = comment;
    if (user != null) map['user'] = user?.toJson();
    map['created_at'] = createdAt;
    return map;
  }
}
