import 'package:app/models/leaderboard/pdga_user.dart';

class Leaderboard {
  String? clubName;
  List<PdgaUser>? players;
  List<PdgaUser> topPlayers = [];
  List<PdgaUser> otherPlayers = [];

  Leaderboard({this.clubName, this.players, this.topPlayers = const [], this.otherPlayers = const []});

  Leaderboard.fromJson(json) {
    clubName = json['club_name'];
    players = [];
    if (json['players'] != null) json['players'].forEach((v) => players?.add(PdgaUser.fromJson(v)));
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['club_name'] = clubName;
    if (players != null) map['players'] = players?.map((v) => v.toJson()).toList();
    if (topPlayers.isNotEmpty) map['topPlayers'] = topPlayers.map((v) => v.toJson()).toList();
    if (otherPlayers.isNotEmpty) map['otherPlayers'] = otherPlayers.map((v) => v.toJson()).toList();
    return map;
  }
}
