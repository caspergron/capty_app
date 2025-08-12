import 'package:app/extensions/flutter_ext.dart';
import 'package:app/models/common/brand.dart';
import 'package:app/models/common/media.dart';
import 'package:app/models/common/tag.dart';

class ParentDisc {
  int? id;
  int? wishlistId;
  String? name;
  int? discBrandId;
  double? speed;
  double? glide;
  double? turn;
  double? fade;
  String? type;
  String? color;
  String? description;
  int? isActive;
  List<Tag>? tags;
  Brand? brand;
  String? label;
  List<Media>? mediaList;
  bool selected = false;

  bool get is_wishListed => wishlistId != null;
  Media get media => mediaList.haveList ? mediaList!.first : Media();
  Media get brand_media => brand?.media ?? Media();

  ParentDisc({
    this.id,
    this.wishlistId,
    this.name,
    this.discBrandId,
    this.speed,
    this.glide,
    this.turn,
    this.fade,
    this.type,
    this.color,
    this.description,
    this.isActive,
    this.tags,
    this.brand,
    this.label,
    this.mediaList,
    this.selected = false,
  });

  ParentDisc.fromJson(json) {
    id = json['id'];
    wishlistId = json['wishlist_id'];
    name = json['name'];
    discBrandId = json['disc_brand_id'];
    speed = json['speed'] == null ? 0 : double.parse('${json['speed']}');
    glide = json['glide'] == null ? 0 : double.parse('${json['glide']}');
    turn = json['turn'] == null ? 0 : double.parse('${json['turn']}');
    fade = json['fade'] == null ? 0 : double.parse('${json['fade']}');
    type = json['type'];
    color = json['color'];
    description = json['description'];
    isActive = json['is_active'];
    tags = [];
    if (json['tags'] != null) json['tags'].forEach((v) => tags?.add(Tag.fromJson(v)));
    brand = json['brand'] != null ? Brand.fromJson(json['brand']) : null;
    mediaList = [];
    if (json['media'] != null) json['media'].forEach((v) => mediaList?.add(Media.fromJson(v)));
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['wishlist_id'] = wishlistId;
    map['name'] = name;
    map['disc_brand_id'] = discBrandId;
    map['speed'] = speed;
    map['glide'] = glide;
    map['turn'] = turn;
    map['fade'] = fade;
    map['type'] = type;
    map['color'] = color;
    map['description'] = description;
    map['is_active'] = isActive;
    if (tags != null) map['tags'] = tags?.map((v) => v.toJson()).toList();
    if (brand != null) map['brand'] = brand?.toJson();
    if (mediaList != null) map['media'] = mediaList?.map((v) => v.toJson()).toList();
    return map;
  }
}
