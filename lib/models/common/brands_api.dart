import 'package:app/models/common/brand.dart';
import 'package:app/models/common/meta.dart';

class BrandsApi {
  bool? success;
  String? message;
  Meta? meta;
  List<Brand>? brands;

  BrandsApi({this.success, this.message, this.meta, this.brands});

  BrandsApi.fromJson(json) {
    success = json['success'];
    message = json['message'];
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
    brands = [];
    if (json['data'] != null) json['data'].forEach((v) => brands?.add(Brand.fromJson(v)));
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    if (meta != null) map['meta'] = meta?.toJson();
    if (brands != null) map['data'] = brands?.map((v) => v.toJson()).toList();
    return map;
  }
}
