import 'package:app/models/common/end_user.dart';
import 'package:app/models/feature/feature_comment.dart';

class Feature {
  int? id;
  EndUser? user;
  String? title;
  String? description;
  String? type;
  int? votes;
  bool? isVoted;
  int? totalVotes;
  String? createdAt;
  String? updatedAt;
  List<FeatureComment>? comments;

  bool get is_voted => isVoted ?? false;

  Feature({
    this.id,
    this.user,
    this.title,
    this.description,
    this.type,
    this.votes,
    this.isVoted,
    this.totalVotes,
    this.createdAt,
    this.updatedAt,
    this.comments,
  });

  Feature.fromJson(json) {
    id = json['id'];
    user = json['user'] != null ? EndUser.fromJson(json['user']) : null;
    title = json['title'];
    description = json['description'];
    type = json['type'];
    votes = json['votes'];
    isVoted = json['has_voted'];
    totalVotes = json['total_votes'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    comments = [];
    if (json['comments'] != null) json['comments'].forEach((v) => comments?.add(FeatureComment.fromJson(v)));
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    if (user != null) map['user'] = user?.toJson();
    map['title'] = title;
    map['description'] = description;
    map['type'] = type;
    map['votes'] = votes;
    map['has_voted'] = isVoted;
    map['total_votes'] = totalVotes;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    if (comments != null) map['comments'] = comments?.map((v) => v.toJson()).toList();
    return map;
  }
}
