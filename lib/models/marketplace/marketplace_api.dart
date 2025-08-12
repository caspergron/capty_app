import 'package:app/models/marketplace/marketplace_category.dart';

class MarketplaceApi {
  bool? success;
  String? message;
  List<MarketplaceCategory>? categories;

  MarketplaceApi({this.success, this.message, this.categories});

  MarketplaceApi.fromJson(json) {
    success = json['success'];
    message = json['message'];
    categories = [];
    if (json['data'] != null) json['data'].forEach((v) => categories?.add(MarketplaceCategory.fromJson(v)));
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    if (categories != null) map['data'] = categories?.map((v) => v.toJson()).toList();
    return map;
  }
}
