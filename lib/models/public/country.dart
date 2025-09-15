import 'package:app/extensions/string_ext.dart';
import 'package:app/models/common/media.dart';
import 'package:app/models/public/currency.dart';
import 'package:app/models/public/language.dart';

var _DEFAULT_COUNTRY = Country();

class Country {
  int? id;
  String? name;
  String? code;
  String? phonePrefix;
  int? maxLength;
  int? minLength;
  String? appLanguage;
  Currency? currency;
  Language? language;
  Media? media;

  Country({
    this.id,
    this.name,
    this.code,
    this.phonePrefix,
    this.maxLength,
    this.minLength,
    this.appLanguage,
    this.currency,
    this.language,
    this.media,
  });

  Country.fromJson(json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    phonePrefix = json['phone_prefix'];
    maxLength = json['max_phone_length'];
    minLength = json['min_phone_length'];
    appLanguage = json['app_language'];
    currency = json['currency'] != null ? Currency.fromJson(json['currency']) : null;
    language = json['language'] != null ? Language.fromJson(json['language']) : null;
    media = json['media'] != null ? Media.fromJson(json['media']) : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['code'] = code;
    map['phone_prefix'] = phonePrefix;
    map['max_phone_length'] = maxLength;
    map['min_phone_length'] = minLength;
    map['app_language'] = appLanguage;
    if (currency != null) map['currency'] = currency?.toJson();
    if (language != null) map['language'] = language?.toJson();
    if (media != null) map['media'] = media?.toJson();
    return map;
  }

  static List<Country> countries_by_name(List<Country> countries, String key) {
    if (countries.isEmpty) return [];
    if (key.isEmpty) return countries;
    return countries.where((item) => item.name.toKey.startsWith(key.toKey)).toList();
  }

  static Country country_by_language_code(List<Country> countries, String code) {
    if (countries.isEmpty) return _DEFAULT_COUNTRY;
    if (code.isEmpty) return countries.first;
    final findIndex = countries.indexWhere((item) => item.appLanguage.toKey == code.toKey);
    return findIndex < 0 ? countries.first : countries[findIndex];
  }
}
