import 'package:app/constants/data_constants.dart';
import 'package:app/di.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/models/chat/chat_buddy.dart';
import 'package:app/models/common/media.dart';
import 'package:app/models/public/country.dart';
import 'package:app/models/public/currency.dart';
import 'package:app/preferences/app_preferences.dart';
import 'package:app/services/auth_service.dart';

class User {
  int? id;
  String? name;
  String? role;
  int? medium;
  String? email;
  int? countryId;
  String? uDiscUsername;
  String? pdgaNumber;
  int? captyId;
  String? phone;
  int? mediaId;
  int? isActive;
  int? isShipping;
  int? isDefault;
  String? googleId;
  String? facebookId;
  String? appleId;
  int? isClubExist;
  int? isClubAdmin;
  String? lastLogin;
  String? handPref;
  String? clubName;
  int? totalClub;
  int? pdgaRating;
  int? pdgaImprovement;
  Country? country;
  Currency? currency;
  Media? media;
  bool? isOnline;
  int? shareLeaderboard;

  String get full_name => name == null ? '' : name!;
  String get first_name => name == null ? '' : name!.split(' ').first.firstLetterCapital;
  String get name_initial => name == null ? '' : name!.name_initial;

  bool get share_leaderboard => shareLeaderboard != null && shareLeaderboard == 1;
  bool get is_shipping => isShipping != null && isShipping == 1;
  String get pdga_rating => pdgaRating.formatInt;
  int get pdga_improvement => pdgaImprovement ?? 0;
  bool get is_social_login => googleId != null || appleId != null || facebookId != null;
  bool get is_joined_club => totalClub != null && totalClub! > 0;
  bool get is_pdga_or_total_club => (pdgaRating != null && pdgaRating! > 0) || (totalClub != null && totalClub! > 0);

  User({
    this.id,
    this.name,
    this.role,
    this.medium,
    this.email,
    this.countryId,
    this.uDiscUsername,
    this.pdgaNumber,
    this.captyId,
    this.phone,
    this.mediaId,
    this.isActive,
    this.isShipping,
    this.isDefault,
    this.googleId,
    this.facebookId,
    this.appleId,
    this.isClubExist,
    this.isClubAdmin,
    this.lastLogin,
    this.handPref,
    this.clubName,
    this.totalClub,
    this.pdgaRating,
    this.pdgaImprovement,
    this.country,
    this.currency,
    this.media,
    this.isOnline,
    this.shareLeaderboard,
  });

  User.fromJson(json) {
    id = json['id'];
    name = json['name'];
    role = json['role'];
    medium = json['medium'];
    email = json['email'];
    countryId = json['country_id'];
    uDiscUsername = json['udisc_username'];
    pdgaNumber = json['pdga_number'];
    captyId = json['capty_id'];
    phone = json['phone'];
    mediaId = json['media_id'];
    isActive = json['is_active'];
    isShipping = json['is_shipping'];
    isDefault = json['is_default'];
    googleId = json['google_id'];
    facebookId = json['facebook_id'];
    appleId = json['apple_id'];
    isClubExist = json['is_club_exist'];
    isClubAdmin = json['is_club_admin'];
    lastLogin = json['last_login'];
    handPref = json['hand_preference'];
    clubName = json['club_name'];
    totalClub = json['total_club'];
    pdgaRating = json['current_pdga_rating'];
    pdgaImprovement = json['current_pdga_improvement'];
    country = json['country'] != null ? Country.fromJson(json['country']) : null;
    currency = json['currency'] != null ? Currency.fromJson(json['currency']) : null;
    media = json['media'] != null ? Media.fromJson(json['media']) : null;
    isOnline = json['is_online'];
    shareLeaderboard = json['share_leaderboard'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['role'] = role;
    map['medium'] = medium;
    map['email'] = email;
    map['country_id'] = countryId;
    map['udisc_username'] = uDiscUsername;
    map['pdga_number'] = pdgaNumber;
    map['capty_id'] = captyId;
    map['phone'] = phone;
    map['media_id'] = mediaId;
    map['is_active'] = isActive;
    map['is_shipping'] = isShipping;
    map['is_default'] = isDefault;
    map['google_id'] = googleId;
    map['facebook_id'] = facebookId;
    map['apple_id'] = appleId;
    map['is_club_exist'] = isClubExist;
    map['is_club_admin'] = isClubAdmin;
    map['last_login'] = lastLogin;
    map['hand_preference'] = handPref;
    map['club_name'] = clubName;
    map['total_club'] = totalClub;
    map['current_pdga_rating'] = pdgaRating;
    map['current_pdga_improvement'] = pdgaImprovement;
    if (country != null) map['country'] = country?.toJson();
    if (currency != null) map['currency'] = currency?.toJson();
    if (media != null) map['media'] = media?.toJson();
    map['is_online'] = isOnline;
    map['share_leaderboard'] = shareLeaderboard;
    return map;
  }

  ChatBuddy get chat_buddy => ChatBuddy(id: id, name: name, media: media, isOnline: false);

  Country get country_item {
    if (country?.id != null) return country!;
    var countries = AppPreferences.countries;
    if (countries.isEmpty) return Country();
    if (!sl<AuthService>().authStatus || countryId == null) return countries.first;
    return countries.firstWhere((item) => (item.id ?? DEFAULT_ID) == countryId, orElse: () => countries.first);
  }

  static List<User> users_by_name(List<User> users, String key) {
    if (users.isEmpty) return [];
    if (key.isEmpty) return users;
    return users.where((item) => item.name.toKey.startsWith(key.toKey)).toList();
  }
}
