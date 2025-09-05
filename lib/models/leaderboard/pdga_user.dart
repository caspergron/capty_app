import 'package:app/extensions/number_ext.dart';
import 'package:app/models/common/media.dart';
import 'package:app/models/leaderboard/pdga_pivot.dart';

class PdgaUser {
  int? id;
  String? name;
  int? mediaId;
  String? pdgaNumber;
  int? currentRating;
  int? currentImprovement;
  int? yearlyImprovement;
  PdgaPivot? pivot;
  Media? media;

  int get current_rating => currentRating.nullToInt;
  int get current_improvement => currentImprovement ?? 0;
  int get yearly_improvement => yearlyImprovement ?? 0;
  String get formatted_current_rating => currentRating.formatInt;
  bool get is_positive => currentImprovement == null ? true : currentImprovement! >= 0;

  PdgaUser({
    this.id,
    this.name,
    this.mediaId,
    this.pdgaNumber,
    this.currentRating,
    this.currentImprovement,
    this.yearlyImprovement,
    this.pivot,
    this.media,
  });

  PdgaUser.fromJson(json) {
    id = json['id'];
    name = json['name'];
    mediaId = json['media_id'];
    pdgaNumber = json['pdga_number'];
    currentRating = json['current_pdga_rating'];
    currentImprovement = json['current_pdga_improvement'];
    yearlyImprovement = json['current_pdga_improvement'];
    pivot = json['pivot'] != null ? PdgaPivot.fromJson(json['pivot']) : null;
    media = json['media'] != null ? Media.fromJson(json['media']) : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['media_id'] = mediaId;
    map['pdga_number'] = pdgaNumber;
    map['current_pdga_rating'] = currentRating;
    map['current_pdga_improvement'] = currentImprovement;
    map['pdga_yearly_improvement'] = yearlyImprovement;
    if (pivot != null) map['pivot'] = pivot?.toJson();
    if (media != null) map['media'] = media?.toJson();
    return map;
  }

  String get formated_current_improvement {
    final value = currentImprovement ?? 0;
    final absVal = value.abs().toString().padLeft(2, '0');
    final sign = value < 0 ? '-' : '+';
    return '$sign$absVal';
  }

  String get formated_yearly_improvement {
    final value = yearlyImprovement ?? 0;
    final absVal = value.abs().toString().padLeft(2, '0');
    final sign = value < 0 ? '-' : '+';
    return '$sign$absVal';
  }
}
