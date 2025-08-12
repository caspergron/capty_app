class Dimension {
  double? small;
  double mobile;
  double? tab;

  Dimension({required this.mobile, this.small, this.tab});

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['small'] = small;
    map['mobile'] = mobile;
    map['tab'] = tab;
    return map;
  }
}
