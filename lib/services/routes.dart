import 'package:flutter/material.dart';

import 'package:app/features/address/screens/add_address_screen.dart';
import 'package:app/features/address/screens/seller_settings_screen.dart';
import 'package:app/features/auth/screens/otp_screen.dart';
import 'package:app/features/auth/screens/set_profile_screen_1.dart';
import 'package:app/features/auth/screens/set_profile_screen_2.dart';
import 'package:app/features/auth/screens/set_profile_screen_3.dart';
import 'package:app/features/auth/screens/set_profile_screen_4.dart';
import 'package:app/features/auth/screens/sign_in_screen.dart';
import 'package:app/features/auth/screens/signed_up_screen.dart';
import 'package:app/features/buddies/buddies_screen.dart';
import 'package:app/features/chat/chat_screen.dart';
import 'package:app/features/club/screens/club_event_screen.dart';
import 'package:app/features/club/screens/club_screen.dart';
import 'package:app/features/club/screens/club_settings_screen.dart';
import 'package:app/features/club/screens/create_club_screen.dart';
import 'package:app/features/dashboard/screens/dashboard_screen.dart';
import 'package:app/features/dashboard/screens/public_marketplace_screen.dart';
import 'package:app/features/disc_management/add_disc/add_disc_screen.dart';
import 'package:app/features/disc_management/add_wishlist/screens/add_wishlist_screen.dart';
import 'package:app/features/disc_management/add_wishlist/screens/pgda_discs_screen.dart';
import 'package:app/features/disc_management/ai_suggestion/ai_disc_suggestion_screen.dart';
import 'package:app/features/disc_management/ai_suggestion/recommended_disc_screen.dart';
import 'package:app/features/disc_management/created_disc/created_disc_screen.dart';
import 'package:app/features/disc_management/request_disc/request_disc_screen.dart';
import 'package:app/features/disc_management/search_disc/search_disc_screen.dart';
import 'package:app/features/friends/screens/add_friend_screen.dart';
import 'package:app/features/friends/screens/friends_screen.dart';
import 'package:app/features/graph/screens/flight_path_screen.dart';
import 'package:app/features/graph/screens/grid_path_screen.dart';
import 'package:app/features/intro/introduction_screen.dart';
import 'package:app/features/landing/landing_screen.dart';
import 'package:app/features/leaderboard/leaderboard_screen.dart';
import 'package:app/features/marketplace_management/create_sales_ad/create_sales_ad_screen.dart';
import 'package:app/features/marketplace_management/marketplace_details/market_details_screen.dart';
import 'package:app/features/notification/notifications_screen.dart';
import 'package:app/features/notify_pref/notify_pref_screen.dart';
import 'package:app/features/player/screens/player_profile_screen.dart';
import 'package:app/features/player/screens/player_sales_ad_screen.dart';
import 'package:app/features/player/screens/tournament_bag_screen.dart';
import 'package:app/features/profile/profile_screen.dart';
import 'package:app/features/report_problem/report_problem_screen.dart';
import 'package:app/features/settings/settings_screen.dart';
import 'package:app/features/suggest_feature/screens/suggest_feature_screen.dart';
import 'package:app/features/suggest_feature/screens/suggestion_details_screen.dart';
import 'package:app/features/system/faq_screen.dart';
import 'package:app/features/system/privacy_policy_screen.dart';
import 'package:app/features/system/terms_conditions_screen.dart';
import 'package:app/features/system/webview_screen.dart';
import 'package:app/features/waitlist/waitlist_screen.dart';
import 'package:app/models/address/address.dart';
import 'package:app/models/chat/chat_buddy.dart';
import 'package:app/models/club/club.dart';
import 'package:app/models/club/event.dart';
import 'package:app/models/disc/parent_disc.dart';
import 'package:app/models/disc/user_disc.dart';
import 'package:app/models/disc_bag/disc_bag.dart';
import 'package:app/models/feature/feature.dart';
import 'package:app/models/marketplace/sales_ad.dart';
import 'package:app/models/public/country.dart';
import 'package:app/models/settings/settings.dart';
import 'package:app/models/user/user.dart';

