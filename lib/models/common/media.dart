class Media {
  int? id;
  String? url;
  String? type;
  String? section;
  String? alt;

  Media({this.id, this.url, this.type, this.section, this.alt});

  Media.fromJson(json) {
    id = json['id'];
    url = json['url'];
    type = json['type'];
    section = json['section'];
    alt = json['alt'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['url'] = url;
    map['type'] = type;
    map['section'] = section;
    map['alt'] = alt;
    return map;
  }
}
