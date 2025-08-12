import 'package:app/models/common/meta.dart';
import 'package:app/models/user/notification.dart';

class NotificationApi {
  bool? success;
  String? message;
  Meta? meta;
  List<Notification>? notifications;

  NotificationApi({this.success, this.message, this.meta, this.notifications});

  NotificationApi.fromJson(json) {
    success = json['success'];
    message = json['message'];
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
    notifications = [];
    if (json['data'] != null) json['data'].forEach((v) => notifications?.add(Notification.fromJson(v)));
  }

  NotificationApi copyWith({bool? success, String? message, Meta? meta, List<Notification>? notifications}) {
    return NotificationApi(
      success: success ?? this.success,
      message: message ?? this.message,
      meta: meta ?? this.meta,
      notifications: notifications ?? this.notifications,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    if (meta != null) map['meta'] = meta?.toJson();
    if (notifications != null) map['data'] = notifications?.map((v) => v.toJson()).toList();
    return map;
  }
}