class Routes {
  static _AuthRoutes auth = _AuthRoutes();
  static _PublicRoutes public = _PublicRoutes();
  static _UserRoutes user = _UserRoutes();
  static _SystemRoutes system = _SystemRoutes();
}

class _AuthRoutes {
  Widget introduction() => IntroductionScreen();

  Widget sign_in() => SignInScreen();
  Widget otp_screen({required Map<String, dynamic> data}) => OtpScreen(data: data);
  Widget set_profile_1({required Map<String, dynamic> data}) => SetProfileScreen1(data: data);
  Widget set_profile_2({required Map<String, dynamic> data}) => SetProfileScreen2(data: data);
  Widget set_profile_3({required Map<String, dynamic> data}) => SetProfileScreen3(data: data);
  Widget set_profile_4({required Map<String, dynamic> data}) => SetProfileScreen4(data: data);
  Widget signed_up({required User user}) => SignedUpScreen(user: user);
}

class _PublicRoutes {
  Widget dashboard() => DashboardScreen();
  Widget public_marketplace({required Country country}) => PublicMarketplaceScreen(country: country);
  Widget waitlist() => WaitlistScreen();
}

class _UserRoutes {
  Widget landing({int index = 0}) => LandingScreen(index: index);
  Widget leaderboard() => LeaderboardScreen();

  Widget create_club() => CreateClubScreen();
  Widget club({required Club club, bool isHome = false}) => ClubScreen(club: club, isHome: isHome);
  Widget club_settings({required Club club}) => ClubSettingsScreen(club: club);
  Widget club_event({required Event event}) => ClubEventScreen(event: event);

  Widget profile() => ProfileScreen();
  Widget notification() => NotificationsScreen();
  Widget seller_settings({bool isSelectable = false}) => SellerSettingsScreen(isSelectable: isSelectable);
  Widget add_address({required Address address}) => AddAddressScreen(address: address);

  Widget search_disc({required int index}) => SearchDiscScreen(index: index);
  Widget add_disc({required ParentDisc disc}) => AddDiscScreen(disc: disc);
  Widget create_sales_ad({required UserDisc disc, int tabIndex = 0}) => CreateSalesAdScreen(tabIndex: tabIndex, userDisc: disc);
  Widget created_disc({required UserDisc disc, bool isDisc = false}) => CreatedDiscScreen(disc: disc, isDisc: isDisc);
  Widget request_disc() => RequestDiscScreen();

  Widget add_wishlist() => AddWishlistScreen();
  Widget pgda_discs() => PgdaDiscsScreen();
  Widget ai_disc_suggestion() => AiDiscSuggestionScreen();
  Widget recommended_disc({required String disc}) => RecommendedDiscScreen(disc: disc);

  Widget market_details({required SalesAd salesAd, bool isDelay = false}) => MarketDetailsScreen(salesAd: salesAd, isDelay: isDelay);

  Widget chat({required ChatBuddy buddy}) => ChatScreen(buddy: buddy);
  Widget buddies() => BuddiesScreen();

  Widget settings() => SettingsScreen();
  Widget notify_pref({required Settings settings}) => NotifyPrefScreen(settings: settings);
  Widget report_problem() => ReportProblemScreen();
  Widget suggest_feature() => SuggestFeatureScreen();
  Widget suggestion_details({required Feature feature}) => SuggestionDetailsScreen(feature: feature);

  Widget friends({bool isHome = false, int index = 0}) => FriendsScreen(isHome: isHome, index: index);
  Widget add_friend() => AddFriendScreen();

  Widget player_profile({required int playerId}) => PlayerProfileScreen(playerId: playerId);
  Widget tournament_discs({required User player}) => TournamentBagScreen(player: player);
  Widget player_sale_ads({required User player}) => PlayerSalesAdScreen(player: player);

  Widget grid_path({required List<DiscBag> bags, int index = 0}) => GridPathScreen(bags: bags, index: index);
  Widget flight_path({required List<UserDisc> discs}) => FlightPathScreen(discs: discs);
}

class _SystemRoutes {
  Widget privacy_policy() => PrivacyPolicyScreen();
  Widget faq() => FaqScreen();
  Widget terms_conditions() => TermsConditionsScreen();
  Widget webview({required String title, required String url}) => WebViewScreen(title: title, url: url);
}
