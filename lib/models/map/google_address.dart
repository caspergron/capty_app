import 'package:app/models/map/coordinates.dart';

class GoogleAddress {
  String? address;
  String? placeId;
  Coordinates? coordinates;

  bool get is_coordinate => coordinates?.lat != null && coordinates?.lng != null;

  GoogleAddress({this.address, this.placeId, this.coordinates});

  GoogleAddress.fromJson(json) {
    address = json['address'];
    placeId = json['placeId'];
    coordinates = json['coordinates'] != null ? Coordinates.fromJson(json['coordinates']) : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['address'] = address;
    map['placeId'] = placeId;
    if (coordinates != null) map['coordinates'] = coordinates?.toJson();
    return map;
  }
}
