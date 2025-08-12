import 'package:app/models/common/media.dart';
import 'package:app/models/public/country.dart';

class FriendInfo {
  int? id;
  String? name;
  String? email;
  int? countryId;
  String? udiscUsername;
  String? pdgaNumber;
  String? phone;
  int? mediaId;
  bool? isFriend;
  int? friendStatus;
  Country? country;
  Media? media;
  int? friendId;

  FriendInfo({
    this.id,
    this.name,
    this.email,
    this.countryId,
    this.udiscUsername,
    this.pdgaNumber,
    this.phone,
    this.mediaId,
    this.isFriend,
    this.friendStatus,
    this.country,
    this.media,
    this.friendId,
  });

  FriendInfo.fromJson(json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    countryId = json['country_id'];
    udiscUsername = json['udisc_username'];
    pdgaNumber = json['pdga_number'];
    phone = json['phone'];
    mediaId = json['media_id'];
    isFriend = json['is_friend'];
    friendStatus = json['friend_status'];
    country = json['country'] != null ? Country.fromJson(json['country']) : null;
    media = json['media'] != null ? Media.fromJson(json['media']) : null;
    friendId = json['friend_id'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['email'] = email;
    map['country_id'] = countryId;
    map['udisc_username'] = udiscUsername;
    map['pdga_number'] = pdgaNumber;
    map['phone'] = phone;
    map['media_id'] = mediaId;
    map['is_friend'] = isFriend;
    map['friend_status'] = friendStatus;
    if (country != null) map['country'] = country?.toJson();
    if (media != null) map['media'] = media?.toJson();
    map['friend_id'] = friendId;
    return map;
  }
}
