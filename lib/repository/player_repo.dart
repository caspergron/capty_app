import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/interfaces/api_interceptor.dart';
import 'package:app/models/common/tournament.dart';
import 'package:app/models/common/tournament_api.dart';
import 'package:app/models/disc/user_disc_category.dart';
import 'package:app/models/disc/user_disc_category_api.dart';
import 'package:app/models/marketplace/marketplace_api.dart';
import 'package:app/models/marketplace/marketplace_category.dart';
import 'package:app/models/marketplace/sales_ad.dart';
import 'package:app/models/marketplace/sales_ad_api.dart';
import 'package:app/models/user/user.dart';
import 'package:app/utils/api_url.dart';

class PlayerRepository {
  Future<User?> fetchPlayerProfileInfo(int userId) async {
    var endpoint = '${ApiUrl.user.playerProfile}$userId';
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return null;
    return User.fromJson(apiResponse.response['data']['user']);
  }

  Future<List<SalesAd>> fetchSalesAdDiscs(String params) async {
    var endpoint = '${ApiUrl.user.playerSalesAds}$params';
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    var salesAdApi = SalesAdApi.fromJson(apiResponse.response);
    return salesAdApi.salesAdList.haveList ? salesAdApi.salesAdList! : [];
  }

  Future<List<MarketplaceCategory>> fetchAllSalesAdDiscs(String params) async {
    var endpoint = '${ApiUrl.user.playerAllSalesAds}$params';
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    var marketplaceApi = MarketplaceApi.fromJson(apiResponse.response);
    var categories = marketplaceApi.categories ?? [];
    return categories;
  }

  /*Future<List<UserDisc>> fetchPlayerTournamentDiscs(int userId) async {
    var endpoint = '${ApiUrl.user.playerTournamentBag}$userId';
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    var discBag = DiscBag.fromJson(apiResponse.response['data']);
    return discBag.userDiscs ?? [];
  }*/

  Future<List<Tournament>> fetchPlayerTournamentInfo(int userId) async {
    var endpoint = '${ApiUrl.user.playerTournamentInfo}$userId';
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    var tournamentApi = TournamentApi.fromJson(apiResponse.response);
    return tournamentApi.tournaments ?? [];
  }

  Future<List<UserDiscCategory>> fetchTournamentDiscsByCategory({String params = ''}) async {
    var endpoint = '${ApiUrl.user.playerAllTournamentDiscs}$params';
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    var categoryApi = UserDiscCategoryApi.fromJson(apiResponse.response);
    return categoryApi.categories ?? [];
  }
}
