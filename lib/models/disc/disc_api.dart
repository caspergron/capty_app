import 'package:app/models/common/meta.dart';
import 'package:app/models/disc/parent_disc.dart';

class DiscApi {
  bool? success;
  String? message;
  Meta? meta;
  List<ParentDisc>? discs;

  DiscApi({this.success, this.message, this.meta, this.discs});

  DiscApi.fromJson(json) {
    success = json['success'];
    message = json['message'];
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
    discs = [];
    if (json['data'] != null) json['data'].forEach((v) => discs?.add(ParentDisc.fromJson(v)));
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    if (meta != null) map['meta'] = meta?.toJson();
    if (discs != null) map['data'] = discs?.map((v) => v.toJson()).toList();
    return map;
  }
}
