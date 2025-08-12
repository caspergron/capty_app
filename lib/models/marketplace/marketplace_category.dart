import 'package:flutter/cupertino.dart';

import 'package:app/constants/data_constants.dart';
import 'package:app/models/common/pagination.dart';
import 'package:app/models/marketplace/sales_ad.dart';
import 'package:app/models/system/paginate.dart';

class MarketplaceCategory {
  int? id;
  String? displayName;
  String? name;
  int? order;
  bool? isSpecial;
  int? totalSalesAds;
  List<SalesAd>? salesAds;
  Pagination? pagination;
  ScrollController? scrollControl;
  Paginate? paginate;

  int get page_no => paginate?.page ?? 1;
  bool get is_page_loader => paginate?.pageLoader ?? false;
  List<SalesAd> get discs => salesAds ?? [];

  MarketplaceCategory({
    this.id,
    this.displayName,
    this.name,
    this.order,
    this.isSpecial,
    this.totalSalesAds,
    this.salesAds,
    this.pagination,
    this.scrollControl,
    this.paginate,
  });

  MarketplaceCategory.fromJson(json) {
    id = json['id'];
    displayName = json['display_name'];
    name = json['name'];
    order = json['order'];
    isSpecial = json['is_special'];
    totalSalesAds = json['total_sales_ads'];
    salesAds = [];
    if (json['sales_ads'] != null) json['sales_ads'].forEach((v) => salesAds?.add(SalesAd.fromJson(v)));
    pagination = json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;
    var length = salesAds?.length ?? 0;
    var isNextPage = length >= SALES_AD_LENGTH_05;
    scrollControl = ScrollController();
    paginate = Paginate(length: length, page: isNextPage ? 2 : 1, pageLoader: isNextPage);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['display_name'] = displayName;
    map['name'] = name;
    map['order'] = order;
    map['is_special'] = isSpecial;
    map['total_sales_ads'] = totalSalesAds;
    if (salesAds != null) map['sales_ads'] = salesAds?.map((v) => v.toJson()).toList();
    if (pagination != null) map['pagination'] = pagination?.toJson();
    return map;
  }
}
