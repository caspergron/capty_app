import 'package:app/extensions/string_ext.dart';

class Plastic {
  int? id;
  int? discId;
  String? name;
  int? discBrandId;
  int? isActive;
  String? label;

  Plastic({this.id, this.discId, this.name, this.isActive, this.discBrandId, this.label});

  Plastic.fromJson(json) {
    id = json['id'];
    discId = json['disc_id'];
    name = json['name'];
    discBrandId = json['disc_brand_id'];
    isActive = json['is_active'];
    label = json['name'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['disc_id'] = discId;
    map['name'] = name;
    map['disc_brand_id'] = discBrandId;
    map['is_active'] = isActive;
    map['label'] = label;
    return map;
  }

  static List<Plastic> plastics_by_name(List<Plastic> plastics, String key) {
    if (plastics.isEmpty) return [];
    if (key.isEmpty) return plastics;
    var filteredPlastics = plastics.where((item) => item.name.toKey.contains(key.toKey)).toList();
    if (filteredPlastics.isEmpty) return [];
    filteredPlastics.sort((item1, item2) => item1.name.toKey.compareTo(item2.name.toKey));
    return filteredPlastics;
  }
}
