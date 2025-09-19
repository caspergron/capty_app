import 'dart:io';

import 'package:flutter/material.dart';

import 'package:another_flushbar/flushbar.dart';

import 'package:app/constants/app_keys.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/themes/colors.dart';
import 'package:app/utils/assets.dart';
import 'package:app/widgets/library/svg_image.dart';

final _SUCCESS = _FLushModel(title: '${'congratulations'.recast}!!', icon: Assets.svg2.check_circle);
final _WARNING = _FLushModel(title: '${'attention'.recast}!', background: warning, icon: Assets.svg2.danger);
final _INFO = _FLushModel(title: 'message'.recast, background: info, icon: Assets.svg2.info);
final _ERROR = _FLushModel(title: '${'error'.recast}!', background: error, icon: Assets.svg2.danger_triangle);

class FlushPopup {
  static void onSuccess({required String message}) => _showFlushBar(model: _SUCCESS, message: message);
  static void onInfo({required String message}) => _showFlushBar(model: _INFO, message: message);
  static void onWarning({required String message}) => _showFlushBar(model: _WARNING, message: message);
  static void onError({required String message}) => _showFlushBar(model: _ERROR, message: message);

  static void _showFlushBar({required _FLushModel model, required String message}) {
    final radius = BorderRadius.circular(10);
    const direction = FlushbarDismissDirection.HORIZONTAL;
    const padding = EdgeInsets.symmetric(horizontal: 20, vertical: 15);
    final margin = EdgeInsets.only(left: 20, right: 20, top: Platform.isAndroid ? 20 : 0);
    final icon = model.icon.isEmpty ? Assets.svg2.info : model.icon;
    Flushbar(
      titleSize: 16,
      messageSize: 14,
      titleColor: white,
      messageColor: white,
      title: model.title,
      borderRadius: radius,
      dismissDirection: direction,
      padding: padding,
      margin: margin,
      icon: SvgImage(image: icon, height: 28, color: lightBlue),
      backgroundColor: model.background,
      duration: const Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.TOP,
      message: message.isEmpty ? 'message_not_found'.recast : message,
    ).show(navigatorKey.currentContext!);
  }
}

class _FLushModel {
  String icon;
  String title;
  Color background;
  _FLushModel({this.title = '', this.background = success, this.icon = ''});
}
