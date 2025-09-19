import 'dart:convert';

import 'package:app/constants/data_constants.dart';
import 'package:app/constants/storage_keys.dart';
import 'package:app/di.dart';
import 'package:app/libraries/local_storage.dart';
import 'package:app/models/public/language.dart';
import 'package:app/models/user/user.dart';

final _storage = sl<LocalStorage>();

class StorageService {
  bool _hasData(String key) => _storage.hasLocalData(key: key);
  Future<void> removeData({required String key}) => _storage.removeData(key: key);

  int get appOpenCount => _storage.readData(key: APP_OPEN_COUNT) ?? 0;
  void setAppOpenCount(int data) => _storage.storeData(key: APP_OPEN_COUNT, value: data);

  bool get onboardStatus => _storage.readData(key: ON_BOARD) ?? false;
  void setOnboardStatus(bool status) => _storage.storeData(key: ON_BOARD, value: status);

  Language get language => !_hasData(LANGUAGE) ? DEFAULT_LANGUAGE : Language.fromJson(json.decode(_storage.readData(key: LANGUAGE)));
  void setLanguage(Language? data) => data == null ? null : _storage.storeData(key: LANGUAGE, value: json.encode(data));

  Map<String, dynamic>? get translations => _storage.readData(key: TRANSLATIONS);
  void setTranslations(Map<String, dynamic> data) => _storage.storeData(key: TRANSLATIONS, value: data);

  bool get rememberMe => _storage.readData(key: REMEMBER) ?? false;
  void setRememberStatus(bool status) => _storage.storeData(key: REMEMBER, value: status);

  // bool get authStatus => _storage.readData(key: AUTH_STATUS) ?? false;
  // void setAuthStatus(bool status) => _storage.storeData(key: AUTH_STATUS, value: status);

  // String get username => _storage.readData(key: USERNAME) ?? '';
  // void setUsername(String email) => _storage.storeData(key: USERNAME, value: email);

  // String get password => _storage.readData(key: PASSWORD) ?? '';
  // void setPassword(String passcode) => _storage.storeData(key: PASSWORD, value: passcode);

  String get phoneNumber => _storage.readData(key: PHONE_NUMBER) ?? '';
  void setPhoneNumber(String phone) => _storage.storeData(key: PHONE_NUMBER, value: phone);

  String get accessToken => _storage.readData(key: ACCESS_TOKEN) ?? '';
  void setAccessToken(String token) => _storage.storeData(key: ACCESS_TOKEN, value: token);

  String get refreshToken => _storage.readData(key: REFRESH_TOKEN) ?? '';
  void setRefreshToken(String token) => _storage.storeData(key: REFRESH_TOKEN, value: token);

  User get user => !_storage.hasLocalData(key: USER) ? User() : User.fromJson(json.decode(_storage.readData(key: USER)));
  void setUser(User? data) => data == null ? null : _storage.storeData(key: USER, value: json.encode(data));
}
