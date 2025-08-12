class AppStatistics {
  int? totalUser;
  int? totalClub;
  int? totalCountry;
  int? totalSalesAdds;

  AppStatistics({this.totalUser, this.totalClub, this.totalCountry, this.totalSalesAdds});

  AppStatistics.fromJson(json) {
    totalUser = json['total_users'];
    totalClub = json['total_clubs'];
    totalCountry = json['total_countries'];
    totalSalesAdds = json['total_sales_adds'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['total_users'] = totalUser;
    map['total_clubs'] = totalClub;
    map['total_countries'] = totalCountry;
    map['total_sales_adds'] = totalSalesAdds;
    return map;
  }
}
