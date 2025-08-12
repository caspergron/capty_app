import 'package:app/extensions/string_ext.dart';
import 'package:app/models/common/media.dart';
import 'package:app/models/marketplace/sales_ad.dart';

class ChatBuddy {
  int? id;
  String? name;
  bool? isOnline;
  double? distance;
  String? lastSendTime;
  String? message;
  int? sendTimeInSec;
  Media? media;
  SalesAd? salesAd;

  String get full_name => name == null ? '' : name!.allFirstLetterCapital;
  bool get is_online => isOnline != null && isOnline == true;

  ChatBuddy({
    this.id,
    this.name,
    this.isOnline,
    this.distance,
    this.lastSendTime,
    this.message,
    this.sendTimeInSec,
    this.media,
    this.salesAd,
  });

  ChatBuddy.fromJson(json) {
    id = json['id'];
    name = json['name'];
    isOnline = json['is_online'];
    distance = json['distance'];
    lastSendTime = json['last_send_time'];
    message = json['msg'];
    sendTimeInSec = json['send_time_in_sec'];
    media = json['media'] != null ? Media.fromJson(json['media']) : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['is_online'] = isOnline;
    map['distance'] = distance;
    map['last_send_time'] = lastSendTime;
    map['msg'] = message;
    map['send_time_in_sec'] = sendTimeInSec;
    if (media != null) map['media'] = media?.toJson();
    if (salesAd != null) map['salesAd'] = salesAd?.toJson();
    return map;
  }
}
