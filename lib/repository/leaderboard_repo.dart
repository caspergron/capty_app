import 'package:app/di.dart';
import 'package:app/interfaces/api_interceptor.dart';
import 'package:app/models/leaderboard/leaderboard.dart';
import 'package:app/models/leaderboard/pdga_user.dart';
import 'package:app/utils/api_url.dart';

class LeaderboardRepository {
  Future<Leaderboard?> fetchClubBasedLeaderboard({String sortKey = ''}) async {
    var endpoint = '${ApiUrl.user.clubLeaderboard}?sort_key=$sortKey';
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return null;
    var leaderboard = Leaderboard.fromJson(apiResponse.response['data']);
    var players = leaderboard.players ?? [];
    return players.isEmpty ? null : _sortLeaderboard(leaderboard);
  }

  Future<Leaderboard?> fetchFriendBasedLeaderboard({String sortKey = ''}) async {
    var endpoint = '${ApiUrl.user.friendLeaderboard}?sort_key=$sortKey';
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return null;
    var leaderboard = Leaderboard.fromJson(apiResponse.response['data']);
    var players = leaderboard.players ?? [];
    return players.isEmpty ? null : _sortLeaderboard(leaderboard);
  }

  Leaderboard _sortLeaderboard(Leaderboard leaderboard) {
    var players = leaderboard.players!;
    var top3 = List.generate(3, (index) => index < players.length ? players[index] : PdgaUser());
    var topPlayers = [top3[1], top3[0], top3[2]];
    var otherPlayers = players.length > 3 ? players.skip(3).toList() : <PdgaUser>[];
    return Leaderboard(clubName: leaderboard.clubName, players: players, topPlayers: topPlayers, otherPlayers: otherPlayers);
  }
}
