import 'package:app/models/disc/parent_disc_category.dart';

class ParentDiscCategoryApi {
  bool? success;
  String? message;
  List<ParentDiscCategory>? categories;

  ParentDiscCategoryApi({this.success, this.message, this.categories});

  ParentDiscCategoryApi.fromJson(json) {
    success = json['success'];
    message = json['message'];
    categories = [];
    if (json['data'] != null) json['data'].forEach((v) => categories?.add(ParentDiscCategory.fromJson(v)));
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    if (categories != null) map['data'] = categories?.map((v) => v.toJson()).toList();
    return map;
  }
}
