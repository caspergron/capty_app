import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as time_ago;

import 'package:app/extensions/string_ext.dart';
import 'package:app/preferences/app_preferences.dart';

class Formatters {
  // NumberFormat.currency().format(123456); // USD123,456.00
  // NumberFormat.currency(locale: 'eu').format(123456); // 123.456,00 EUR
  // NumberFormat.currency(name: 'EURO').format(123456); // EURO123,456.00
  // NumberFormat.currency(locale: 'eu', symbol: '?').format(123456); // 123.456,00 ?
  // NumberFormat.currency(locale: 'eu', decimalDigits: 3).format(123456); // 123.456,000 EUR
  // NumberFormat.currency(locale: 'eu', customPattern: '\u00a4 #,##.#').format(123456); // EUR 12.34.56,00

  static String formatDecimalNumber(String value) {
    var formatter = NumberFormat.decimalPattern();
    return formatter.format(value.stringToInt);
  }

  static String formatDate(String format, String? date) {
    if (date == null || date == '') return '';
    var formatter = DateFormat(format, AppPreferences.language.code);
    return formatter.format(date.parseDate);
  }

  static String formatTime(String? date) {
    if (date == null || date == '') return '';
    return time_ago.format(date.parseDate, locale: AppPreferences.language.code, allowFromNow: true);
  }

  static void registerTimeAgoLocales(String localeCode) {
    if (localeCode == 'en') {
      time_ago.setLocaleMessages('en', time_ago.EnMessages());
    } else if (localeCode == 'sv') {
      time_ago.setLocaleMessages('sv', time_ago.SvMessages());
    } else if (localeCode == 'fi') {
      time_ago.setLocaleMessages('fi', time_ago.FiMessages());
    } else if (localeCode == 'no' || localeCode == 'nb') {
      time_ago.setLocaleMessages('nb', time_ago.NbNoMessages());
    } else if (localeCode == 'et') {
      time_ago.setLocaleMessages('et', time_ago.EtMessages());
    } else if (localeCode == 'da') {
      time_ago.setLocaleMessages('da', time_ago.DaMessages());
    } else if (localeCode == 'ja') {
      time_ago.setLocaleMessages('ja', time_ago.JaMessages());
    } else {
      time_ago.setLocaleMessages('en', time_ago.EnMessages());
    }
  }
}
