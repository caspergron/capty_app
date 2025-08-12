class Link {
  String? url;
  String? label;
  bool? active;

  Link({this.url, this.label, this.active});

  Link.fromJson(json) {
    url = json['url'];
    label = json['label'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['url'] = url;
    map['label'] = label;
    map['active'] = active;
    return map;
  }
}
