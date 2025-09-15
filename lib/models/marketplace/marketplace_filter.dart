import 'package:flutter/material.dart';

import 'package:app/models/common/brand.dart';
import 'package:app/models/common/tag.dart';
import 'package:app/models/system/data_model.dart';

class MarketplaceFilter {
  List<Tag> types = [];
  List<Brand> brands = [];
  List<Tag> tags = [];
  RangeValues speed;
  RangeValues glide;
  RangeValues turn;
  RangeValues fade;
  RangeValues condition;
  RangeValues weight;
  RangeValues price;
  DataModel? sortBy;
  String parameters;

  /*List<String> get brandLabels => brands.isEmpty ? <String>[] : brands.map((e) => e.name ?? '').toList();
  List<String> get typeLabels => types.isEmpty ? <String>[] : types.map((e) => e.displayName ?? '').toList();
  List<String> get tagLabels => tags.isEmpty ? <String>[] : tags.map((e) => e.displayName ?? '').toList();*/

  /*List<int> get typeIds => types.isEmpty ? <int>[] : types.map((e) => e.id.nullToInt).toList();
  List<int> get tagIds => tags.isEmpty ? <int>[] : tags.map((e) => e.id.nullToInt).toList();
  List<int> get brandIds => brands.isEmpty ? <int>[] : brands.map((e) => e.id.nullToInt).toList();*/

  MarketplaceFilter({
    this.types = const [],
    this.brands = const [],
    this.tags = const [],
    this.speed = const RangeValues(1, 15),
    this.glide = const RangeValues(0, 7),
    this.turn = const RangeValues(-5, 1),
    this.fade = const RangeValues(0, 5),
    this.condition = const RangeValues(0, 10),
    this.weight = const RangeValues(100, 200),
    this.price = const RangeValues(0, 1000),
    this.sortBy,
    this.parameters = '',
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['speed'] = speed;
    map['glide'] = glide;
    map['turn'] = turn;
    map['fade'] = fade;
    if (types.isNotEmpty) map['types'] = types.map((v) => v.toJson()).toList();
    if (tags.isNotEmpty) map['tags'] = tags.map((v) => v.toJson()).toList();
    if (brands.isNotEmpty) map['brands'] = brands.map((v) => v.toJson()).toList();
    map['sort_by'] = sortBy?.toJson();
    map['condition'] = condition;
    map['weight'] = weight;
    map['price'] = price;
    map['parameters'] = parameters;
    return map;
  }

  /*bool get is_validated {
    var invalidFlight1 = (speed.start == 1 && speed.end == 15) && (glide.start == 0 && glide.end == 7);
    var invalidFlight2 = (turn.start == -5 && turn.end == 1) && (fade.start == 0 && fade.end == 5);
    var isInvalid = invalidFlight1 && invalidFlight2 && types.isEmpty && brands.isEmpty && tags.isEmpty;
    return !isInvalid;
  }*/
}
