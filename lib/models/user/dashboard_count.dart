import 'package:app/extensions/number_ext.dart';

class DashboardCount {
  int? totalDisc;
  int? pgdaRating;
  int? pdgaImprovement;

  bool get is_pdga => pgdaRating.nullToInt > 0;
  bool get is_positive => pdgaImprovement == null ? false : pdgaImprovement! > 0;

  DashboardCount({this.totalDisc, this.pgdaRating, this.pdgaImprovement});

  DashboardCount.fromJson(json) {
    totalDisc = json['total_discs'];
    pgdaRating = json['current_pgda_rating'];
    pdgaImprovement = json['current_pdga_improvement'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['total_discs'] = totalDisc;
    map['current_pgda_rating'] = pgdaRating;
    map['current_pdga_improvement'] = pdgaImprovement;
    return map;
  }
}
