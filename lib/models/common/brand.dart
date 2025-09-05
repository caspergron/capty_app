import 'package:app/extensions/string_ext.dart';
import 'package:app/models/common/media.dart';

class Brand {
  int? id;
  String? name;
  String? description;
  int? isActive;
  Media? media;
  // int? isHighVolume;
  // dynamic order;
  // List<Plastic>? plastics;

  Brand({
    this.id,
    this.name,
    this.description,
    this.isActive,
    this.media,
    /*this.isHighVolume, this.order, this.plastics*/
  });

  Brand.fromJson(json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    isActive = json['is_active'];
    media = json['media'] != null ? Media.fromJson(json['media']) : null;
    // isHighVolume = json['is_high_volume'];
    // order = json['order'];
    // plastics = [];
    // if (json['disc_brand_plastics'] != null) json['disc_brand_plastics'].forEach((v) => plastics?.add(Plastic.fromJson(v)));
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['description'] = description;
    map['is_active'] = isActive;
    if (media != null) map['media'] = media?.toJson();
    // map['is_high_volume'] = isHighVolume;
    // map['order'] = order;
    // if (plastics != null) map['disc_brand_plastics'] = plastics?.map((v) => v.toJson()).toList();
    return map;
  }

  static List<Brand> brands_by_name(List<Brand> brands, String key) {
    if (brands.isEmpty) return [];
    if (key.isEmpty) return brands;
    var filteredBrands = brands.where((item) => item.name.toKey.contains(key.toKey)).toList();
    if (filteredBrands.isEmpty) return [];
    filteredBrands.sort((item1, item2) => item1.name.toKey.compareTo(item2.name.toKey));
    return filteredBrands;
  }
}
