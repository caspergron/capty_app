import 'package:app/di.dart';
import 'package:app/interfaces/api_interceptor.dart';
import 'package:app/models/leaderboard/leaderboard.dart';
import 'package:app/models/leaderboard/pdga_user.dart';
import 'package:app/utils/api_url.dart';

class LeaderboardRepository {
  Future<Leaderboard?> fetchClubBasedLeaderboard({String sortKey = ''}) async {
    final endpoint = '${ApiUrl.user.clubLeaderboard}?sort_key=$sortKey';
    final apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return null;
    final leaderboard = Leaderboard.fromJson(apiResponse.response['data']);
    final players = leaderboard.players ?? [];
    return players.isEmpty ? null : _sortLeaderboard(leaderboard);
  }

  Future<Leaderboard?> fetchFriendBasedLeaderboard({String sortKey = ''}) async {
    final endpoint = '${ApiUrl.user.friendLeaderboard}?sort_key=$sortKey';
    final apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return null;
    final leaderboard = Leaderboard.fromJson(apiResponse.response['data']);
    final players = leaderboard.players ?? [];
    return players.isEmpty ? null : _sortLeaderboard(leaderboard);
  }

  Leaderboard _sortLeaderboard(Leaderboard leaderboard) {
    final players = leaderboard.players!;
    final top3 = List.generate(3, (index) => index < players.length ? players[index] : PdgaUser());
    final topPlayers = [top3[1], top3[0], top3[2]];
    final otherPlayers = players.length > 3 ? players.skip(3).toList() : <PdgaUser>[];
    return Leaderboard(clubName: leaderboard.clubName, players: players, topPlayers: topPlayers, otherPlayers: otherPlayers);
  }
}
