import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/interfaces/api_interceptor.dart';
import 'package:app/models/common/tournament.dart';
import 'package:app/models/common/tournament_api.dart';
import 'package:app/models/disc/user_disc.dart';
import 'package:app/models/disc_bag/disc_bag.dart';
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
    var endpoint = '${ApiUrl.user.playerSalesAd}$params';
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    var salesAdApi = SalesAdApi.fromJson(apiResponse.response);
    return salesAdApi.salesAdList.haveList ? salesAdApi.salesAdList! : [];
  }

  Future<List<Tournament>> fetchPlayerTournamentInfo(int userId) async {
    var endpoint = '${ApiUrl.user.playerTournamentInfo}$userId';
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    var tournamentApi = TournamentApi.fromJson(apiResponse.response);
    return tournamentApi.tournaments ?? [];
  }

  Future<List<UserDisc>> fetchPlayerTournamentDiscs(int userId) async {
    var endpoint = '${ApiUrl.user.playerTournamentBag}$userId';
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    var discBag = DiscBag.fromJson(apiResponse.response['data']);
    return discBag.userDiscs ?? [];
  }
}
