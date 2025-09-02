import 'package:app/extensions/number_ext.dart';
import 'package:app/models/address/address.dart';
import 'package:app/models/chat/chat_buddy.dart';
import 'package:app/models/common/end_user.dart';
import 'package:app/models/common/sales_ad_type.dart';
import 'package:app/models/common/tag.dart';
import 'package:app/models/disc/user_disc.dart';
import 'package:app/models/public/currency.dart';
import 'package:app/preferences/user_preferences.dart';

class SalesAd {
  int? id;
  int? wishlistId;
  int? userId;
  int? parentDiscId;
  double? price;
  int? currencyId;
  int? isShipping;
  String? shippingMethod;
  int? condition;
  double? usedRange;
  int? isFavorite;
  String? soldThrough;
  String? soldThroughDetails;
  String? notes;
  double? distance;
  UserDisc? userDisc;
  SalesAdType? salesAdType;
  Address? address;
  Currency? currency;
  List<Tag>? specialityDiscs;
  EndUser? sellerInfo;

  // bool get is_shipping => isShipping != null && isShipping == 1;
  // bool get is_wishListed => wishlistId != null;
  int get distance_number => distance == null ? 0 : distance!.toInt();
  bool get is_favourite => isFavorite != null && isFavorite == 1;
  bool get is_my_disc => sellerInfo?.id != null && (sellerInfo?.id.nullToInt == UserPreferences.user.id);
  int? get condition_value => usedRange == null ? null : (usedRange == 0 ? 0 : usedRange!.toInt() - 1);
  String get currency_code => currency?.code ?? '';
  String get condition_number => usedRange == null || usedRange == 0 ? '0' : usedRange!.toInt().formatInt;

  SalesAd({
    this.id,
    this.wishlistId,
    this.userId,
    this.parentDiscId,
    this.price,
    this.currencyId,
    this.isShipping,
    this.shippingMethod,
    this.condition,
    this.usedRange,
    this.isFavorite,
    this.soldThrough,
    this.soldThroughDetails,
    this.notes,
    this.distance,
    this.userDisc,
    this.salesAdType,
    this.address,
    this.currency,
    this.specialityDiscs,
    this.sellerInfo,
  });

  SalesAd.fromJson(json) {
    id = json['id'];
    wishlistId = json['wishlist_id'];
    userId = json['user_id'];
    parentDiscId = json['parent_disc_id'];
    price = json['price'] == null ? 0 : double.parse('${json['price']}');
    currencyId = json['currency_id'];
    isShipping = json['is_shipping'];
    shippingMethod = json['shipping_method'];
    condition = json['condition'];
    usedRange = json['used_range'] == null ? 0 : double.parse(json['used_range'].toString());
    isFavorite = json['is_favorite'];
    soldThrough = json['sold_through'];
    soldThroughDetails = json['sold_through_details'];
    notes = json['notes'];
    distance = json['distance'] == null ? 0 : double.parse(json['distance'].toString());
    userDisc = json['user_disc'] != null ? UserDisc.fromJson(json['user_disc']) : null;
    salesAdType = json['sales_ad_type'] != null ? SalesAdType.fromJson(json['sales_ad_type']) : null;
    address = json['address'] != null ? Address.fromJson(json['address']) : null;
    currency = json['currency'] != null ? Currency.fromJson(json['currency']) : null;
    specialityDiscs = [];
    if (json['speciality_discs'] != null) json['speciality_discs'].forEach((v) => specialityDiscs?.add(Tag.fromJson(v)));
    sellerInfo = json['seller_info'] != null ? EndUser.fromJson(json['seller_info']) : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['wishlist_id'] = wishlistId;
    map['user_id'] = userId;
    map['parent_disc_id'] = parentDiscId;
    map['price'] = price;
    map['currency_id'] = currencyId;
    map['is_shipping'] = isShipping;
    map['shipping_method'] = shippingMethod;
    map['condition'] = condition;
    map['used_range'] = usedRange;
    map['is_favorite'] = isFavorite;
    map['sold_through'] = soldThrough;
    map['sold_through_details'] = soldThroughDetails;
    map['notes'] = notes;
    map['distance'] = distance;
    if (userDisc != null) map['user_disc'] = userDisc?.toJson();
    if (salesAdType != null) map['sales_ad_type'] = salesAdType?.toJson();
    if (address != null) map['address'] = address?.toJson();
    if (currency != null) map['currency'] = currency?.toJson();
    if (specialityDiscs != null) map['speciality_discs'] = specialityDiscs?.map((v) => v.toJson()).toList();
    if (sellerInfo != null) map['seller_info'] = sellerInfo?.toJson();
    return map;
  }

  ChatBuddy get chat_buddy => ChatBuddy(
        id: sellerInfo?.id,
        name: sellerInfo?.name,
        distance: address?.distance,
        media: sellerInfo?.media,
        salesAd: this,
      );

  Map<String, dynamic> get analyticParams => {
        'sales_ad_id': id,
        'seller_id': userId,
        'user_disc_id': userDisc?.id,
        'parent_disc_id': userDisc?.parentDisc?.id,
        'disc_name': userDisc?.parentDisc?.name,
        'image': userDisc?.media?.url,
        'price': price,
        'address_id': address?.id,
        'currency_id': currencyId,
      };
}
