class Coordinates {
  double? lat;
  double? lng;

  bool get is_coordinate => lat != null && lng != null;

  Coordinates({this.lat, this.lng});

  Coordinates.fromJson(json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['lat'] = lat;
    map['lng'] = lng;
    return map;
  }
}
