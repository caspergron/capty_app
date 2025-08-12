import 'package:app/models/common/sales_ad_type.dart';

class SalesAdTypesApi {
  bool? success;
  String? message;
  List<SalesAdType>? types;

  SalesAdTypesApi({this.success, this.message, this.types});

  SalesAdTypesApi.fromJson(json) {
    success = json['success'];
    message = json['message'];
    types = [];
    if (json['data'] != null) json['data'].forEach((v) => types?.add(SalesAdType.fromJson(v)));
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    if (types != null) map['data'] = types?.map((v) => v.toJson()).toList();
    return map;
  }
}
