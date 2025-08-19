import 'package:app/constants/app_constants.dart';
import 'package:app/constants/data_constants.dart';

const String _SERVER = 'https://api.capty.com/api/v1';
// const String _SERVER = 'https://apitest.capty.com/api/v1';

const String GOOGLE_API = 'https://maps.googleapis.com/maps/api/geocode/json?key=$GOOGLE_MAP_API_KEY';
const String GOOGLE_API_AUTOCOMPLETE = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?key=$GOOGLE_MAP_API_KEY';

class ApiUrl {
  static _PublicApis public = _PublicApis();
  static _AuthApis auth = _AuthApis();
  static _UserApis user = _UserApis();
  static _PreferencesApis pref = _PreferencesApis();
}

class _PublicApis {
  String countries = '$_SERVER/country/list';
  String currencies = '$_SERVER/currency/list';
  String languages = '$_SERVER/language/list';
  String translations = '$_SERVER/language/get-translation?language_code='; // en

  String allBrands = '$_SERVER/disc-brand/list-priority';

  String appStatistics = '$_SERVER/statistics';
  String marketplaceDiscsByCountry = '$_SERVER/market-place-disc-no-auth/list?size=15'; // &country_id=6&page=1&longitude=56.3&latitude=10.7

  String findClub = '$_SERVER/club/find-club'; // ?latitude=40.7300&longitude=-73.97700
  String addInWaitlist = '$_SERVER/user/wait_lists';
  String logError = '$_SERVER/send-app-error';
}

class _AuthApis {
  String checkUnique = '$_SERVER/check-unique';
  String sendOtp = '$_SERVER/auth/send-otp';
  String verifyOtp = '$_SERVER/auth/verify-otp';
  String checkSocialLogin = '$_SERVER/auth/social-login';
  String createAccount = '$_SERVER/auth/sign-up';
  String refreshToken = '$_SERVER/auth/refresh-token';
}

class _UserApis {
  String profile = '$_SERVER/user/profile';
  String updateProfile = '$_SERVER/user/update-profile';
  String dashboardCount = '$_SERVER/user/dashboard/count';
  String tournamentDisc = '$_SERVER/user/bag/tournament-bag';
  String tournamentInfo = '$_SERVER/user/tournament-info';

  String signOut = '$_SERVER/user/logout';
  String deleteAccount = '$_SERVER/user/delete-account';

  String createClub = '$_SERVER/club/create';
  String createClubCourse = '$_SERVER/admin/club-course/create';
  String userClubs = '$_SERVER/club/user-club';
  String clubDetails = '$_SERVER/club/show'; // /1
  String searchClubs = '$_SERVER/club/search?size=20&page='; // 1
  String joinClub = '$_SERVER/club/join';
  String leaveClub = '$_SERVER/club/leave';
  String findClubCourses = '$_SERVER/club/find-club-course'; // ?latitude=48.8566&longitude=2.3522
  String defaultClubInfo = '$_SERVER/user/club';
  String salesDiscByClub = '$_SERVER/market-place-disc/get-by-club?size=20'; // &club_id=3&page=1
  String changeToDefault = '$_SERVER/user/club/change-default'; // &club_id=3&page=1
  String clubMembers = '$_SERVER/user/club-member/list?club_id='; // &club_id=3&page=1

  String createClubEvent = '$_SERVER/club-event/create';
  String findEvents = '$_SERVER/club-event/find-event'; // ?latitude=48.8566&longitude=2.3522
  String eventDetails = '$_SERVER/club-event/show'; // /1
  String joinEvent = '$_SERVER/club-event/join';

  String addEventComment = '$_SERVER/club-event-comment/create';
  String eventComments = '$_SERVER/club-event-comment/list?club_event_id='; // 1

  String discList = '$_SERVER/disc/list?size=$COMMON_LENGTH_20'; // ?size=100&page=10
  String discListByCategory = '$_SERVER/disc/list-by-type?size=$COMMON_LENGTH_10&page='; // 1
  String discDetails = '$_SERVER/disc/show?disc_id=';
  String searchDiscs = '$_SERVER/disc/search';

  String createUserDisc = '$_SERVER/user/disc/create';
  String UserDiscList = '$_SERVER/user/disc/list?size=20&page=';
  String UserDiscDetails = '$_SERVER/user/disc/show?user_disc_id='; // 1
  String updateUserDisc = '$_SERVER/user/disc/update?user_disc_id='; // 1
  String deleteUserDisc = '$_SERVER/user/disc/delete?user_disc_id='; // 1
  String requestDisc = '$_SERVER/user/disc-request/create';

  String plasticByDiscId = '$_SERVER/disc-plastic/get-by-disc-brand?disc_brand_id='; // 1

  String createBag = '$_SERVER/user/bag/create';
  String bagList = '$_SERVER/user/bag/list?size=20&page='; // 1
  String bagDetails = '$_SERVER/user/bag/show?bag_id='; // 1
  String updateBag = '$_SERVER/user/bag/update?bag_id='; // 1
  String moveDisc = '$_SERVER/user/bag/move-disc';
  String deleteDiscBag = '$_SERVER/user/bag/delete?bag_id='; // 2

