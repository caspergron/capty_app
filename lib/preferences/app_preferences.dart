import 'dart:io';

import 'package:app/constants/data_constants.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/libraries/device_info.dart';
import 'package:app/models/common/tag.dart';
import 'package:app/models/public/country.dart';
import 'package:app/models/public/currency.dart';
import 'package:app/models/public/language.dart';
import 'package:app/repository/marketplace_repo.dart';
import 'package:app/repository/public_repo.dart';
import 'package:app/services/storage_service.dart';

class AppPreferences {
  static var appVersion = '';
  static var userAgent = '';
  static var countries = <Country>[];
  static var currencies = <Currency>[];
  static var languages = <Language>[];
  static var translations = <String, dynamic>{};
  static var language = DEFAULT_LANGUAGE;
  // static var brands = <Brand>[];
  static var specialTags = <Tag>[];
  static var discTypeTags = <Tag>[];

  static void setLanguage(Language? data) => data == null ? null : language = data;
  static void setTranslations(Map<String, dynamic> data) => data.isNotEmpty ? translations = data : null;

  static Future<List<Country>> fetchCountries() async {
    if (countries.haveList) return countries;
    countries = await sl<PublicRepository>().fetchCountries();
    return countries;
  }

  static Future<List<Currency>> fetchCurrencies() async {
    if (currencies.haveList) return currencies;
    currencies = await sl<PublicRepository>().fetchCurrencies();
    return currencies;
  }

  static Future<List<Language>> fetchLanguages() async {
    if (languages.haveList) return languages;
    languages = await sl<PublicRepository>().fetchLanguages();
    return languages;
  }

  /*static Future<List<Brand>> fetchBrands() async {
    if (brands.haveList) return brands;
    brands = await sl<PublicRepository>().fetchAllBrands();
    return brands;
  }*/

  static Future<List<Tag>> fetchSpecialDiscTags() async {
    if (specialTags.haveList) return specialTags;
    specialTags = await sl<MarketplaceRepository>().fetchSpecialityDiscMenus();
    return specialTags;
  }

  static Future<List<Tag>> fetchDiscTypeTags() async {
    if (discTypeTags.haveList) return discTypeTags;
    discTypeTags = await sl<PublicRepository>().fetchDiscTypes();
    return discTypeTags;
  }

  static Future<String> get fetchAppVersion async => appVersion = appVersion.isNotEmpty ? appVersion : await sl<DeviceInfo>().appVersion;

  static Future<String> get fetchUserAgent async {
    if (userAgent.isNotEmpty) return userAgent;
    final os = Platform.isIOS ? 'iOS' : 'Android';
    final langCode = sl<StorageService>().language.code ?? 'en';
    final appVersion = await sl<DeviceInfo>().appVersion;
    final deviceInfo = '$os/${await sl<DeviceInfo>().deviceVersion}/${await sl<DeviceInfo>().deviceName}';
    final appInfo = 'capty/$appVersion ${Platform.isIOS ? 'CFNetwork/1474 Darwin' : ''} ($langCode)'.trim();
    userAgent = '$deviceInfo $appInfo'.trim();
    return userAgent;
  }

  static void clearPreferences() {}
}
