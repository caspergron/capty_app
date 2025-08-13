import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:app_links/app_links.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:app/coach_capty_app.dart';
import 'package:app/constants/app_constants.dart';
import 'package:app/di.dart';
import 'package:app/libraries/cloud_notification.dart';
import 'package:app/libraries/device_info.dart';
import 'package:app/libraries/formatters.dart';
import 'package:app/preferences/user_preferences.dart';
import 'package:app/repository/public_repo.dart';
import 'package:app/screen_craft.dart';
import 'package:app/services/auth_service.dart';
import 'package:app/services/http_overrides.dart';
import 'package:app/services/providers.dart';
import 'package:app/services/storage_service.dart';
import 'package:app/utils/app_utils.dart';
import 'di.dart' as dependency_injection;

/// flutter build appbundle --release
/// flutter build apk --split-per-abi
/// flutter pub run import_sorter:main lib
/// keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
/// keytool -list -v -keystore KEY_STORE_PATH -alias key

// Check unused translations function in report problem view model

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) => Firebase.initializeApp();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SentryWidgetsFlutterBinding.ensureInitialized();
  await dependency_injection.init();
  await _initCoachCaptyApp();
  /*FlutterError.onError = (details) {
    FlutterError.dumpErrorToConsole(details);
    runApp(ErrorApp(details));
  };*/
  await Future.delayed(const Duration(seconds: 2));
  sl<AuthService>().setAppPreferences();
  if (sl<AuthService>().authStatus) sl<AuthService>().setUserPreferences();
  !kReleaseMode ? runApp(_runApp) : await SentryFlutter.init(_sentryOptions, appRunner: () => runApp(_runApp));
  // runApp(MultiProvider(providers: providers, child: _screenCraft()));
  // await SentryFlutter.init(_sentryOptions, appRunner: () => runApp(_runApp));
  // runApp(ErrorApp(FlutterErrorDetails(exception: '')));
}

MultiProvider get _runApp =>
    MultiProvider(providers: providers, child: !kReleaseMode ? _screenCraft : SentryScreenshotWidget(child: _screenCraft));
Widget get _screenCraft => ScreenCraft(builder: (context, orientation) => CoachCaptyApp());

Future<void> _initCoachCaptyApp() async {
  HttpOverrides.global = MyHttpOverrides();
  await GetStorage.init();
  await Firebase.initializeApp();
  await sl<CloudNotification>().initFirebaseNotification();
  Formatters.registerTimeAgoLocales(sl<StorageService>().language.code ?? 'en');
  await initializeDateFormatting(sl<StorageService>().language.code ?? 'en');
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  if (kReleaseMode) await _flutterErrorCatcher();
  await _listenDeepLink();
  await portraitMode();
}

Future<void> _flutterErrorCatcher() async => FlutterError.onError = _flutterCustomError;

Future<void> _flutterCustomError(FlutterErrorDetails flutterErrorDetails, {bool fatal = false}) async {
  FlutterError.presentError(flutterErrorDetails);
  var errorType = flutterErrorDetails.exception.toString();
  var body = {
    'user_id': UserPreferences.user.id,
    'channel': 'Capty App ${kReleaseMode ? 'Release' : 'Debug'} Mode',
    'app_platform': Platform.isIOS ? 'ios' : 'android',
    'device_model': await sl<DeviceInfo>().deviceName,
    'os_version': sl<DeviceInfo>().deviceOsVersion,
    'error_type': errorType.isEmpty ? 'Capty App Error' : errorType,
    'summary': flutterErrorDetails.exceptionAsString(),
    'stack_trace': flutterErrorDetails.stack.toString(),
    'app_version': '${await sl<DeviceInfo>().appVersion} + ${await sl<DeviceInfo>().appBuildVersionCode}',
  };
  await sl<PublicRepository>().storeAppLogError(body);
  return;
}

void _sentryOptions(SentryFlutterOptions options) {
  options.dsn = SENTRY_DSN;
  options.tracesSampleRate = SAMPLE_RATE;
  options.profilesSampleRate = SAMPLE_RATE;
  options.replay.sessionSampleRate = SAMPLE_RATE;
  options.replay.onErrorSampleRate = SAMPLE_RATE;
  options.anrEnabled = true;
  options.attachScreenshot = true;
  options.attachViewHierarchy = true;
}

Future<void> _listenDeepLink() async {
  // await sl<LocalStorage>().removeData(key: DEEPLINK);
  var appLinks = AppLinks();
  var deepLink = await appLinks.getInitialLinkString();
  // if (deepLink != null && deepLink.isNotEmpty) sl<StorageService>().setDeeplink(deepLink);
  // if (deepLink != null && deepLink.isNotEmpty) ToastPopup.onToast(message: deepLink);
  if (deepLink != null && deepLink.isNotEmpty) if (kDebugMode) print(deepLink);
}

// User removed the sales ad AND marked "Sold the disc through Capty"

// 1.0.1 Issues
// It doesn't show you on the leaderboard, even though it shows elsewhere that we're in the same club.
// When I go into your Tactic, it says that we are both playing in Singapore, but that's not correct.

// 1.0.0 Issues
// And I should probably be included in this overview, right?
// Now that we are friends and both in the same club, there must be a mistake in the leaderboard when it can’t display results.
// Done -> When you select ‘Club’ and press the plus button, this comes up – all the text in the search field needs to be corrected.
// The tournament date only shows the last day – can it display like on PDGA?: 15-Aug to 17-Aug-2025
// Done -> Upcoming tournament is not displayed correctly under the marketplace, even though it appears under Profile.
// This screen has a white stripe on the side.
