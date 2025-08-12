class SalesAdType {
  int? id;
  String? name;
  String? description;
  String? label;

  SalesAdType({this.id, this.name, this.description, this.label});

  SalesAdType.fromJson(json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    label = json['name'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['description'] = description;
    map['label'] = label;
    return map;
  }
}
