import 'package:app/models/common/media.dart';

class MediaApi {
  bool? success;
  int? message;
  List<Media>? mediaList;

  MediaApi({this.success, this.message, this.mediaList});

  MediaApi.fromJson(json) {
    success = json['success'];
    message = json['message'];
    mediaList = [];
    if (json['data'] != null) json['data'].forEach((v) => mediaList?.add(Media.fromJson(v)));
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    if (mediaList != null) map['data'] = mediaList?.map((v) => v.toJson()).toList();
    return map;
  }
}
