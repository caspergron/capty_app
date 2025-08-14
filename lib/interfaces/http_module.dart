import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:app/di.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/interfaces/api_interceptor.dart';
import 'package:app/libraries/toasts_popups.dart';
import 'package:app/models/system/api_response.dart';
import 'package:app/preferences/app_preferences.dart';
import 'package:app/services/auth_service.dart';
import 'package:app/services/storage_service.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:sentry_flutter/sentry_flutter.dart';

const _200 = 200;
const _300 = 300;
const _400 = 400;
const _500 = 500;
const _TIMEOUT_DURATION = Duration(seconds: 20);

class HttpModule implements ApiInterceptor {
  @override
  Future<ApiResponse> getRequest({required String endpoint}) async {
    HttpClient client = HttpClient();
    if (kDebugMode) print('get: $endpoint');
    try {
      var uri = Uri.parse(endpoint);
      http.Response response = await http.get(uri, headers: await httpHeaders).timeout(_TIMEOUT_DURATION);
      return _returnResponse(response);
    } on SocketException catch (error, stackTrace) {
      unawaited(_sentryException(error, stackTrace));
      client.close();
      ToastPopup.onWarning(message: 'no_internet_connection_please_check_your_network'.recast);
      return _exceptionResponse(error.toString(), endpoint);
    } on TimeoutException catch (error, stackTrace) {
      unawaited(_sentryException(error, stackTrace));
      client.close();
      // ToastPopup.onWarning(message: 'request_timed_out_please_check_your_internet_connection'.recast);
      return _exceptionResponse(error.toString(), endpoint);
    } on http.ClientException catch (error, stackTrace) {
      unawaited(_sentryException(error, stackTrace));
      client.close();
      return _exceptionResponse(error.toString(), endpoint);
    } catch (error, stackTrace) {
      unawaited(_sentryException(error, stackTrace));
      client.close();
      return _exceptionResponse(error.toString(), endpoint);
    }
  }

  @override
  Future<ApiResponse> postRequest({required String endpoint, Map<String, dynamic>? body}) async {
    HttpClient client = HttpClient();
    if (kDebugMode) print('post: $endpoint');
    try {
      var uri = Uri.parse(endpoint);
      var encodedBody = body == null ? null : json.encode(body);
      http.Response response = await http.post(uri, body: encodedBody, headers: await httpHeaders).timeout(_TIMEOUT_DURATION);
      return _returnResponse(response);
    } on SocketException catch (error, stackTrace) {
      unawaited(_sentryException(error, stackTrace));
      client.close();
      ToastPopup.onWarning(message: 'no_internet_connection_please_check_your_network'.recast);
      return _exceptionResponse(error.toString(), endpoint);
    } on TimeoutException catch (error, stackTrace) {
      unawaited(_sentryException(error, stackTrace));
      client.close();
      // ToastPopup.onWarning(message: 'request_timed_out_please_check_your_internet_connection'.recast);
      return _exceptionResponse(error.toString(), endpoint);
    } on http.ClientException catch (error, stackTrace) {
      unawaited(_sentryException(error, stackTrace));
      client.close();
      return _exceptionResponse(error.toString(), endpoint);
    } catch (error, stackTrace) {
      unawaited(_sentryException(error, stackTrace));
      client.close();
      return _exceptionResponse(error.toString(), endpoint);
    }
  }

  @override
  Future<ApiResponse> putRequest({required String endpoint, Map<String, dynamic>? body}) async {
    HttpClient client = HttpClient();
    if (kDebugMode) print('put: $endpoint');
    if (kDebugMode) log('body: ${body == null ? 'null' : body.toString()}');
    try {
      var uri = Uri.parse(endpoint);
      var encodedBody = body == null ? null : json.encode(body);
      http.Response response = await http.put(uri, body: encodedBody, headers: await httpHeaders).timeout(_TIMEOUT_DURATION);
      return _returnResponse(response);
    } on SocketException catch (error, stackTrace) {
      unawaited(_sentryException(error, stackTrace));
      client.close();
      ToastPopup.onWarning(message: 'no_internet_connection_please_check_your_network'.recast);
      return _exceptionResponse(error.toString(), endpoint);
    } on TimeoutException catch (error, stackTrace) {
      unawaited(_sentryException(error, stackTrace));
      client.close();
      // ToastPopup.onWarning(message: 'request_timed_out_please_check_your_internet_connection'.recast);
      return _exceptionResponse(error.toString(), endpoint);
    } on http.ClientException catch (error, stackTrace) {
      unawaited(_sentryException(error, stackTrace));
      client.close();
      return _exceptionResponse(error.toString(), endpoint);
    } catch (error, stackTrace) {
      unawaited(_sentryException(error, stackTrace));
      client.close();
      return _exceptionResponse(error.toString(), endpoint);
    }
  }

