import 'package:flutter/material.dart';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:app/constants/app_constants.dart';
import 'package:app/constants/app_keys.dart';
import 'package:app/constants/data_constants.dart';
import 'package:app/di.dart';
import 'package:app/features/dashboard/screens/dashboard_screen.dart';
import 'package:app/features/intro/introduction_screen.dart';
import 'package:app/features/landing/landing_screen.dart';
import 'package:app/preferences/app_preferences.dart';
import 'package:app/services/auth_service.dart';
import 'package:app/services/lifecycle_observer.dart';
import 'package:app/services/storage_service.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/light_theme.dart';

class CoachCaptyApp extends StatefulWidget {
  @override
  State<CoachCaptyApp> createState() => _CoachCaptyAppState();
}

class _CoachCaptyAppState extends State<CoachCaptyApp> {
  final _observer = LifecycleObserver();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addObserver(_observer);
    return MaterialApp(
      color: primary,
      title: APP_NAME,
      theme: LIGHT_THEME,
      home: _initial_screen,
      navigatorKey: navigatorKey,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      locale: Locale(AppPreferences.language.code ?? 'en'),
      scaffoldMessengerKey: scaffoldMessengerKey,
      supportedLocales: SUPPORTED_LOCALES,
      navigatorObservers: [FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance)],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
    );
  }

  Widget get _initial_screen {
    // return const LandingScreen(index: 0);
    if (!sl<StorageService>().onboardStatus) return IntroductionScreen();
    return sl<AuthService>().authStatus ? LandingScreen(index: 0, key: LandingScreen.landingKey) : DashboardScreen();
  }
}
