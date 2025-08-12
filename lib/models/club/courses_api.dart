import 'package:app/models/club/course.dart';

class CoursesApi {
  bool? success;
  String? message;
  List<Course>? courses;

  CoursesApi({this.success, this.message, this.courses});

  CoursesApi.fromJson(json) {
    success = json['success'];
    message = json['message'];
    courses = [];
    if (json['data'] != null) json['data'].forEach((v) => courses?.add(Course.fromJson(v)));
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    if (courses != null) map['data'] = courses?.map((v) => v.toJson()).toList();
    return map;
  }
}
