import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const _ID = 'high_importance_channel';
const _NAME = 'High Importance Notifications';
const _DESCRIPTION = 'This channel is used for important notifications.';
const _ANDROID_INITIALIZATION = AndroidInitializationSettings('ic_launcher');
const _IOS_INITIALIZATION = DarwinInitializationSettings();
const _INITIALIZATION_SETTINGS = InitializationSettings(android: _ANDROID_INITIALIZATION, iOS: _IOS_INITIALIZATION);

const _ANDROID_CHANNEL = AndroidNotificationChannel(_ID, _NAME, enableLights: true, importance: Importance.high, description: _DESCRIPTION);

// var _id = _ANDROID_CHANNEL.id;
// var _name = _ANDROID_CHANNEL.name;
// var _desc = _ANDROID_CHANNEL.description;
// var _ANDROID_DETAILS = AndroidNotificationDetails(_id, _name, showWhen: false, priority: Priority.high, importance: Importance.high, channelDescription: _desc);

class CloudNotification {
  final _localNotification = FlutterLocalNotificationsPlugin();

  Future<String?>? get getFcmToken async {
    try {
      return await FirebaseMessaging.instance.getToken();
    } catch (e) {
      if (kDebugMode) print(e.toString());
      return null;
    }
  }

  Future<void> initFirebaseNotification() async {
    await _localNotification
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_ANDROID_CHANNEL);
    await _localNotification.initialize(_INITIALIZATION_SETTINGS);
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, sound: true, badge: true);
    FirebaseMessaging.onMessage.listen(_firebaseOnMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_firebaseOnMessageOpenedApp);
  }

  void _firebaseOnMessage(RemoteMessage message) {
    var notification = message.notification;
    var androidNotification = message.notification?.android;
    var appleNotification = message.notification?.apple;
    var haveNotification = notification != null && (androidNotification != null || appleNotification != null);
    // if (haveNotification) _showNotification(message: message);
    if (haveNotification) foregroundNotificationActions(message);
  }

  void _firebaseOnMessageOpenedApp(RemoteMessage message) {
    var notification = message.notification;
    var androidNotification = message.notification?.android;
    var appleNotification = message.notification?.apple;
    var haveNotification = notification != null && (androidNotification != null || appleNotification != null);
    if (haveNotification) _backgroundNotificationActions(message);
  }

  void foregroundNotificationActions(RemoteMessage message) {}

  Future<dynamic> _backgroundNotificationActions(RemoteMessage message) async {}

  /*Future<void> _showNotification({required RemoteMessage message}) async {
    var desc = '';
    await _localNotification.show(
      message.notification.hashCode,
      message.notification?.title ?? 'Capty Disc Golf App',
      message.notification?.body ?? desc,
      NotificationDetails(android: _ANDROID_DETAILS),
    );
  }*/

  Future<void> getAndroidNotificationPermission() async {
    var notificationStatus =
        await _localNotification.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.areNotificationsEnabled();
    if (notificationStatus == null || !notificationStatus) {
      await _localNotification
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!
          .requestNotificationsPermission();
    }
  }
}
