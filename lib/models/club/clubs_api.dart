import 'package:app/models/club/club.dart';

class ClubsApi {
  bool? success;
  String? message;
  List<Club>? clubs;

  ClubsApi({this.success, this.message, this.clubs});

  ClubsApi.fromJson(json) {
    success = json['success'];
    message = json['message'];
    clubs = [];
    if (json['data'] != null) json['data'].forEach((v) => clubs?.add(Club.fromJson(v)));
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    if (clubs != null) map['data'] = clubs?.map((v) => v.toJson()).toList();
    return map;
  }
}
