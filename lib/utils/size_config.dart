import 'package:flutter/widgets.dart';

class SizeConfig {
  static double width = 0;
  static double height = 0;
  static double statusBar = 0;
  static double bottom = 0;

  static bool isPortrait = false;
  static bool isSmall = false;
  static bool isMobile = false;
  static bool isTablet = false;
  static bool isDesktop = false;
  static bool bNotch = false;

  static void initMediaQuery(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    statusBar = mediaQuery.padding.top;
    bottom = mediaQuery.viewPadding.bottom;
    bNotch = mediaQuery.viewPadding.bottom > 0;
  }

  static void initLayoutBuilder(BoxConstraints constraints, Orientation orientation) {
    width = constraints.maxWidth;
    height = constraints.maxHeight;
    isSmall = width <= 375;
    isMobile = width < 601;
    isTablet = width >= 601 && width < 1024;
    isDesktop = width >= 1100;
    isPortrait = orientation == Orientation.portrait;
  }
}
