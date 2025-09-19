import 'package:flutter/material.dart';

import 'package:app/constants/data_constants.dart';
import 'package:app/models/common/pagination.dart';
import 'package:app/models/disc/user_disc.dart';
import 'package:app/models/system/paginate.dart';

class UserDiscCategory {
  String? displayName;
  String? name;
  int? order;
  int? tagId;
  bool? isSpecial;
  int? totalUserDiscs;
  List<UserDisc>? userDiscs;
  Pagination? pagination;
  ScrollController? scrollControl;
  Paginate? paginate;

  int get page_no => paginate?.page ?? 1;
  bool get is_page_loader => paginate?.pageLoader ?? false;
  List<UserDisc> get discs => userDiscs ?? [];

  UserDiscCategory({
    this.displayName,
    this.name,
    this.order,
    this.tagId,
    this.isSpecial,
    this.totalUserDiscs,
    this.userDiscs,
    this.pagination,
    this.scrollControl,
    this.paginate,
  });

  UserDiscCategory.fromJson(json) {
    displayName = json['display_name'];
    name = json['name'];
    order = json['order'];
    tagId = json['tag_id'];
    isSpecial = json['is_special'];
    totalUserDiscs = json['total_user_discs'];
    userDiscs = [];
    if (json['user_discs'] != null) json['user_discs'].forEach((v) => userDiscs?.add(UserDisc.fromJson(v)));
    pagination = json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;
    final length = userDiscs?.length ?? 0;
    final isNextPage = length >= LENGTH_10;
    scrollControl = ScrollController();
    paginate = Paginate(length: length, page: isNextPage ? 2 : 1, pageLoader: isNextPage);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['display_name'] = displayName;
    map['name'] = name;
    map['order'] = order;
    map['tag_id'] = tagId;
    map['is_special'] = isSpecial;
    map['total_user_discs'] = totalUserDiscs;
    if (userDiscs != null) map['user_discs'] = userDiscs?.map((v) => v.toJson()).toList();
    if (pagination != null) map['pagination'] = pagination?.toJson();
    return map;
  }
}
