import 'package:app/extensions/number_ext.dart';
import 'package:app/models/common/brand.dart';
import 'package:app/models/common/media.dart';
import 'package:app/models/plastic/plastic.dart';
import 'package:app/preferences/user_preferences.dart';
import 'package:flutter/cupertino.dart';

class UserDisc {
  int? id;
  int? userId;
  int? parentDiscId;
  String? name;
  String? type;
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
  Plastic? plastic;
  Brand? brand;

  bool? get is_my_disc => userId != null && (userId == UserPreferences.user.id);
  Color? get disc_color => color == null ? null : Color(int.parse('FF$color', radix: 16));
  double get turn_plus_fade => turn.nullToDouble + fade.nullToDouble;

  UserDisc({
    this.id,
    this.userId,
    this.parentDiscId,
    this.name,
    this.type,
    this.weight,
    this.speed,
    this.glide,
    this.turn,
    this.fade,
    this.color,
    this.description,
    this.quantity,
    this.bagId,
    this.media,
    this.plastic,
    this.brand,
  });

  UserDisc.fromJson(json) {
    id = json['id'];
    userId = json['user_id'];
    parentDiscId = json['disc_id'];
    name = json['name'];
    type = json['type'];
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
    plastic = json['disc_brand_plastic'] != null ? Plastic.fromJson(json['disc_brand_plastic']) : null;
    brand = json['brand'] != null ? Brand.fromJson(json['brand']) : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['user_id'] = userId;
    map['disc_id'] = parentDiscId;
    map['name'] = name;
    map['type'] = type;
    map['weight'] = weight;
    map['speed'] = speed;
    map['glide'] = glide;
    map['turn'] = turn;
    map['color'] = color;
    map['description'] = description;
    map['quantity'] = quantity;
    map['bag_id'] = bagId;
    if (media != null) map['media'] = media?.toJson();
    if (plastic != null) map['disc_brand_plastic'] = plastic?.toJson();
    if (brand != null) map['brand'] = brand?.toJson();
    return map;
  }

  Map<String, dynamic> get analyticParams => {
        'user_disc_id': id,
        'parent_disc_id': parentDiscId,
        'disc_name': name,
        'image': media?.url,
        'brand_id': brand?.id,
      };
}
