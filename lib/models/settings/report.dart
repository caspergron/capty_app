import 'package:app/models/common/end_user.dart';

class Report {
  int? id;
  EndUser? user;
  String? title;
  String? description;
  String? type;
  int? votes;
  String? createdAt;
  String? updatedAt;

  Report({
    this.id,
    this.user,
    this.title,
    this.description,
    this.type,
    this.votes,
    this.createdAt,
    this.updatedAt,
  });

  Report.fromJson(json) {
    id = json['id'];
    user = json['user'] != null ? EndUser.fromJson(json['user']) : null;
    title = json['title'];
    description = json['description'];
    type = json['type'];
    votes = json['votes'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    if (user != null) map['user'] = user?.toJson();
    map['title'] = title;
    map['description'] = description;
    map['type'] = type;
    map['votes'] = votes;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }
}
