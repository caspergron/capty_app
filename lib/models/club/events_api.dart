import 'package:app/models/club/event.dart';

class EventsApi {
  bool? success;
  String? message;
  List<Event>? events;

  EventsApi({this.success, this.message, this.events});

  EventsApi.fromJson(json) {
    success = json['success'];
    message = json['message'];
    events = [];
    if (json['data'] != null) json['data'].forEach((v) => events?.add(Event.fromJson(v)));
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    if (events != null) map['data'] = events?.map((v) => v.toJson()).toList();
    return map;
  }
}
