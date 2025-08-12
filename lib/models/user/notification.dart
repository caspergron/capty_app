import 'package:app/constants/data_constants.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/utils/assets.dart';

class Notification {
  int? id;
  int? userId;
  String? notificationType;
  String? title;
  String? message;
  bool? isRead;
  String? sentAt;
  String? readAt;
  int? status;
  String? metadata;

  bool get is_read => isRead != null && isRead == true;

  Notification({
    this.id,
    this.userId,
    this.notificationType,
    this.title,
    this.message,
    this.isRead,
    this.sentAt,
    this.readAt,
    this.status,
    this.metadata,
  });

  Notification.fromJson(json) {
    id = json['id'];
    userId = json['user_id'];
    notificationType = json['notification_type'];
    title = json['title'];
    message = json['message'];
    isRead = json['is_read'];
    sentAt = json['sent_at'];
    readAt = json['read_at'];
    status = json['status'];
    metadata = json['metadata'];
  }

  Notification copyWith({
    int? id,
    int? userId,
    String? notificationType,
    String? title,
    String? message,
    bool? isRead,
    String? sentAt,
    String? readAt,
    int? status,
    metadata,
  }) {
    return Notification(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      notificationType: notificationType ?? this.notificationType,
      title: title ?? this.title,
      message: message ?? this.message,
      isRead: isRead ?? this.isRead,
      sentAt: sentAt ?? this.sentAt,
      readAt: readAt ?? this.readAt,
      status: status ?? this.status,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['user_id'] = userId;
    map['notification_type'] = notificationType;
    map['title'] = title;
    map['message'] = message;
    map['is_read'] = isRead;
    map['sent_at'] = sentAt;
    map['read_at'] = readAt;
    map['status'] = status;
    map['metadata'] = metadata;
    return map;
  }

  String get type_based_notify_icon {
    var notifyKey = notificationType.toKey;
    if (notifyKey == SEND_MESSAGE.toKey || notifyKey == SEND_MESSAGE_1_DAY.toKey || notifyKey == SEND_MESSAGE_3_DAY.toKey) {
      return Assets.svg1.comment;
    } else if (notifyKey == RECEIVE_FRIEND_REQUEST.toKey || notifyKey == ACCEPT_FRIEND_REQUEST.toKey) {
      return Assets.svg1.coach_plus;
    } else {
      return Assets.svg1.bell;
    }
  }
}