  @override
  Future<ApiResponse> deleteRequest({required String endpoint, Map<String, dynamic>? body}) async {
    HttpClient client = HttpClient();
    if (kDebugMode) print('delete: $endpoint');
    if (kDebugMode) log('body: ${body == null ? 'null' : body.toString()}');
    try {
      var uri = Uri.parse(endpoint);
      var encodedBody = body == null ? null : json.encode(body);
      http.Response response = await http.delete(uri, body: encodedBody, headers: await httpHeaders).timeout(_TIMEOUT_DURATION);
      return _returnResponse(response);
    } on SocketException catch (error, stackTrace) {
      unawaited(_sentryException(error, stackTrace));
      client.close();
      ToastPopup.onWarning(message: 'no_internet_connection_please_check_your_network'.recast);
      return _exceptionResponse(error.toString(), endpoint);
    } on TimeoutException catch (error, stackTrace) {
      unawaited(_sentryException(error, stackTrace));
      client.close();
      // ToastPopup.onWarning(message: 'request_timed_out_please_check_your_internet_connection'.recast);
      return _exceptionResponse(error.toString(), endpoint);
    } on http.ClientException catch (error, stackTrace) {
      unawaited(_sentryException(error, stackTrace));
      client.close();
      return _exceptionResponse(error.toString(), endpoint);
    } catch (error, stackTrace) {
      unawaited(_sentryException(error, stackTrace));
      client.close();
      return _exceptionResponse(error.toString(), endpoint);
    }
  }

  @override
  Future<ApiResponse> patchRequest({required String endpoint, Map<String, dynamic>? body}) async {
    HttpClient client = HttpClient();
    if (kDebugMode) print('post: $endpoint');
    if (kDebugMode) log('body: ${body == null ? 'null' : body.toString()}');
    try {
      var uri = Uri.parse(endpoint);
      var encodedBody = body == null ? null : json.encode(body);
      http.Response response = await http.patch(uri, body: encodedBody, headers: await httpHeaders).timeout(_TIMEOUT_DURATION);
      return _returnResponse(response);
    } on SocketException catch (error, stackTrace) {
      unawaited(_sentryException(error, stackTrace));
      client.close();
      ToastPopup.onWarning(message: 'no_internet_connection_please_check_your_network'.recast);
      return _exceptionResponse(error.toString(), endpoint);
    } on TimeoutException catch (error, stackTrace) {
      unawaited(_sentryException(error, stackTrace));
      client.close();
      // ToastPopup.onWarning(message: 'request_timed_out_please_check_your_internet_connection'.recast);
      return _exceptionResponse(error.toString(), endpoint);
    } on http.ClientException catch (error, stackTrace) {
      unawaited(_sentryException(error, stackTrace));
      client.close();
      return _exceptionResponse(error.toString(), endpoint);
    } catch (error, stackTrace) {
      unawaited(_sentryException(error, stackTrace));
      client.close();
      return _exceptionResponse(error.toString(), endpoint);
    }
  }

  @override
  Future<ApiResponse> multipartRequest({required http.MultipartRequest request}) async {
    HttpClient client = HttpClient();
    try {
      http.StreamedResponse response = await request.send().timeout(_TIMEOUT_DURATION);
      var responseResult = await response.stream.bytesToString();
      var returnResponse = http.Response(responseResult, response.statusCode, headers: response.headers, request: response.request);
      return _returnResponse(returnResponse);
    } catch (error) {
      if (kDebugMode) print('ERROR::::::$error::::::${request.url.path}');
      client.close();
      return ApiResponse(status: _500, response: null);
    }
  }

  Future<void> _sentryException(Object error, stackTrace) async => Sentry.captureException(error, stackTrace: stackTrace);

  ApiResponse _exceptionResponse(String error, String endpoint) {
    if (kDebugMode) print('ERROR::::::$error::::::$endpoint');
    return ApiResponse(status: 500, response: null);
  }

  ApiResponse _returnResponse(http.Response response) {
    int statusCode = response.statusCode;
    // if (kDebugMode) print('status-code: $statusCode ::: endpoint: ${response.request?.url}');
    log('status-code: $statusCode ::: endpoint: ${response.request?.url}\nresponse-body: ${response.body.toString()}');
    // if (kDebugMode) print('status-code: $statusCode ::: endpoint: ${response.request?.url}\nresponse-body: ${response.body}');
    var jsonResponse = response.bodyBytes.isEmpty || response.bodyBytes is String ? null : json.decode(utf8.decode(response.bodyBytes));
    if (statusCode >= 200 && statusCode <= 299) {
      return ApiResponse(status: jsonResponse['success'] ? _200 : _300, response: jsonResponse);
    } else if (statusCode >= 500 && statusCode <= 599) {
      return ApiResponse(status: _500, response: {});
    } else if (statusCode == 401) {
      if (sl<AuthService>().authStatus) sl<AuthService>().onLogout();
      return ApiResponse(status: _400, response: jsonResponse);
    } else if (statusCode == 404) {
      return ApiResponse(status: _300, response: jsonResponse);
    } else if (statusCode == 422) {
      return ApiResponse(status: _300, response: jsonResponse);
    } else {
      return ApiResponse(status: _300, response: jsonResponse);
    }
  }

  Future<Map<String, String>> get httpHeaders async {
    var accessToken = sl<StorageService>().accessToken;
    Map<String, String> headers = <String, String>{};
    headers['Accept'] = 'application/json';
    headers['Content-Type'] = 'application/json';
    headers['User-Agent'] = await AppPreferences.fetchUserAgent;
    if (accessToken.isNotEmpty) headers['Authorization'] = 'Bearer $accessToken';
    return headers;
  }
}
