class Loader {
  bool initial;
  bool common;

  bool get loader => initial == true || common == true;

  Loader({this.initial = true, this.common = true});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['initial'] = initial;
    map['common'] = common;
    return map;
  }
}
