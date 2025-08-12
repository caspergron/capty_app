import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/repository/auth_repo.dart';
import 'package:app/services/routes.dart';

class OtpViewModel with ChangeNotifier {
  var loader = false;

  void initViewModel() {}

  void disposeViewModel() => loader = false;

  void updateUi() => notifyListeners();

  Future<void> onResendCode(Map<String, dynamic> parameters) async {
    loader = true;
    notifyListeners();
    var body = {'phone': parameters['phone_with_prefix']};
    if (kDebugMode) print(body);
    await sl<AuthRepository>().sendOtp(body: body, isToast: false);
    loader = false;
    notifyListeners();
  }

  Future<void> onVerifyOtp(Map<String, dynamic> parameters, String otpCode) async {
    loader = true;
    notifyListeners();
    var country = parameters['country'];
    var phoneWithPrefix = parameters['phone_with_prefix'];
    var body = {'phone': phoneWithPrefix, 'magic_code': otpCode, 'medium': 0};
    if (kDebugMode) print(body);
    var data = {'country': country, 'phone': parameters['phone'], 'medium': 0, 'social_id': '', 'name': '', 'email': ''};
    var response = await sl<AuthRepository>().verifyOtpCode(body);
    if (response != null) {
      var landing = Routes.user.landing();
      var onboard = Routes.auth.set_profile_1(data: data);
      unawaited(response.id == null ? onboard.push() : landing.pushAndRemove());
    }
    loader = false;
    notifyListeners();
  }
}
