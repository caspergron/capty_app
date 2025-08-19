import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/app_utils.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/size_config.dart';
import 'package:flutter/material.dart';

ThemeData get LIGHT_THEME {
  return ThemeData(
    cardColor: white,
    useMaterial3: false,
    fontFamily: roboto,
    primaryColor: primary,
    dividerColor: grey,
    disabledColor: grey,
    hintColor: grey,
    primarySwatch: Colors.deepPurple,
    splashColor: transparent,
    focusColor: transparent,
    hoverColor: transparent,
    highlightColor: transparent,
    scaffoldBackgroundColor: skyBlue,
    brightness: Brightness.light,
    visualDensity: VisualDensity.standard,
    colorScheme: _colorScheme,
    tabBarTheme: _tabBarTheme,
    popupMenuTheme: const PopupMenuThemeData(menuPadding: EdgeInsets.zero, shape: RoundedRectangleBorder()),
    datePickerTheme: _datePickerThemeData,
    elevatedButtonTheme: ElevatedButtonThemeData(style: _elevatedButtonTheme),
    outlinedButtonTheme: OutlinedButtonThemeData(style: _outlineButtonTheme),
    textButtonTheme: TextButtonThemeData(style: _textButtonTheme),
    dialogTheme: _dialogThemeData,
    appBarTheme: _appBarTheme,
    radioTheme: _radioThemeLight,
    checkboxTheme: _checkBoxThemeLight,
    buttonTheme: _buttonTheme,
    primaryIconTheme: _primaryIconTheme,
    floatingActionButtonTheme: _floatingActionButtonTheme,
    bottomNavigationBarTheme: _bottomNavigationBarTheme,
    bottomAppBarTheme: _bottomAppBarTheme,
    dividerTheme: const DividerThemeData(thickness: 1, space: 1, color: offWhite4),
    sliderTheme: _sliderThemeData,
    bottomSheetTheme: _bottomSheetTheme,
    drawerTheme: _drawerTheme,
    timePickerTheme: _timePickerThemeData,
  );

  /*return ThemeData(
    drawerTheme: _drawerThemeLight,
    bottomSheetTheme: _bottomSheetThemeLight,
    bottomAppBarTheme: _bottomAppBarThemeLight,
  );*/
}

const _colorScheme = ColorScheme.light(
  primary: primary,
  primaryContainer: white,
  secondaryContainer: dark,
  errorContainer: error,
  onErrorContainer: Color(0XFFEDEFF5),
  onPrimaryContainer: primary,
  onError: error,
);

get _primaryIconTheme => const IconThemeData(color: grey, size: 24);

get _drawerTheme => DrawerThemeData(elevation: 0.5, backgroundColor: offWhite1, scrimColor: popupBearer, width: 70.width);

get _datePickerThemeData {
  return DatePickerThemeData(
    backgroundColor: white,
    cancelButtonStyle: const ButtonStyle(foregroundColor: WidgetStatePropertyAll(primary)),
    confirmButtonStyle: const ButtonStyle(foregroundColor: WidgetStatePropertyAll(orange)),
    // weekdayStyle: TextStyles.text16_600.copyWith(color: primary.colorOpacity(0.8)),
    dayStyle: TextStyles.text14_400.copyWith(color: primary, fontSize: 13),
    headerForegroundColor: white,
    headerHelpStyle: TextStyles.text14_600.copyWith(color: white),
  );
}

get _timePickerThemeData {
  return const TimePickerThemeData(
    backgroundColor: white,
    cancelButtonStyle: ButtonStyle(foregroundColor: WidgetStatePropertyAll(primary)),
    confirmButtonStyle: ButtonStyle(foregroundColor: WidgetStatePropertyAll(orange)),
  );
}

get _dialogThemeData {
  return DialogThemeData(
    elevation: 2,
    iconColor: lightBlue,
    backgroundColor: primary,
    alignment: Alignment.center,
    titleTextStyle: TextStyles.text18_700.copyWith(color: lightBlue),
    contentTextStyle: TextStyles.text18_700.copyWith(color: lightBlue),
    shape: RoundedRectangleBorder(borderRadius: DIALOG_RADIUS),
  );
}

get _sliderThemeData {
  return const SliderThemeData(
    trackHeight: 10,
    activeTrackColor: orange,
    inactiveTrackColor: lightBlue,
    disabledActiveTrackColor: lightBlue,
    disabledInactiveTrackColor: lightBlue,
    thumbColor: lightBlue,
    allowedInteraction: SliderInteraction.slideOnly,
    valueIndicatorTextStyle: TextStyle(color: white, fontSize: 13, height: 1.38, fontWeight: w500, fontFamily: roboto),
    valueIndicatorColor: transparent,
    showValueIndicator: ShowValueIndicator.always,
    rangeThumbShape: RoundRangeSliderThumbShape(enabledThumbRadius: 12),
    rangeTickMarkShape: RoundRangeSliderTickMarkShape(tickMarkRadius: 0),
    overlayShape: RoundSliderOverlayShape(overlayRadius: 0),
    thumbShape: RoundSliderThumbShape(disabledThumbRadius: 0),
    trackShape: RoundedRectSliderTrackShape(),
    rangeTrackShape: RectangularRangeSliderTrackShape(),
    rangeValueIndicatorShape: PaddleRangeSliderValueIndicatorShape(),
    tickMarkShape: RoundSliderTickMarkShape(tickMarkRadius: 4),
  );
}

