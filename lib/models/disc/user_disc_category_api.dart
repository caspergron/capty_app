import 'package:app/models/disc/user_disc_category.dart';

class UserDiscCategoryApi {
  bool? success;
  String? message;
  List<UserDiscCategory>? categories;

  UserDiscCategoryApi({this.success, this.message, this.categories});

  UserDiscCategoryApi.fromJson(json) {
    success = json['success'];
    message = json['message'];
    categories = [];
    if (json['data'] != null) json['data'].forEach((v) => categories?.add(UserDiscCategory.fromJson(v)));
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    if (categories != null) map['data'] = categories?.map((v) => v.toJson()).toList();
    return map;
  }
}
