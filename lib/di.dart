import 'package:get_it/get_it.dart';

import 'package:app/helpers/dimension_helper.dart';
import 'package:app/helpers/file_helper.dart';
import 'package:app/helpers/filter_helper.dart';
import 'package:app/helpers/graph_helper.dart';
import 'package:app/helpers/marketplace_helper.dart';
import 'package:app/interfaces/api_interceptor.dart';
import 'package:app/interfaces/http_module.dart';
import 'package:app/libraries/app_clipboard.dart';
import 'package:app/libraries/app_updater.dart';
import 'package:app/libraries/cloud_notification.dart';
import 'package:app/libraries/device_info.dart';
import 'package:app/libraries/file_compressor.dart';
import 'package:app/libraries/flush_popup.dart';
import 'package:app/libraries/formatters.dart';
import 'package:app/libraries/google_analytics.dart';
import 'package:app/libraries/image_croppers.dart';
import 'package:app/libraries/image_pickers.dart';
import 'package:app/libraries/launchers.dart';
import 'package:app/libraries/local_storage.dart';
import 'package:app/libraries/locations.dart';
import 'package:app/libraries/permissions.dart';
import 'package:app/libraries/pusher.dart';
import 'package:app/libraries/share_module.dart';
import 'package:app/libraries/social_login.dart';
import 'package:app/libraries/toasts_popups.dart';
import 'package:app/repository/address_repo.dart';
import 'package:app/repository/auth_repo.dart';
import 'package:app/repository/chat_repository.dart';
import 'package:app/repository/club_repo.dart';
import 'package:app/repository/disc_bag_repo.dart';
import 'package:app/repository/disc_repo.dart';
import 'package:app/repository/event_repo.dart';
import 'package:app/repository/friend_repo.dart';
import 'package:app/repository/google_repo.dart';
import 'package:app/repository/leaderboard_repo.dart';
import 'package:app/repository/marketplace_repo.dart';
import 'package:app/repository/notifiation_repo.dart';
import 'package:app/repository/player_repo.dart';
import 'package:app/repository/pref_repo.dart';
import 'package:app/repository/public_repo.dart';
import 'package:app/repository/user_repo.dart';
import 'package:app/services/app_analytics.dart';
import 'package:app/services/auth_service.dart';
import 'package:app/services/image_service.dart';
import 'package:app/services/routes.dart';
import 'package:app/services/storage_service.dart';
import 'package:app/services/validators.dart';
import 'package:app/utils/reg_exps.dart';
import 'package:app/utils/transitions.dart';

final sl = GetIt.instance;

Future<void> init() async {
  /// Helpers
  sl.registerLazySingleton<DimensionHelper>(DimensionHelper.new);
  sl.registerLazySingleton<FileHelper>(FileHelper.new);
  sl.registerLazySingleton<FilterHelper>(FilterHelper.new);
  sl.registerLazySingleton<GraphHelper>(GraphHelper.new);
  sl.registerLazySingleton<MarketplaceHelper>(MarketplaceHelper.new);

  /// Interceptors
  sl.registerLazySingleton<ApiInterceptor>(HttpModule.new);
  sl.registerLazySingleton<HttpModule>(HttpModule.new);

  /// Libraries
  sl.registerLazySingleton<AppClipboard>(AppClipboard.new);
  sl.registerLazySingleton<AppUpdater>(AppUpdater.new);
  sl.registerLazySingleton<CloudNotification>(CloudNotification.new);
  sl.registerLazySingleton<DeviceInfo>(DeviceInfo.new);
  sl.registerLazySingleton<FileCompressor>(FileCompressor.new);
  sl.registerLazySingleton<FlushPopup>(FlushPopup.new);
  sl.registerLazySingleton<Formatters>(Formatters.new);
  sl.registerLazySingleton<GoogleAnalytics>(GoogleAnalytics.new);
  sl.registerLazySingleton<ImageCroppers>(ImageCroppers.new);
  sl.registerLazySingleton<ImagePickers>(ImagePickers.new);
  sl.registerLazySingleton<Launchers>(Launchers.new);
  sl.registerLazySingleton<LocalStorage>(LocalStorage.new);
  sl.registerLazySingleton<Locations>(Locations.new);
  sl.registerLazySingleton<Permissions>(Permissions.new);
  sl.registerLazySingleton<Pusher>(Pusher.new);
  sl.registerLazySingleton<ShareModule>(ShareModule.new);
  sl.registerLazySingleton<SocialLogin>(SocialLogin.new);
  sl.registerLazySingleton<ToastPopup>(ToastPopup.new);

  /// Repositories
  sl.registerLazySingleton<AddressRepository>(AddressRepository.new);
  sl.registerLazySingleton<AuthRepository>(AuthRepository.new);
  sl.registerLazySingleton<ChatRepository>(ChatRepository.new);
  sl.registerLazySingleton<DiscBagRepository>(DiscBagRepository.new);
  sl.registerLazySingleton<DiscRepository>(DiscRepository.new);
  sl.registerLazySingleton<ClubRepository>(ClubRepository.new);
  sl.registerLazySingleton<EventRepository>(EventRepository.new);
  sl.registerLazySingleton<FriendRepository>(FriendRepository.new);
  sl.registerLazySingleton<GoogleRepository>(GoogleRepository.new);
  sl.registerLazySingleton<LeaderboardRepository>(LeaderboardRepository.new);
  sl.registerLazySingleton<MarketplaceRepository>(MarketplaceRepository.new);
  sl.registerLazySingleton<NotificationRepository>(NotificationRepository.new);
  sl.registerLazySingleton<PlayerRepository>(PlayerRepository.new);
  sl.registerLazySingleton<PreferencesRepository>(PreferencesRepository.new);
  sl.registerLazySingleton<PublicRepository>(PublicRepository.new);
  sl.registerLazySingleton<UserRepository>(UserRepository.new);

  /// Services
  // Always Active Services
  sl.registerFactory(Routes.new);
  // Lazy Services
  sl.registerLazySingleton<AuthService>(AuthService.new);
  sl.registerLazySingleton<AppAnalytics>(AppAnalytics.new);
  sl.registerLazySingleton<ImageService>(ImageService.new);
  sl.registerLazySingleton<StorageService>(StorageService.new);
  sl.registerLazySingleton<Validators>(Validators.new);

  /// Utils
  sl.registerLazySingleton<RegExps>(RegExps.new);
  sl.registerLazySingleton<Transitions>(Transitions.new);
}