  String createWishlist = '$_SERVER/user/wish-list/create';
  String wishlistDiscs = '$_SERVER/user/wish-list/list';
  String wishlistDiscDetails = '$_SERVER/user/wish-list/show?wish_list_id='; // 1
  String removeWishlist = '$_SERVER/user/wish-list/delete?wish_list_id='; // 1
  String updateWishlistDisc = '$_SERVER/user/disc/update/wish-list';

  String salesAdTypes = '$_SERVER/sales-ads-type/list';
  String createSalesAd = '$_SERVER/user/sales-ads/create';
  String salesAdDetails = '$_SERVER/user/sales-ads/show?sales_ad_id='; // 1
  String salesAdList = '$_SERVER/user/sales-ads/list?size=20'; // 1
  String updateSalesAd = '$_SERVER/user/sales-ads/update?sales_ad_id='; // 2
  String deleteSalesAd = '$_SERVER/user/sales-ads/delete?sales_ad_id='; // 2
  String shareSalesAd = '$_SERVER/user/shareable-disc-link';

  String tagList = '$_SERVER/tags/list'; // 2
  String marketplaceList = '$_SERVER/market-place-disc/list'; // 2
  String searchMarketplace = '$_SERVER/market-place-disc/search?search='; // 2
  String marketplaceDetails = '$_SERVER/market-place-disc/show?sales_ad_id='; // 2
  String marketplacesByUser = '$_SERVER/market-place-disc/get-all-user-sale-ads?user_id='; // 2
  String clubTournamentInfo = '$_SERVER/user/club-tournament-info';
  String matchedInfoWithSeller = '$_SERVER/user/match/info?match_with='; // 4
  String popularityCount = '$_SERVER/market-place-disc/popularity_count';

  String marketplaceFavouriteList = '$_SERVER/user/favorite-sales-ads/list?size=$COMMON_LENGTH_20&page='; // 1
  String setMarketplaceDiscAsFavourite = '$_SERVER/user/favorite-sales-ads/store';
  String RemoveMarketplaceDiscFromFavourite = '$_SERVER/user/favorite-sales-ads/delete?sales_ad_id='; // 1

  String createAddress = '$_SERVER/user/address/create';
  String addressList = '$_SERVER/user/address/list';
  String updateAddress = '$_SERVER/user/address/update?address_id='; // 1
  String deleteAddress = '$_SERVER/user/address/delete?address_id='; // 1

  String shippingInfo = '$_SERVER/user/shipping-info?user_id='; // 1
  String updateShippingInfo = '$_SERVER/user/update-shipping-info';

  String uploadMultipartMedia = '$_SERVER/media/upload';
  String uploadBase64Media = '$_SERVER/media/upload-base64';
  String deleteMedia = '$_SERVER/media/delete';

  String friendList = '$_SERVER/user/friend/list?size=20&page='; // 1
  String searchUserForFriend = '$_SERVER/user/friend/find-user?query=';
  String sentRequestForFriend = '$_SERVER/user/friend/send-request';
  String acceptFriendRequest = '$_SERVER/user/friend/accept-request?friend_id='; // 1
  String rejectFriendRequest = '$_SERVER/user/friend/reject-request?friend_id='; // 1
  String friendRequestList = '$_SERVER/user/friend/request-list';

  String friendLeaderboard = '$_SERVER/user/pdga-rating/friend-list';
  String clubLeaderboard = '$_SERVER/user/pdga-rating/club-list';

  String notifications = '$_SERVER/user/notification/list?size=$COMMON_LENGTH_20';
  String readNotification = '$_SERVER/user/notification/update?notification_id=';

  String setOnlineStatus = '$_SERVER/user/update/online-status';
  String checkOnlineStatus = '$_SERVER/user/check/online-status?user_id='; // 1
  String isExistDiscInChat = '$_SERVER/sales-ads-conversation/is-exists';
  String storeDiscInConversation = '$_SERVER/sales-ads-conversation/create';
  String messages = '$_SERVER/user/messages';
  String sendMessage = '$_SERVER/user/messages/send';
  String chats = '$_SERVER/user/messages/chats';
  String searchInChat = '$_SERVER/user/messages/chats/search'; // ?keyword=test
  String conversations = '$_SERVER/user/messages/chats/conversation'; // ?user_id=15
  String deleteConversation = '$_SERVER/user/messages/chats/delete'; // ?user_id=15

  String playerProfile = '$_SERVER/player/profile?user_id='; // 15
  String playerSalesAd = '$_SERVER/player/sales-ads?user_id='; // 15
  String playerTournamentBag = '$_SERVER/player/tournament-bag?user_id='; // 15
  String playerTournamentInfo = '$_SERVER/player/tournament-info?user_id='; // 15
}

class _PreferencesApis {
  String userPreferences = '$_SERVER/user-preferences/show';
  String updatePreference = '$_SERVER/user-preferences/update'; // / 1

  String suggestedFeaturesList = '$_SERVER/user/suggested_features/show-all';
  String createSuggestedFeature = '$_SERVER/user/suggested_features/store';
  String voteOnAFeature = '$_SERVER/user/suggested_features/vote';
  String featureDetails = '$_SERVER/user/suggested_features/show?feature_id='; // 1
  String postFeatureComment = '$_SERVER/user/suggested_features/suggested_feature_comments/store';

  String reportProblem = '$_SERVER/user/report_problems/store';
}
