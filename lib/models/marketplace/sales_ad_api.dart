import 'package:app/models/common/pagination.dart';
import 'package:app/models/marketplace/sales_ad.dart';

class SalesAdApi {
  bool? success;
  String? message;
  Pagination? meta;
  List<SalesAd>? salesAdList;

  SalesAdApi({this.success, this.message, this.meta, this.salesAdList});

  SalesAdApi.fromJson(json) {
    success = json['success'];
    message = json['message'];
    meta = json['meta'] != null ? Pagination.fromJson(json['meta']) : null;
    salesAdList = [];
    if (json['data'] != null) json['data'].forEach((v) => salesAdList?.add(SalesAd.fromJson(v)));
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    if (meta != null) map['meta'] = meta?.toJson();
    if (salesAdList != null) map['data'] = salesAdList?.map((v) => v.toJson()).toList();
    return map;
  }
}
