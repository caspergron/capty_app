import 'package:app/extensions/string_ext.dart';

class Tag {
  int? id;
  String? displayName;
  String? name;
  String? description;
  int? value;

  Tag({this.id, this.displayName, this.name, this.description, this.value});

  Tag.fromJson(json) {
    id = json['id'];
    displayName = json['display_name'];
    name = json['name'];
    description = json['description'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['display_name'] = displayName;
    map['name'] = name;
    map['description'] = description;
    map['value'] = value;
    return map;
  }

  static List<Tag> tag_list_by_display_name(List<Tag> tagList, String key) {
    if (tagList.isEmpty) return [];
    if (key.isEmpty) return tagList;
    final filteredTags = tagList.where((item) => item.displayName.toKey.contains(key.toKey)).toList();
    if (filteredTags.isEmpty) return [];
    filteredTags.sort((item1, item2) => item1.displayName.toKey.compareTo(item2.displayName.toKey));
    return filteredTags;
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
