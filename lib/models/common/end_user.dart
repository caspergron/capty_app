import 'package:app/extensions/string_ext.dart';
import 'package:app/models/common/media.dart';

class EndUser {
  int? id;
  String? name;
  Media? media;

  String get full_name => name == null ? '' : name!.allFirstLetterCapital;
  String get first_name => name == null ? '' : name!.split(' ').first;
  String get name_initial => name == null ? '' : name!.name_initial;

  EndUser({this.id, this.name, this.media});

  EndUser.fromJson(json) {
    id = json['id'];
    name = json['name'];
    media = json['media'] != null ? Media.fromJson(json['media']) : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    if (media != null) map['media'] = media?.toJson();
    return map;
  }
}
