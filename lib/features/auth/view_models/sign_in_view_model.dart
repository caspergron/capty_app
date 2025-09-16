import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/libraries/flush_popup.dart';
import 'package:app/libraries/social_login.dart';
import 'package:app/models/public/country.dart';
import 'package:app/models/public/language.dart';
import 'package:app/preferences/app_preferences.dart';
import 'package:app/repository/auth_repo.dart';
import 'package:app/repository/public_repo.dart';
import 'package:app/services/routes.dart';
import 'package:app/services/storage_service.dart';

class SignInViewModel with ChangeNotifier {
  var loader = true;
  var isPolicy = false;
  var country = Country();

  Future<void> initViewModel() async {
    // country = sl<StorageService>().user.country_item;
    final countries = await AppPreferences.fetchCountries();
    final languageCode = sl<StorageService>().language.code ?? 'en';
    country = Country.country_by_language_code(countries, languageCode);
    isPolicy = sl<StorageService>().rememberMe;
    loader = false;
    notifyListeners();
  }

  void updateUi() => notifyListeners();

  void disposeViewModel() {
    loader = false;
    isPolicy = false;
    country = Country();
  }

  Future<void> onChangeLanguage(Language item) async {
    loader = true;
    notifyListeners();
    await sl<PublicRepository>().fetchTranslations(item);
    loader = false;
    notifyListeners();
  }

  Future<void> onSignIn(String phone) async {
    loader = true;
    notifyListeners();
    var body = {'phone': '${country.phonePrefix}$phone'};
    var parameters = {'country': country, 'phone': phone, 'phone_with_prefix': '${country.phonePrefix}$phone'};
    if (kDebugMode) print(body);
    var response = await sl<AuthRepository>().sendOtp(body: body, phone: phone, isRemember: isPolicy);
    if (response != null) unawaited(Routes.auth.otp_screen(data: parameters).push());
    loader = false;
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    var google = await sl<SocialLogin>().googleSignIn();
    if (google == null) return;
    loader = true;
    notifyListeners();
    var name = google.displayName ?? '';
    var body = {'social_id': google.id, 'medium': 1};
    var params = {'social_id': google.id, 'medium': 1, 'name': name, 'email': google.email, 'phone': '', 'country': country};
    var response = await sl<AuthRepository>().checkSocialLogin(body);
    response != null ? unawaited(Routes.user.landing().pushAndRemove()) : unawaited(Routes.auth.set_profile_1(data: params).push());
    loader = false;
    notifyListeners();
  }

  Future<void> signInWithApple() async {
    var apple = await sl<SocialLogin>().appleSignIn();
    if (apple == null) return;
    if (apple.userIdentifier == null) return FlushPopup.onWarning(message: 'please_sign_out_from_icloud'.recast);
    loader = true;
    notifyListeners();
    var name = apple.givenName ?? '';
    var email = apple.email ?? '';
    var body = {'social_id': apple.userIdentifier!, 'medium': 2};
    var params = {'social_id': apple.userIdentifier!, 'medium': 2, 'name': name, 'email': email, 'phone': '', 'country': country};
    var response = await sl<AuthRepository>().checkSocialLogin(body);
    response != null ? unawaited(Routes.user.landing().pushAndRemove()) : unawaited(Routes.auth.set_profile_1(data: params).push());
    loader = false;
    notifyListeners();
  }
}
