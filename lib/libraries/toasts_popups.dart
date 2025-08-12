import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:app/themes/colors.dart';
import 'package:app/utils/assets.dart';

var _SUCCESS = _ToastModel(icon: Assets.svg2.check_circle);
var _WARNING = _ToastModel(background: warning, icon: Assets.svg2.danger);
var _INFO = _ToastModel(background: info, icon: Assets.svg2.info);
var _ERROR = _ToastModel(background: error, icon: Assets.svg2.danger_triangle);
var _TOAST = _ToastModel(background: dark, icon: Assets.svg2.info);

class ToastPopup {
  static void onToast({required String message, bool isTop = true}) => _showToast(model: _TOAST, message: message, isTop: isTop);
  static void onInfo({required String message, bool isTop = true}) => _showToast(model: _INFO, message: message, isTop: isTop);
  static void onSuccess({required String message, bool isTop = true}) => _showToast(model: _SUCCESS, message: message, isTop: isTop);
  static void onWarning({required String message, bool isTop = true}) => _showToast(model: _WARNING, message: message, isTop: isTop);
  static void onError({required String message, bool isTop = true}) => _showToast(model: _ERROR, message: message, isTop: isTop);

  static void _showToast({required _ToastModel model, required String message, required bool isTop}) {
    var color = lightBlue;
    var background = model.background;
    var length = Toast.LENGTH_LONG;
    var top = isTop ? ToastGravity.TOP : ToastGravity.BOTTOM;
    Fluttertoast.showToast(msg: message, textColor: color, fontSize: 16, backgroundColor: background, toastLength: length, gravity: top);
  }
}

class _ToastModel {
  Color background;
  String icon;

  _ToastModel({this.background = success, this.icon = ''});
}
