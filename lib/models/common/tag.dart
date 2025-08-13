import 'package:app/extensions/string_ext.dart';

class Tag {
  int? id;
  String? displayName;
  String? name;
  String? description;
  bool? isVertical;
  bool? isHorizontal;
  bool? isSpecial;
  int? order;
  int? value;
  int? isActive;

  Tag({
    this.id,
    this.displayName,
    this.name,
    this.description,
    this.isVertical,
    this.isHorizontal,
    this.isSpecial,
    this.order,
    this.value,
    this.isActive,
  });

  Tag.fromJson(json) {
    id = json['id'];
    displayName = json['display_name'];
    name = json['name'];
    description = json['description'];
    isVertical = json['is_vertical'];
    isHorizontal = json['is_horizontal'];
    isSpecial = json['is_special'];
    order = json['order'];
    value = json['value'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['display_name'] = displayName;
    map['name'] = name;
    map['description'] = description;
    map['is_vertical'] = isVertical;
    map['is_horizontal'] = isHorizontal;
    map['is_special'] = isSpecial;
    map['order'] = order;
    map['value'] = value;
    map['is_active'] = isActive;
    return map;
  }

  static List<Tag> tag_list_by_display_name(List<Tag> tagList, String key) {
    if (tagList.isEmpty) return [];
    if (key.isEmpty) return tagList;
    return tagList.where((item) => item.displayName.toKey.startsWith(key.toKey)).toList();
  }

  String get marketplace_menu_display_name {
    if (name.toKey == 'all'.toKey) {
      return 'all'.recast;
    } else if (name.toKey == 'club'.toKey) {
      return 'from_club_member'.recast;
    } else if (name.toKey == 'tournament'.toKey) {
      return 'tournaments'.recast;
    } else {
      return displayName ?? 'n/a'.recast;
    }
  }
}
