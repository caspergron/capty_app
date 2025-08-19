import 'package:app/extensions/string_ext.dart';
import 'package:app/models/map/coordinates.dart';
import 'package:app/models/public/country.dart';
import 'package:app/utils/assets.dart';

class Address {
  int? id;
  int? userId;
  int? countryId;
  String? state;
  String? city;
  String? label;
  String? placeId;
  String? addressLine1;
  String? addressLine2;
  double? latitude;
  double? longitude;
  double? distance;
  String? zipCode;
  Country? country;

  int get distance_number => distance == null ? 0 : distance!.toInt();
  bool get is_home => label.toKey == 'home'.toKey;
  bool get is_coordinate => latitude != null && longitude != null;
  Coordinates get coordinates => latitude == null || longitude == null ? Coordinates() : Coordinates(lat: latitude!, lng: longitude!);

  Address({
    this.id,
    this.userId,
    this.countryId,
    this.state,
    this.city,
    this.label,
    this.placeId,
    this.addressLine1,
    this.addressLine2,
    this.latitude,
    this.longitude,
    this.distance,
    this.zipCode,
    this.country,
  });

  Address.fromJson(json) {
    id = json['id'];
    userId = json['user_id'];
    countryId = json['country_id'];
    state = json['state'];
    city = json['city'];
    label = json['label'];
    placeId = json['place_id'];
    addressLine1 = json['address_line_1'];
    addressLine2 = json['address_line_2'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    distance = json['distance'] == null ? 0 : double.parse(json['distance'].toString());
    zipCode = json['zip_code'];
    country = json['country'] != null ? Country.fromJson(json['country']) : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['user_id'] = userId;
    map['country_id'] = countryId;
    map['state'] = state;
    map['city'] = city;
    map['label'] = label;
    map['place_id'] = placeId;
    map['address_line_1'] = addressLine1;
    map['address_line_2'] = addressLine2;
    map['latitude'] = latitude;
    map['longitude'] = longitude;
    map['distance'] = distance;
    map['zip_code'] = zipCode;
    if (country != null) map['country'] = country?.toJson();
    return map;
  }

  String get address_label_icon => label.toKey == 'home'.toKey ? Assets.svg1.home : Assets.svg1.map_pin;

  String get formatted_address {
    var addressItems = [addressLine1, city, zipCode];
    var addressParts = addressItems.where((item) => item != null && item.isNotEmpty).toList();
    return addressParts.isEmpty ? 'N/A' : addressParts.join(', ');
  }

  String get formatted_state_country {
    var addressItems = [state, country?.name];
    var addressParts = addressItems.where((item) => item != null && item.isNotEmpty).toList();
    return addressParts.isEmpty ? 'N/A' : addressParts.join(', ');
  }

  String get formatted_city_state_country {
    var addressItems = [city, zipCode, state, country?.name];
    var addressParts = addressItems.where((item) => item != null && item.isNotEmpty).toList();
    return addressParts.isEmpty ? 'N/A' : addressParts.join(', ');
  }
}
