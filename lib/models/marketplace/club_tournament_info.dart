import 'package:app/extensions/flutter_ext.dart';
import 'package:app/models/club/club.dart';
import 'package:app/models/common/tournament.dart';

class ClubTournamentInfo {
  List<Club>? clubs;
  List<Tournament>? tournaments;
  bool? isFriend;

  bool get is_friend => isFriend != null && isFriend == true;
  String get club_info => !clubs.haveList ? '' : clubs!.map((item) => item.name ?? '').join(', ');
  String get tournament_info => !tournaments.haveList ? '' : tournaments!.map((item) => item.tournament_info_1).join(', ');

  ClubTournamentInfo({this.clubs, this.tournaments, this.isFriend});

  ClubTournamentInfo.fromJson(json) {
    clubs = [];
    if (json['clubs'] != null) json['clubs'].forEach((v) => clubs?.add(Club.fromJson(v)));
    tournaments = [];
    if (json['tournament'] != null) json['tournament'].forEach((v) => tournaments?.add(Tournament.fromJson(v)));
    isFriend = json['is_friend'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (clubs != null) map['clubs'] = clubs?.map((v) => v.toJson()).toList();
    if (tournaments != null) map['tournament'] = tournaments?.map((v) => v.toJson()).toList();
    map['is_friend'] = isFriend;
    return map;
  }
}
