import 'package:app/models/disc/user_disc.dart';

class DiscBag {
  int? id;
  String? name;
  String? description;
  int? userId;
  List<UserDisc>? userDiscs;
  int? discCount;
  bool? hasDelete;
  String? label;

  bool get is_delete => hasDelete ?? false;

  DiscBag({this.id, this.name, this.description, this.userId, this.userDiscs, this.discCount, this.hasDelete, this.label});

  DiscBag.fromJson(json) {
    id = json['id'];
    name = json['name'];
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
    map['description'] = description;
    map['user_id'] = userId;
    if (userDiscs != null) map['user_discs'] = userDiscs?.map((v) => v.toJson()).toList();
    map['disc_count'] = discCount;
    map['has_delete'] = hasDelete;
    map['label'] = label;
    return map;
  }
}
