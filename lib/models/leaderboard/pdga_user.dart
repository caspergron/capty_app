import 'package:app/extensions/number_ext.dart';
import 'package:app/models/common/media.dart';
import 'package:app/models/leaderboard/pdga_pivot.dart';

class PdgaUser {
  int? id;
  String? name;
  int? mediaId;
  String? pdgaNumber;
  int? pdgaRating;
  int? pdgaImprovement;
  PdgaPivot? pivot;
  Media? media;

  String get pdga_rating => pdgaRating.formatInt;
  int get pdga_improvement => pdgaImprovement ?? 0;
  bool get is_positive => pdgaImprovement == null ? true : pdgaImprovement! >= 0;

  PdgaUser({
    this.id,
    this.name,
    this.mediaId,
    this.pdgaNumber,
    this.pdgaRating,
    this.pdgaImprovement,
    this.pivot,
    this.media,
  });

  PdgaUser.fromJson(json) {
    id = json['id'];
    name = json['name'];
    mediaId = json['media_id'];
    pdgaNumber = json['pdga_number'];
    pdgaRating = json['current_pdga_rating'];
    pdgaImprovement = json['current_pdga_improvement'];
    pivot = json['pivot'] != null ? PdgaPivot.fromJson(json['pivot']) : null;
    media = json['media'] != null ? Media.fromJson(json['media']) : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['media_id'] = mediaId;
    map['pdga_number'] = pdgaNumber;
    map['current_pdga_rating'] = pdgaRating;
    map['current_pdga_improvement'] = pdgaImprovement;
    if (pivot != null) map['pivot'] = pivot?.toJson();
    if (media != null) map['media'] = media?.toJson();
    return map;
  }

  String get formated_pgda_improvement {
    final value = pdgaImprovement ?? 0;
    final absVal = value.abs().toString().padLeft(2, '0');
    final sign = value < 0 ? '-' : '+';
    return '$sign$absVal';
  }
}
