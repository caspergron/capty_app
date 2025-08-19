import 'dart:io';

import 'package:flutter/material.dart';

import 'package:app/utils/size_config.dart';

abstract class Dimensions {
  static double dialog_width = SizeConfig.width - 32;
  static double dialog_padding = 20;
  static double leading_width = 56;
  static double screen_padding = 16;
}

/// Radius
var _RADIUS_16 = const Radius.circular(16);
var SHEET_RADIUS = BorderRadius.only(topLeft: _RADIUS_16, topRight: _RADIUS_16);
var DIALOG_RADIUS = BorderRadius.circular(12);
var DROPDOWN_RADIUS = BorderRadius.circular(08);

/// SHAPE
var DIALOG_SHAPE = RoundedRectangleBorder(borderRadius: DIALOG_RADIUS);
var BOTTOM_SHEET_SHAPE = RoundedRectangleBorder(borderRadius: SHEET_RADIUS);
var TOAST_SHAPE = RoundedRectangleBorder(borderRadius: BorderRadius.circular(4));

/// Durations
var DIALOG_DURATION = const Duration(milliseconds: 700);
var POP_DURATION = const Duration(milliseconds: 300);
var DURATION_1000 = const Duration(milliseconds: 1000);
var DURATION_700 = const Duration(milliseconds: 700);

/// Sizes
var ACTION_GAP = const SizedBox(width: 08);
var ACTION_SIZE = const SizedBox(width: 20);

var DIALOG_PADDING = 24.0;
var BOTTOM_GAP = (SizeConfig.bottom < 1 ? 0.0 : SizeConfig.bottom) + (Platform.isIOS ? 0 : 12);
var BOTTOM_GAP_NAV = Platform.isIOS ? (SizeConfig.bottom < 1 ? 8.0 : SizeConfig.bottom - 14) : SizeConfig.bottom + 08;

const DROPDOWN_ICON_PADDING = EdgeInsets.only(right: 12);
