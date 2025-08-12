import 'package:app/models/disc/parent_disc.dart';
import 'package:app/models/disc/user_disc.dart';

class Wishlist {
  int? id;
  int? userId;
  int? discId;
  String? discFrom;
  ParentDisc? disc;
  UserDisc? userDisc;

  Wishlist({this.id, this.userId, this.discId, this.discFrom, this.disc, this.userDisc});

  Wishlist.fromJson(json) {
    id = json['id'];
    userId = json['user_id'];
    discId = json['disc_id'];
    discFrom = json['disc_from'];
    disc = json['disc'] != null ? ParentDisc.fromJson(json['disc']) : null;
    userDisc = json['user_disc'] != null ? UserDisc.fromJson(json['user_disc']) : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['user_id'] = userId;
    map['disc_id'] = discId;
    map['disc_from'] = discFrom;
    if (disc != null) map['disc'] = disc?.toJson();
    if (userDisc != null) map['user_disc'] = userDisc?.toJson();
    return map;
  }
}
