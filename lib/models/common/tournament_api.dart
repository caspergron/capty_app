import 'package:app/models/common/tournament.dart';

class TournamentApi {
  bool? success;
  String? message;
  List<Tournament>? tournaments;

  TournamentApi({this.success, this.message, this.tournaments});

  TournamentApi.fromJson(json) {
    success = json['success'];
    message = json['message'];
    tournaments = [];
    if (json['data'] != null) json['data'].forEach((v) => tournaments?.add(Tournament.fromJson(v)));
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    if (tournaments != null) map['data'] = tournaments?.map((v) => v.toJson()).toList();
    return map;
  }
}
