import 'package:app/features/address/view_models/add_address_view_model.dart';
import 'package:app/features/address/view_models/seller_settings_view_model.dart';
import 'package:app/features/auth/view_models/otp_view_model.dart';
import 'package:app/features/auth/view_models/set_profile_view_model.dart';
import 'package:app/features/auth/view_models/sign_in_view_model.dart';
import 'package:app/features/challenge/challenge_view_model.dart';
import 'package:app/features/chat/chat_view_model.dart';
import 'package:app/features/club/view_models/club_event_view_model.dart';
import 'package:app/features/club/view_models/club_view_model.dart';
import 'package:app/features/club/view_models/create_club_view_model.dart';
import 'package:app/features/dashboard/view_models/dashboard_view_model.dart';
import 'package:app/features/dashboard/view_models/public_marketplace_view_model.dart';
import 'package:app/features/discs/view_models/add_disc_view_model.dart';
import 'package:app/features/discs/view_models/add_wishlist_view_model.dart';
import 'package:app/features/discs/view_models/ai_disc_suggestion_view_model.dart';
import 'package:app/features/discs/view_models/create_sales_ad_view_model.dart';
import 'package:app/features/discs/view_models/discs_view_model.dart';
import 'package:app/features/discs/view_models/pgda_discs_view_model.dart';
import 'package:app/features/discs/view_models/search_disc_view_model.dart';
import 'package:app/features/friends/view_models/add_friend_view_model.dart';
import 'package:app/features/friends/view_models/friends_view_model.dart';
import 'package:app/features/graph/view_models/flight_path_view_model.dart';
import 'package:app/features/graph/view_models/grid_path_view_model.dart';
import 'package:app/features/home/home_view_model.dart';
import 'package:app/features/landing/landing_view_model.dart';
import 'package:app/features/leaderboard/leaderboard_view_model.dart';
import 'package:app/features/marketplace/view_models/market_details_view_model.dart';
import 'package:app/features/marketplace/view_models/marketplace_view_model.dart';
import 'package:app/features/notification/notifications_view_model.dart';
import 'package:app/features/notify_pref/notify_pref_view_model.dart';
import 'package:app/features/profile/view_models/player_profile_view_model.dart';
import 'package:app/features/profile/view_models/profile_view_model.dart';
import 'package:app/features/profile/view_models/tournament_discs_view_model.dart';
import 'package:app/features/report_problem/report_problem_view_model.dart';
import 'package:app/features/settings/settings_view_model.dart';
import 'package:app/features/suggest_feature/view_models/suggest_feature_view_model.dart';
import 'package:app/features/suggest_feature/view_models/suggestion_details_view_model.dart';
import 'package:app/features/waitlist/waitlist_view_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart' show SingleChildWidget;

List<SingleChildWidget> providers = [
  ..._auth_providers,
  ..._public_providers,
  ..._user_providers,
];

List<SingleChildWidget> _auth_providers = [
  ChangeNotifierProvider(create: (_) => SignInViewModel()),
  ChangeNotifierProvider(create: (_) => OtpViewModel()),
  ChangeNotifierProvider(create: (_) => SetProfileViewModel()),
];

List<SingleChildWidget> _public_providers = [
  ChangeNotifierProvider(create: (_) => DashboardViewModel()),
  ChangeNotifierProvider(create: (_) => PublicMarketplaceViewModel()),
  ChangeNotifierProvider(create: (_) => WaitlistViewModel()),
];

List<SingleChildWidget> _user_providers = [
  ChangeNotifierProvider(create: (_) => LandingViewModel()),
  ChangeNotifierProvider(create: (_) => HomeViewModel()),
  ChangeNotifierProvider(create: (_) => LeaderboardViewModel()),
  ..._club_providers,
  ..._disc_management_providers,
  ..._marketplace_providers,
  ChangeNotifierProvider(create: (_) => FriendsViewModel()),
  ChangeNotifierProvider(create: (_) => AddFriendViewModel()),
  ChangeNotifierProvider(create: (_) => ChatViewModel()),
  ChangeNotifierProvider(create: (_) => ChallengeViewModel()),
  ChangeNotifierProvider(create: (_) => ProfileViewModel()),
  ChangeNotifierProvider(create: (_) => TournamentDiscsViewModel()),
  ChangeNotifierProvider(create: (_) => NotificationsViewModel()),
  ChangeNotifierProvider(create: (_) => SellerSettingsViewModel()),
  ChangeNotifierProvider(create: (_) => AddAddressViewModel()),
  ChangeNotifierProvider(create: (_) => NotificationsViewModel()),
  ChangeNotifierProvider(create: (_) => PlayerProfileViewModel()),
  ..._preferences_providers,
];

List<SingleChildWidget> _club_providers = [
  ChangeNotifierProvider(create: (_) => ClubViewModel()),
  ChangeNotifierProvider(create: (_) => CreateClubViewModel()),
  ChangeNotifierProvider(create: (_) => ClubEventViewModel()),
];

List<SingleChildWidget> _disc_management_providers = [
  ChangeNotifierProvider(create: (_) => DiscsViewModel()),
  ChangeNotifierProvider(create: (_) => SearchDiscViewModel()),
  ChangeNotifierProvider(create: (_) => AddDiscViewModel()),
  ChangeNotifierProvider(create: (_) => CreateSalesAdViewModel()),
  ChangeNotifierProvider(create: (_) => AddWishlistViewModel()),
  ChangeNotifierProvider(create: (_) => AiDiscSuggestionViewModel()),
  ChangeNotifierProvider(create: (_) => PgdaDiscsViewModel()),
  ChangeNotifierProvider(create: (_) => FlightPathViewModel()),
  ChangeNotifierProvider(create: (_) => GridPathViewModel()),
];

List<SingleChildWidget> _marketplace_providers = [
  ChangeNotifierProvider(create: (_) => MarketplaceViewModel()),
  ChangeNotifierProvider(create: (_) => MarketDetailsViewModel()),
];

List<SingleChildWidget> _preferences_providers = [
  ChangeNotifierProvider(create: (_) => SettingsViewModel()),
  ChangeNotifierProvider(create: (_) => NotifyPrefViewModel()),
  ChangeNotifierProvider(create: (_) => ReportProblemViewModel()),
  ChangeNotifierProvider(create: (_) => SuggestFeatureViewModel()),
  ChangeNotifierProvider(create: (_) => SuggestionDetailsViewModel()),
];
