import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:app/di.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/interfaces/api_interceptor.dart';
import 'package:app/libraries/cloud_notification.dart';
import 'package:app/libraries/device_info.dart';
import 'package:app/libraries/flush_popup.dart';
import 'package:app/libraries/toasts_popups.dart';
import 'package:app/models/user/auth_api.dart';
import 'package:app/models/user/user.dart';
import 'package:app/services/auth_service.dart';
import 'package:app/services/storage_service.dart';
import 'package:app/utils/api_url.dart';

class AuthRepository {
  Future<Map<String, dynamic>?> sendOtp(
      {Map<String, dynamic> body = const {}, String phone = '', bool isRemember = true, bool isToast = true}) async {
    var endpoint = ApiUrl.auth.sendOtp;
    var apiResponse = await sl<ApiInterceptor>().postRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) return null;
    sl<StorageService>().setRememberStatus(isRemember);
    if (phone.isNotEmpty) sl<StorageService>().setPhoneNumber(phone);
    var message = 'a_verification_code_sent_to_your_phone_number'.recast;
    isToast ? ToastPopup.onInfo(message: message) : FlushPopup.onInfo(message: message);
    return apiResponse.response['data'];
  }

  Future<User?> verifyOtpCode(Map<String, dynamic> body) async {
    var endpoint = ApiUrl.auth.verifyOtp;
    var finalBody = await _deviceInfo(body);
    var apiResponse = await sl<ApiInterceptor>().postRequest(endpoint: endpoint, body: finalBody);
    if (apiResponse.status == 200) {
      var authApi = AuthApi.fromJson(apiResponse.response['data']);
      if (authApi.isUser == null || !authApi.isUser!) return User();
      sl<AuthService>().setUserInfo(authApi);
      return authApi.user;
    } else {
      FlushPopup.onWarning(message: 'invalid_verification_code'.recast);
      return null;
    }
  }

  Future<AuthApi?> createAccount(Map<String, dynamic> body) async {
    var endpoint = ApiUrl.auth.createAccount;
    var finalBody = await _deviceInfo(body);
    var apiResponse = await sl<ApiInterceptor>().postRequest(endpoint: endpoint, body: finalBody);
    if (apiResponse.status == 200) {
      var authApi = AuthApi.fromJson(apiResponse.response['data']);
      sl<AuthService>().setUserInfo(authApi);
      return authApi;
    } else {
      var response = apiResponse.response;
      if (!response.containsKey('message')) return null;
      var message = response['message'];
      var isUDisc = message != null && message == 'The udisc username has already been taken.';
      if (isUDisc) FlushPopup.onWarning(message: 'the_udisc_username_has_already_exists'.recast);
      var isPgda = message != null && message == 'The pdga number has already been taken.';
      if (isPgda) FlushPopup.onWarning(message: 'the_pdga_number_has_already_exists'.recast);
      var isEmailExist = message != null && message == 'The email has already been taken.';
      if (isEmailExist) FlushPopup.onWarning(message: 'email_already_exist_please_try_with_a_new_email'.recast);
      return null;
    }
  }

  Future<Map<String, dynamic>> _deviceInfo(Map<String, dynamic> body) async {
    body['os'] = Platform.isIOS ? 0 : 1; // ios: 0, android: 1
    body['device_model'] = await sl<DeviceInfo>().deviceName;
    body['device_id'] = await sl<DeviceInfo>().deviceId;
    body['app_version'] = await sl<DeviceInfo>().appVersion;
    body['fcm_key'] = await sl<CloudNotification>().getFcmToken;
    if (kDebugMode) print(body);
    return body;
  }

  Future<AuthApi?> checkSocialLogin(Map<String, dynamic> body) async {
    var endpoint = ApiUrl.auth.checkSocialLogin;
    var finalBody = await _deviceInfo(body);
    var apiResponse = await sl<ApiInterceptor>().postRequest(endpoint: endpoint, body: finalBody);
    if (apiResponse.status != 200) return null;
    var authApi = AuthApi.fromJson(apiResponse.response['data']);
    sl<AuthService>().setUserInfo(authApi);
    return authApi;
  }

  Future<bool> checkUniqueUser(Map<String, dynamic> body) async {
    var endpoint = ApiUrl.auth.checkUnique;
    var apiResponse = await sl<ApiInterceptor>().postRequest(endpoint: endpoint, body: body);
    if (apiResponse.status == 200) return true;
    // var emailMessage = 'this_email_already_exist_please_try_with_another_email';
    // var phoneMessage = 'this_phone_number_already_exist_please_try_with_another_phone_number';
    // FlushPopup.onWarning(message: body['field'] == 'phone' ? phoneMessage.recast : emailMessage.recast);
    return false;
  }
}
