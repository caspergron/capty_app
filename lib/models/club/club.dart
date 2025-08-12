import 'package:app/models/club/course.dart';
import 'package:app/models/club/event.dart';
import 'package:app/models/map/coordinates.dart';
import 'package:app/models/public/country.dart';

class Club {
  int? id;
  String? name;
  String? description;
  Country? country;
  double? longitude;
  double? latitude;
  String? whatsapp;
  String? messenger;
  String? wechat;
  double? distance;
  int? totalMember;
  String? location;
  Course? homeCourse;
  List<Course>? courses;
  List<Event>? events;
  bool? isMember;
  bool? isDefault;

  bool get is_default => isDefault != null && isDefault == true;
  bool get is_member => isMember != null && isMember == true;
  List<Event> get club_events => events == null ? [] : events!;
  Coordinates? get coordinates => latitude == null || longitude == null ? null : Coordinates(lat: latitude!, lng: longitude);

  Club({
    this.id,
    this.name,
    this.description,
    this.country,
    this.longitude,
    this.latitude,
    this.whatsapp,
    this.messenger,
    this.wechat,
    this.distance,
    this.totalMember,
    this.location,
    this.homeCourse,
    this.courses,
    this.events,
    this.isMember,
    this.isDefault,
  });

  Club.fromJson(json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    country = json['country'] != null ? Country.fromJson(json['country']) : null;
    longitude = json['longitude'] == null ? null : double.parse(json['longitude'].toString());
    latitude = json['latitude'] == null ? null : double.parse(json['latitude'].toString());
    whatsapp = json['whatsapp_group_url'];
    messenger = json['facebook_group_url'];
    whatsapp = json['wechat_group_url'];
    distance = json['distance'] == null ? 0 : double.parse(json['distance'].toString());
    totalMember = json['total_member'];
    location = json['location'];
    homeCourse = json['homeCourse'] != null ? Course.fromJson(json['homeCourse']) : null;
    courses = [];
    if (json['courses'] != null) json['courses'].forEach((v) => courses?.add(Course.fromJson(v)));
    events = [];
    if (json['events'] != null) json['events'].forEach((v) => events?.add(Event.fromJson(v)));
    isMember = json['is_member'];
    isDefault = json['is_default'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['description'] = description;
    if (country != null) map['country'] = country?.toJson();
    map['longitude'] = longitude;
    map['latitude'] = latitude;
    map['whatsapp_group_url'] = whatsapp;
    map['facebook_group_url'] = messenger;
    map['wechat_group_url'] = wechat;
    map['distance'] = distance;
    map['total_member'] = totalMember;
    map['location'] = location;
    if (homeCourse != null) map['homeCourse'] = homeCourse?.toJson();
    if (courses != null) map['courses'] = courses?.map((v) => v.toJson()).toList();
    if (events != null) map['events'] = events?.map((v) => v.toJson()).toList();
    map['is_member'] = isMember;
    map['is_default'] = isDefault;
    return map;
  }

  Map<String, dynamic> get analyticParams => {
        'id': id,
        'name': name,
        'country_id': country?.id,
        'longitude': latitude,
        'latitude': longitude,
        'location': location,
        'home_course_id': homeCourse?.id,
      };
}
