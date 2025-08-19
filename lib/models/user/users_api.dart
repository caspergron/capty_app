import 'package:app/models/user/user.dart';

class UsersApi {
  bool? success;
  String? message;
  List<User>? users;

  UsersApi({this.success, this.message, this.users});

  UsersApi.fromJson(json) {
    success = json['success'];
    message = json['message'];
    users = [];
    if (json['data'] != null) json['data'].forEach((v) => users?.add(User.fromJson(v)));
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    if (users != null) map['data'] = users?.map((v) => v.toJson()).toList();
    return map;
  }
}
