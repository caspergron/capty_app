import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:app/models/map/coordinates.dart';
import 'package:app/models/public/language.dart';
import 'package:app/models/system/loader.dart';
import 'package:app/themes/colors.dart';
import 'package:app/utils/assets.dart';
import 'package:app/widgets/library/svg_image.dart';

/// Log Event Keys: created_sales_ad, created_wishlist_disc, added_disc, club_view, leaderboard_view, invite_friend, contact_seller_view,

/// Push Notification Keys
const SEND_MESSAGE = 'chat_message';
const SEND_MESSAGE_1_DAY = 'chat_day_after';
const SEND_MESSAGE_3_DAY = 'chat_day_after_3';
const RECEIVE_FRIEND_REQUEST = 'friend_request';
const ACCEPT_FRIEND_REQUEST = 'friend_accept';

/// Constant Data
const DEFAULT_ID = 00000;
const LENGTH_20 = 20;
const LENGTH_10 = 10;
// const LENGTH_08 = 08;
const String DROPDOWN_SPACE = '     ';

/// Default Data
var DEFAULT_LOADER = Loader();
var DEFAULT_LANGUAGE = Language(id: 1, name: 'English', code: 'en', flag: 'https://flagcdn.com/au.svg');
var DROPDOWN_ICON = SvgImage(image: Assets.svg1.caret_down_1, height: 24, color: dark);
var INITIAL_COORDINATES = Coordinates(lat: 43.653225, lng: -79.383186);

/// Google Map Data
const ZOOM = 15.0;
const INITIAL_POSITION = LatLng(43.653225, -79.383186);
const CAMERA_POSITION = CameraPosition(target: INITIAL_POSITION, zoom: ZOOM);

/// Constant Lists
const IMAGE_EXTENSIONS = ['png', 'PNG', 'jpg', 'JPG', 'jpeg', 'JPEG', 'bmp'];
const DISC_OPTIONS = ['color', 'image'];
const PREDEFINED_COLORS = [
  Color(0xFFB71C1C),
  Color(0xFF1B5E20),
  Color(0xFF0D47A1),
  Color(0xFFFF6F00),
  Color(0xFFE65100),
  Color(0xFF006064),
  Color(0xFF4A148C),
  Color(0xFF827717),
  Color(0xFF004D40),
];
const SUPPORTED_LOCALES = [Locale('en'), Locale('sv'), Locale('fi'), Locale('no'), Locale('et'), Locale('da'), Locale('ja')];
const List<String> USED_DISC_INFO = [
  'extremely_used_hardly_recognizable',
  'extremely_used',
  'very_used',
  'used_a_lot_fully_covered_in_marks_cuts_or_scratches_very_altered_flight_compared_to_new',
  'used_a_lot_of_marks_cuts_or_scratches_altered_flight_compared_to_new',
  'used_normal_marks_cuts_or_scratches_slightly_altered_flight_compared_to_new',
  'lightly_used_with_a_few_marks_cuts_or_scratches_flies_as_new',
  'lightly_used_no_significant_marks_cuts_or_scratches_flies_as_new',
  'as_good_as_new_tested_a_couple_of_times_has_name_and_number_inside',
  'no_marks_cuts_or_scratches_no_name_inside',
];