get _bottomSheetTheme {
  return BottomSheetThemeData(
    elevation: SizeConfig.isMobile ? 3 : 0,
    modalElevation: SizeConfig.isMobile ? 3 : 0,
    showDragHandle: false,
    // backgroundColor: grey4,
    // modalBackgroundColor: grey4,
    backgroundColor: transparent,
    modalBackgroundColor: transparent,
    clipBehavior: Clip.antiAliasWithSaveLayer,
    shape: RoundedRectangleBorder(borderRadius: SHEET_RADIUS),
  );
}

get _tabBarTheme => TabBarThemeData(
      labelColor: primary,
      unselectedLabelColor: primary,
      labelStyle: TextStyles.text16_600.copyWith(fontWeight: w500),
      unselectedLabelStyle: TextStyles.text16_600.copyWith(fontWeight: w500),
      indicatorSize: TabBarIndicatorSize.tab,
      labelPadding: const EdgeInsets.symmetric(horizontal: 10),
      indicatorColor: primary,
      dividerColor: primary,
      indicatorAnimation: TabIndicatorAnimation.elastic,
      indicator: const UnderlineTabIndicator(borderSide: BorderSide(color: primary)),
    );

get _appBarTheme {
  return AppBarTheme(
    elevation: 1,
    titleSpacing: 20,
    centerTitle: true,
    toolbarHeight: 60,
    shadowColor: mediumBlue,
    backgroundColor: skyBlue,
    systemOverlayStyle: OVERLAY_STYLE,
    titleTextStyle: TextStyles.text20_500.copyWith(color: primary),
    toolbarTextStyle: TextStyles.text20_500.copyWith(color: primary),
    iconTheme: const IconThemeData(color: primary, size: 24),
    actionsIconTheme: const IconThemeData(color: primary, size: 24),
  );
}

get _bottomAppBarTheme => const BottomAppBarTheme(color: primary, elevation: 3);

get _bottomNavigationBarTheme {
  return const BottomNavigationBarThemeData(
    elevation: 4,
    backgroundColor: primary,
    showSelectedLabels: true,
    showUnselectedLabels: true,
    selectedItemColor: white,
    unselectedItemColor: offWhite4,
    selectedIconTheme: IconThemeData(size: 24, color: white),
    unselectedIconTheme: IconThemeData(size: 24, color: offWhite4),
    selectedLabelStyle: TextStyle(color: white, fontSize: 14, height: 1.57, fontWeight: w500, fontFamily: roboto),
    unselectedLabelStyle: TextStyle(color: offWhite4, fontSize: 14, height: 1.57, fontWeight: w500, fontFamily: roboto),
    type: BottomNavigationBarType.fixed,
    landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
  );
}

get _checkBoxThemeLight {
  return CheckboxThemeData(
    splashRadius: 4,
    materialTapTargetSize: MaterialTapTargetSize.padded,
    checkColor: WidgetStateProperty.all(white),
    side: const BorderSide(color: offWhite2),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(04)),
    visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
    fillColor: WidgetStateColor.resolveWith((states) => states.contains(WidgetState.selected) ? primary : transparent),
  );
}

get _radioThemeLight {
  return RadioThemeData(
    splashRadius: 4,
    visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
    fillColor: WidgetStateColor.resolveWith((states) => states.contains(WidgetState.selected) ? primary : grey),
  );
}

get _buttonTheme {
  return ButtonThemeData(
    height: 48,
    minWidth: 50,
    disabledColor: grey,
    buttonColor: primary,
    focusColor: transparent,
    hoverColor: transparent,
    splashColor: transparent,
    highlightColor: transparent,
    padding: const EdgeInsets.symmetric(horizontal: 18),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );
}

get _elevatedButtonTheme {
  return ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(horizontal: 18),
    elevation: 0.5,
    foregroundColor: white,
    backgroundColor: primary,
    disabledForegroundColor: offWhite3,
    disabledBackgroundColor: primary.colorOpacity(0.5),
    disabledMouseCursor: MouseCursor.defer,
    visualDensity: VisualDensity.standard,
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    textStyle: TextStyles.text14_700.copyWith(color: white),
    side: const BorderSide(color: transparent, width: 0),
    minimumSize: const Size(50, 48),
    maximumSize: const Size(double.infinity, 48),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );
}

get _outlineButtonTheme {
  return OutlinedButton.styleFrom(
    padding: const EdgeInsets.symmetric(horizontal: 18),
    elevation: 0.5,
    shadowColor: transparent,
    foregroundColor: offWhite3,
    backgroundColor: transparent,
    disabledForegroundColor: offWhite3,
    disabledBackgroundColor: transparent,
    enabledMouseCursor: MouseCursor.uncontrolled,
    disabledMouseCursor: MouseCursor.defer,
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    textStyle: TextStyles.text14_700.copyWith(color: white),
    minimumSize: const Size(50, 48),
    maximumSize: const Size(double.infinity, 48),
    side: const BorderSide(color: offWhite4),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    visualDensity: VisualDensity.standard,
  );
}

get _textButtonTheme {
  return TextButton.styleFrom(
    padding: const EdgeInsets.symmetric(horizontal: 18),
    elevation: 0.5,
    shadowColor: transparent,
    foregroundColor: offWhite3,
    backgroundColor: transparent,
    visualDensity: VisualDensity.standard,
    textStyle: TextStyles.text14_700.copyWith(color: dark),
  );
}

get _floatingActionButtonTheme {
  return FloatingActionButtonThemeData(
    elevation: 3,
    iconSize: 24,
    backgroundColor: primary,
    foregroundColor: white,
    hoverColor: transparent,
    splashColor: transparent,
    focusColor: transparent,
    disabledElevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
  );
}
