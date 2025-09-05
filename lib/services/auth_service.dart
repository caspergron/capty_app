import 'package:app/constants/app_keys.dart';
import 'package:app/constants/storage_keys.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/features/address/view_models/seller_settings_view_model.dart';
import 'package:app/features/auth/view_models/set_profile_view_model.dart';
import 'package:app/features/club/view_models/club_view_model.dart';
import 'package:app/features/disc_management/discs/discs_view_model.dart';
import 'package:app/features/home/home_view_model.dart';
import 'package:app/features/leaderboard/leaderboard_view_model.dart';
import 'package:app/features/marketplace_management/marketplace/marketplace_view_model.dart';
import 'package:app/features/notification/notifications_view_model.dart';
import 'package:app/libraries/formatters.dart';
import 'package:app/libraries/local_storage.dart';
import 'package:app/models/user/auth_api.dart';
import 'package:app/preferences/app_preferences.dart';
import 'package:app/preferences/user_preferences.dart';
import 'package:app/services/api_status.dart';
import 'package:app/services/routes.dart';
import 'package:app/services/storage_service.dart';
import 'package:provider/provider.dart';

class AuthService {
  bool get authStatus => sl<StorageService>().accessToken.isNotEmpty;

  void clearMemory() => sl<LocalStorage>().removeAllData();

  void setAppPreferences() {
    AppPreferences.fetchAppVersion;
    AppPreferences.fetchUserAgent;
    AppPreferences.setLanguage(sl<StorageService>().language);
    AppPreferences.setTranslations(sl<StorageService>().translations ?? {});
    AppPreferences.fetchCountries();
    AppPreferences.fetchLanguages();
    Formatters.registerTimeAgoLocales(sl<StorageService>().language.code ?? '');
  }

  void setUserPreferences() {
    var user = sl<StorageService>().user;
    UserPreferences.user = user;
    if (user.currency?.id != null) UserPreferences.currency = user.currency!;
    if (user.currency?.id != null) UserPreferences.currencyCode = user.currency!.code!;
  }

  void setUserInfo(AuthApi authApi, {bool isToken = true}) {
    var user = authApi.user!;
    UserPreferences.user = user;
    sl<StorageService>().setUser(user);
    if (user.currency?.id != null) UserPreferences.currency = user.currency!;
    if (user.currency?.id != null) UserPreferences.currencyCode = user.currency!.code!;
    if (isToken) sl<StorageService>().setAccessToken(authApi.accessToken!);
    if (isToken) sl<StorageService>().setRefreshToken(authApi.refreshToken!);
    // if (isToken) sl<StorageService>().setAuthStatus(true);
  }

  void onLogout() {
    _clearLocalData();
    UserPreferences.clearPreferences();
    ApiStatus.instance.clearStates();
    Routes.public.dashboard().pushAndRemove();
  }

  void _clearLocalData() {
    sl<StorageService>().removeData(key: AUTH_STATUS);
    sl<StorageService>().removeData(key: ACCESS_TOKEN);
    sl<StorageService>().removeData(key: REFRESH_TOKEN);
    sl<StorageService>().removeData(key: USER);
    var context = navigatorKey.currentState?.context;
    if (context == null) return;
    Provider.of<SetProfileViewModel>(context, listen: false).clearStates();
    Provider.of<HomeViewModel>(context, listen: false).clearStates();
    Provider.of<SellerSettingsViewModel>(context, listen: false).clearStates();
    Provider.of<ClubViewModel>(context, listen: false).clearStates();
    Provider.of<LeaderboardViewModel>(context, listen: false).clearStates();
    Provider.of<DiscsViewModel>(context, listen: false).clearStates();
    Provider.of<MarketplaceViewModel>(context, listen: false).clearStates();
    Provider.of<NotificationsViewModel>(context, listen: false).clearStates();
  }
}
