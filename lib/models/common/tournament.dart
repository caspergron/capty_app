import 'package:app/constants/date_formats.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/libraries/formatters.dart';

class Tournament {
  int? id;
  int? userId;
  int? eventId;
  String? eventDate;
  String? eventName;

  String get tournament_info_1 => '${eventName ?? ''} ${'on'.recast} ${Formatters.formatDate(DATE_FORMAT_14, eventDate)}';
  String get tournament_info_2 => '${eventName ?? ''} - ${Formatters.formatDate(DATE_FORMAT_14, eventDate)}';

  Tournament({this.id, this.userId, this.eventId, this.eventDate, this.eventName});

  Tournament.fromJson(json) {
    id = json['id'];
    userId = json['user_id'];
    eventId = json['event_id'];
    eventDate = json['event_date'];
    eventName = json['event_name'];
  }

  Tournament copyWith({int? id, int? userId, int? eventId, String? eventDate, String? eventName}) {
    return Tournament(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      eventId: eventId ?? this.eventId,
      eventDate: eventDate ?? this.eventDate,
      eventName: eventName ?? this.eventName,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['user_id'] = userId;
    map['event_id'] = eventId;
    map['event_date'] = eventDate;
    map['event_name'] = eventName;
    return map;
  }
}
