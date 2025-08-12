import 'package:flutter/material.dart';

import 'package:app/extensions/flutter_ext.dart';
import 'package:app/themes/colors.dart';

// colors: [Color(0xFF00246B), Color(0xFF9AAFEE), Color(0xFFCADCFC)],
var BACKGROUND_GRADIENT = LinearGradient(
  begin: const Alignment(0, 1),
  end: const Alignment(0, -1),
  colors: [primary.colorOpacity(0.8), const Color(0xFF9AAFEE), const Color(0xFFCADCFC)],
);

const PURPLE_GRADIENT = LinearGradient(
  begin: Alignment(0, -1),
  end: Alignment(0, 1),
  colors: [Color(0xffd2bcf6), Color(0xff9378c2), Color(0xff4e2c87)],
);
