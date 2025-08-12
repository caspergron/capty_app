import 'package:app/models/disc/disc_category.dart';

class DiscCategoryApi {
  bool? success;
  String? message;
  List<DiscCategory>? categories;

  DiscCategoryApi({this.success, this.message, this.categories});

  DiscCategoryApi.fromJson(json) {
    success = json['success'];
    message = json['message'];
    categories = [];
    if (json['data'] != null) json['data'].forEach((v) => categories?.add(DiscCategory.fromJson(v)));
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    if (categories != null) map['data'] = categories?.map((v) => v.toJson()).toList();
    return map;
  }
}
