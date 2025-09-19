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
const _RADIUS_16 = Radius.circular(16);
const SHEET_RADIUS = BorderRadius.only(topLeft: _RADIUS_16, topRight: _RADIUS_16);
final DIALOG_RADIUS = BorderRadius.circular(12);
final DROPDOWN_RADIUS = BorderRadius.circular(08);

/// SHAPE
final DIALOG_SHAPE = RoundedRectangleBorder(borderRadius: DIALOG_RADIUS);
const BOTTOM_SHEET_SHAPE = RoundedRectangleBorder(borderRadius: SHEET_RADIUS);
final TOAST_SHAPE = RoundedRectangleBorder(borderRadius: BorderRadius.circular(4));

/// Durations
const DIALOG_DURATION = Duration(milliseconds: 700);
const POP_DURATION = Duration(milliseconds: 300);
const DURATION_1000 = Duration(milliseconds: 1000);
const DURATION_700 = Duration(milliseconds: 700);

/// Sizes
const ACTION_GAP = SizedBox(width: 08);
const ACTION_SIZE = SizedBox(width: 20);

const DIALOG_PADDING = 24.0;
final BOTTOM_GAP = (SizeConfig.bottom < 1 ? 0.0 : SizeConfig.bottom) + (Platform.isIOS ? 0 : 12);
final BOTTOM_GAP_NAV = Platform.isIOS ? (SizeConfig.bottom < 1 ? 8.0 : SizeConfig.bottom - 14) : SizeConfig.bottom + 08;

const DROPDOWN_ICON_PADDING = EdgeInsets.only(right: 12);
