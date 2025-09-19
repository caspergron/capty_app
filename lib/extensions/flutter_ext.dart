import 'dart:math';

import 'package:flutter/material.dart';

import 'package:app/constants/app_keys.dart';

DateTime get currentDate => DateTime.now();
BuildContext get _context => navigatorKey.currentState!.context;

extension ListExtension on List<dynamic>? {
  bool get haveList => this != null && this!.length > 0;
}

extension FlutterExtensions on void {
  void backToPrevious() => Navigator.of(navigatorKey.currentState!.context).pop();
  void minimizeKeyboard() => FocusScope.of(navigatorKey.currentState!.context).unfocus();
}

extension PushRoute on Widget {
  Future<dynamic> push() => Navigator.push(_context, MaterialPageRoute(builder: (c) => this));
  Future<void> pushReplacement() => Navigator.pushReplacement(_context, MaterialPageRoute(builder: (c) => this));
  Future<dynamic> pushAndRemove() => Navigator.pushAndRemoveUntil(_context, MaterialPageRoute(builder: (c) => this), (route) => false);
}

extension ParseColor on Color {
  Color colorOpacity(double opacity) => withValues(alpha: opacity);
}

Color get generateRandomColor {
  final random = Random();
  final red = random.nextInt(156);
  final green = random.nextInt(156);
  final blue = random.nextInt(156);
  return Color.fromARGB(255, red, green, blue);
}

extension DateTimeExtension on TimeOfDay {
  DateTime get timeOfDayToDateTime => DateTime(currentDate.year, currentDate.month, currentDate.day, hour, minute);
}

extension TimeOfDayExtension on DateTime {
  TimeOfDay get dateTimeToTimeOfDay => TimeOfDay(hour: hour, minute: minute);
}
