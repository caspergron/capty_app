import 'package:app/models/club/club_comment.dart';

class ClubCommentsApi {
  bool? success;
  String? message;
  List<ClubComment>? comments;

  ClubCommentsApi({this.success, this.message, this.comments});

  ClubCommentsApi.fromJson(json) {
    success = json['success'];
    message = json['message'];
    comments = [];
    if (json['data'] != null) json['data'].forEach((v) => comments?.add(ClubComment.fromJson(v)));
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    if (comments != null) map['data'] = comments?.map((v) => v.toJson()).toList();
    return map;
  }
}
