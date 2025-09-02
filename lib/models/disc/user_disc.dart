import 'package:app/extensions/number_ext.dart';
import 'package:app/models/common/brand.dart';
import 'package:app/models/common/media.dart';
import 'package:app/models/disc/parent_disc.dart';
import 'package:app/models/plastic/plastic.dart';
import 'package:app/preferences/user_preferences.dart';
import 'package:flutter/cupertino.dart';

class UserDisc {
  int? id;
  int? userId;
  int? discId;
  int? discPlasticId;
  String? name;
  double? weight;
  double? speed;
  double? glide;
  double? turn;
  double? fade;
  String? color;
  String? description;
  int? quantity;
  int? bagId;
  Media? media;
  ParentDisc? parentDisc;
  Plastic? plastic;
  Brand? brand;

  bool? get is_my_disc => userId != null && (userId == UserPreferences.user.id);
  Color? get disc_color => color == null ? null : Color(int.parse('FF$color', radix: 16));
  double get turn_plus_fade => turn.nullToDouble + fade.nullToDouble;

  UserDisc({
    this.id,
    this.userId,
    this.discId,
    this.discPlasticId,
    this.name,
    this.weight,
    this.speed,
    this.glide,
    this.turn,
    this.color,
    this.description,
    this.quantity,
    this.bagId,
    this.media,
    this.parentDisc,
    this.plastic,
    this.brand,
  });

  UserDisc.fromJson(json) {
    id = json['id'];
    userId = json['user_id'];
    discId = json['disc_id'];
    discPlasticId = json['disc_plastic_id'];
    name = json['name'];
    weight = json['weight'] == null ? null : double.parse('${json['weight']}');
    speed = json['speed'] == null ? null : double.parse('${json['speed']}');
    glide = json['glide'] == null ? null : double.parse('${json['glide']}');
    turn = json['turn'] == null ? null : double.parse('${json['turn']}');
    fade = json['fade'] == null ? null : double.parse('${json['fade']}');
    color = json['color'];
    description = json['description'];
    quantity = json['quantity'];
    bagId = json['bag_id'];
    media = json['media'] != null ? Media.fromJson(json['media']) : null;
    parentDisc = json['disc'] != null ? ParentDisc.fromJson(json['disc']) : null;
    plastic = json['disc_brand_plastic'] != null ? Plastic.fromJson(json['disc_brand_plastic']) : null;
    brand = json['brand'] != null ? Brand.fromJson(json['brand']) : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['user_id'] = userId;
    map['disc_id'] = discId;
    map['disc_plastic_id'] = discPlasticId;
    map['weight'] = weight;
    map['speed'] = speed;
    map['glide'] = glide;
    map['turn'] = turn;
    map['color'] = color;
    map['description'] = description;
    map['quantity'] = quantity;
    map['bag_id'] = bagId;
    if (media != null) map['media'] = media?.toJson();
    if (parentDisc != null) map['disc'] = parentDisc?.toJson();
    if (plastic != null) map['disc_brand_plastic'] = plastic?.toJson();
    if (brand != null) map['brand'] = brand?.toJson();
    return map;
  }

  Map<String, dynamic> get analyticParams => {
        'user_disc_id': id,
        'parent_disc_id': parentDisc?.id,
        'disc_name': parentDisc?.name,
        'image': media?.url,
        'brand_id': parentDisc?.brand?.id,
      };
}
