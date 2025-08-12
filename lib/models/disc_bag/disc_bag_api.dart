import 'package:app/models/common/meta.dart';
import 'package:app/models/disc_bag/disc_bag.dart';

class DiscBagApi {
  bool? success;
  String? message;
  Meta? meta;
  List<DiscBag>? discBags;

  DiscBagApi({this.success, this.message, this.meta, this.discBags});

  DiscBagApi.fromJson(json) {
    success = json['success'];
    message = json['message'];
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
    discBags = [];
    if (json['data'] != null) json['data'].forEach((v) => discBags?.add(DiscBag.fromJson(v)));
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    if (meta != null) map['meta'] = meta?.toJson();
    if (discBags != null) map['data'] = discBags?.map((v) => v.toJson()).toList();
    return map;
  }
}
