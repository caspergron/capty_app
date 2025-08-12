import 'package:app/models/public/country.dart';

class Course {
  int? id;
  String? name;
  String? udiscUrl;
  Country? country;
  String? courseRating;
  String? countRating;
  String? latitude;
  String? longitude;
  int? cartFriendly;
  int? toilets;
  int? dogsAllowed;
  int? drinkingWater;
  int? stroller;
  String? distance;

  Course({
    this.id,
    this.name,
    this.udiscUrl,
    this.country,
    this.courseRating,
    this.countRating,
    this.latitude,
    this.longitude,
    this.cartFriendly,
    this.toilets,
    this.dogsAllowed,
    this.drinkingWater,
    this.stroller,
    this.distance,
  });

  Course.fromJson(json) {
    id = json['id'];
    name = json['name'];
    udiscUrl = json['udise_url'];
    country = json['country'] != null ? Country.fromJson(json['country']) : null;
    courseRating = json['courseRating'];
    countRating = json['countRating'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    cartFriendly = json['cartFriendly'];
    toilets = json['toilets'];
    dogsAllowed = json['dogsAllowed'];
    drinkingWater = json['drinkingWater'];
    stroller = json['stroller'];
    distance = json['distance'].toString();
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['udise_url'] = udiscUrl;
    if (country != null) map['country'] = country?.toJson();
    map['courseRating'] = courseRating;
    map['countRating'] = countRating;
    map['latitude'] = latitude;
    map['longitude'] = longitude;
    map['cartFriendly'] = cartFriendly;
    map['toilets'] = toilets;
    map['dogsAllowed'] = dogsAllowed;
    map['drinkingWater'] = drinkingWater;
    map['stroller'] = stroller;
    map['distance'] = distance;
    return map;
  }
}
