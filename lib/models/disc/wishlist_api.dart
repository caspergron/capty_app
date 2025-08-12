import 'package:app/models/common/meta.dart';
import 'package:app/models/disc/wishlist.dart';

class WishlistApi {
  bool? success;
  String? message;
  Meta? meta;
  List<Wishlist>? wishlists;

  WishlistApi({this.success, this.message, this.meta, this.wishlists});

  WishlistApi.fromJson(json) {
    success = json['success'];
    message = json['message'];
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
    wishlists = [];
    if (json['data'] != null) json['data'].forEach((v) => wishlists?.add(Wishlist.fromJson(v)));
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    if (meta != null) map['meta'] = meta?.toJson();
    if (wishlists != null) map['data'] = wishlists?.map((v) => v.toJson()).toList();
    return map;
  }
}
