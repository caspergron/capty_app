class Language {
  int? id;
  String? name;
  String? code;
  String? flag;
  int? isActive;
  int? isDefault;

  Language({this.id, this.name, this.code, this.flag, this.isActive, this.isDefault});

  Language.fromJson(json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    flag = json['flag'];
    isActive = json['is_active'];
    isDefault = json['is_default'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['code'] = code;
    map['flag'] = flag;
    map['is_active'] = isActive;
    map['is_default'] = isDefault;
    return map;
  }
}
