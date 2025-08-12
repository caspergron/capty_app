import 'package:app/models/club/club.dart';
import 'package:app/models/club/course.dart';
import 'package:app/models/user/user.dart';

class Event {
  int? id;
  int? clubId;
  Club? club;
  int? courseId;
  Course? course;
  String? name;
  String? description;
  String? eventTime;
  String? eventDate;
  dynamic isActive;
  int? isOpenForAll;
  User? createdUser;
  List<User>? users;
  bool? isJoined;
  int? totalJoined;

  bool get is_joined => isJoined != null && isJoined == true;
  String get event_datetime => eventDate == null || eventTime == null ? '' : '$eventDate $eventTime';

  Event({
    this.id,
    this.clubId,
    this.club,
    this.courseId,
    this.course,
    this.name,
    this.description,
    this.eventTime,
    this.eventDate,
    this.isActive,
    this.isOpenForAll,
    this.createdUser,
    this.users,
    this.isJoined,
    this.totalJoined,
  });

  Event.fromJson(json) {
    id = json['id'];
    clubId = json['club_id'];
    club = json['club'] != null ? Club.fromJson(json['club']) : null;
    courseId = json['course_id'];
    course = json['course'] != null ? Course.fromJson(json['course']) : null;
    name = json['name'];
    description = json['description'];
    eventTime = json['event_time'];
    eventDate = json['event_date'];
    isActive = json['is_active'];
    isOpenForAll = json['is_open_for_all'];
    createdUser = json['createdByUser'] != null ? User.fromJson(json['createdByUser']) : null;
    users = [];
    if (json['users'] != null) json['users'].forEach((v) => users?.add(User.fromJson(v)));
    isJoined = json['is_joined'];
    totalJoined = json['total_joined'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['club_id'] = clubId;
    if (club != null) map['club'] = club?.toJson();
    map['course_id'] = courseId;
    if (course != null) map['course'] = course?.toJson();
    map['name'] = name;
    map['description'] = description;
    map['event_time'] = eventTime;
    map['event_date'] = eventDate;
    map['is_active'] = isActive;
    map['is_open_for_all'] = isOpenForAll;
    if (createdUser != null) map['createdByUser'] = createdUser?.toJson();
    if (users != null) map['users'] = users?.map((v) => v.toJson()).toList();
    map['is_joined'] = isJoined;
    map['total_joined'] = totalJoined;
    return map;
  }
}
