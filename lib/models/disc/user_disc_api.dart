import 'package:app/models/common/meta.dart';
import 'package:app/models/disc/user_disc.dart';

class UserDiscApi {
  bool? success;
  String? message;
  Meta? meta;
  List<UserDisc>? userDiscs;

  UserDiscApi({this.success, this.message, this.meta, this.userDiscs});

  UserDiscApi.fromJson(json) {
    success = json['success'];
    message = json['message'];
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
    userDiscs = [];
    if (json['data'] != null) json['data'].forEach((v) => userDiscs?.add(UserDisc.fromJson(v)));
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    if (meta != null) map['meta'] = meta?.toJson();
    if (userDiscs != null) map['data'] = userDiscs?.map((v) => v.toJson()).toList();
    return map;
  }
}
