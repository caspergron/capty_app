import 'package:app/di.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/interfaces/api_interceptor.dart';
import 'package:app/models/leaderboard/leaderboard.dart';
import 'package:app/models/leaderboard/pdga_user.dart';
import 'package:app/utils/api_url.dart';

class LeaderboardRepository {
  Future<Leaderboard?> fetchClubBasedLeaderboard() async {
    var endpoint = ApiUrl.user.clubLeaderboard;
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return null;
    var leaderboard = Leaderboard.fromJson(apiResponse.response['data']);
    var players = leaderboard.players ?? [];
    if (players.isEmpty) return null;
    players.sort((a, b) => b.pdgaRating.nullToInt.compareTo(a.pdgaRating.nullToInt));
    var top3 = List.generate(3, (index) => index < players.length ? players[index] : PdgaUser());
    var topPlayers = [top3[1], top3[0], top3[2]];
    var otherPlayers = players.length > 3 ? players.skip(3).toList() : <PdgaUser>[];
    return Leaderboard(clubName: leaderboard.clubName, players: players, topPlayers: topPlayers, otherPlayers: otherPlayers);
  }

  Future<Leaderboard?> fetchFriendBasedLeaderboard() async {
    var endpoint = ApiUrl.user.friendLeaderboard;
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return null;
    var leaderboard = Leaderboard.fromJson(apiResponse.response['data']);
    var players = leaderboard.players ?? [];
    if (players.isEmpty) return null;
    players.sort((a, b) => b.pdgaRating.nullToInt.compareTo(a.pdgaRating.nullToInt));
    var top3 = List.generate(3, (index) => index < players.length ? players[index] : PdgaUser());
    var topPlayers = [top3[1], top3[0], top3[2]];
    var otherPlayers = players.length > 3 ? players.skip(3).toList() : <PdgaUser>[];
    return Leaderboard(clubName: leaderboard.clubName, players: players, topPlayers: topPlayers, otherPlayers: otherPlayers);
  }
}
