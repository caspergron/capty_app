import 'package:app/models/common/tag.dart';

class TagsApi {
  bool? success;
  String? message;
  List<Tag>? tags;

  TagsApi({this.success, this.message, this.tags});

  TagsApi.fromJson(json) {
    success = json['success'];
    message = json['message'];
    tags = [];
    if (json['data'] != null) json['data'].forEach((v) => tags?.add(Tag.fromJson(v)));
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    if (tags != null) map['data'] = tags?.map((v) => v.toJson()).toList();
    return map;
  }
}
