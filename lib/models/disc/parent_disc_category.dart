import 'package:flutter/material.dart';

import 'package:app/constants/data_constants.dart';
import 'package:app/models/common/pagination.dart';
import 'package:app/models/disc/parent_disc.dart';
import 'package:app/models/system/paginate.dart';

class ParentDiscCategory {
  String? displayName;
  String? name;
  int? order;
  int? totalDiscs;
  List<ParentDisc>? parentDiscs;
  Pagination? pagination;
  ScrollController? scrollControl;
  Paginate? paginate;

  int get page_no => paginate?.page ?? 1;
  bool get is_page_loader => paginate?.pageLoader ?? false;
  List<ParentDisc> get discs => parentDiscs ?? [];

  ParentDiscCategory({
    this.displayName,
    this.name,
    this.order,
    this.totalDiscs,
    this.parentDiscs,
    this.pagination,
    this.scrollControl,
    this.paginate,
  });

  ParentDiscCategory copyWith({
    String? displayName,
    String? name,
    int? order,
    int? totalDiscs,
    List<ParentDisc>? parentDiscs,
    Pagination? pagination,
    ScrollController? scrollControl,
    Paginate? paginate,
  }) {
    return ParentDiscCategory(
      displayName: displayName ?? this.displayName,
      name: name ?? this.name,
      order: order ?? this.order,
      totalDiscs: totalDiscs ?? this.totalDiscs,
      parentDiscs: parentDiscs ?? this.parentDiscs,
      pagination: pagination ?? this.pagination,
      scrollControl: scrollControl ?? this.scrollControl,
      paginate: paginate ?? this.paginate,
    );
  }

  ParentDiscCategory.fromJson(json) {
    displayName = json['display_name'];
    name = json['name'];
    order = json['order'];
    totalDiscs = json['total_discs'];
    parentDiscs = [];
    if (json['discs'] != null) json['discs'].forEach((v) => parentDiscs?.add(ParentDisc.fromJson(v)));
    pagination = json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;
    var length = parentDiscs?.length ?? 0;
    var isNextPage = length >= LENGTH_10;
    scrollControl = ScrollController();
    paginate = Paginate(length: length, page: isNextPage ? 2 : 1, pageLoader: isNextPage);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['display_name'] = displayName;
    map['name'] = name;
    map['order'] = order;
    map['total_discs'] = totalDiscs;
    if (parentDiscs != null) map['discs'] = parentDiscs?.map((v) => v.toJson()).toList();
    if (pagination != null) map['pagination'] = pagination?.toJson();
    return map;
  }
}
