import 'package:app/extensions/string_ext.dart';
import 'package:app/models/disc/user_disc.dart';

class DiscBag {
  int? id;
  String? name;
  String? displayName;
  String? description;
  int? userId;
  List<UserDisc>? userDiscs;
  int? discCount;
  bool? hasDelete;
  String? label;

  bool get is_delete => hasDelete ?? false;

  DiscBag({
    this.id,
    this.name,
    this.displayName,
    this.description,
    this.userId,
    this.userDiscs,
    this.discCount,
    this.hasDelete,
    this.label,
  });

  DiscBag.fromJson(json) {
    id = json['id'];
    name = json['name'];
    displayName = json['display_name'];
    description = json['description'];
    userId = json['user_id'];
    userDiscs = [];
    if (json['user_discs'] != null) json['user_discs'].forEach((v) => userDiscs?.add(UserDisc.fromJson(v)));
    discCount = json['disc_count'];
    hasDelete = json['has_delete'];
    label = json['name'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['display_name'] = displayName;
    map['description'] = description;
    map['user_id'] = userId;
    if (userDiscs != null) map['user_discs'] = userDiscs?.map((v) => v.toJson()).toList();
    map['disc_count'] = discCount;
    map['has_delete'] = hasDelete;
    map['label'] = label;
    return map;
  }

  String get bag_menu_display_name {
    if (name?.toKey == 'all'.toKey) {
      return 'all'.recast;
    } else if (name.toKey == 'plus_new_bag'.toKey) {
      return 'plus_new_bag'.recast;
    } else if (name.toKey == 'tournament_bag'.toKey || name.toKey == 'Tournament Bag'.toKey) {
      return 'tournament_bag_menu'.recast;
    } else if (name.toKey == 'backup_bag'.toKey || name.toKey == 'Backup Bag'.toKey) {
      return 'backup_bag'.recast;
    } else {
      return displayName ?? 'n/a'.recast;
    }
  }
}
