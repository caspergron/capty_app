class Tag {
  int? id;
  String? displayName;
  String? name;
  String? description;
  bool? isVertical;
  bool? isHorizontal;
  bool? isSpecial;
  int? order;
  int? value;
  int? isActive;

  Tag({
    this.id,
    this.displayName,
    this.name,
    this.description,
    this.isVertical,
    this.isHorizontal,
    this.isSpecial,
    this.order,
    this.value,
    this.isActive,
  });

  Tag.fromJson(json) {
    id = json['id'];
    displayName = json['display_name'];
    name = json['name'];
    description = json['description'];
    isVertical = json['is_vertical'];
    isHorizontal = json['is_horizontal'];
    isSpecial = json['is_special'];
    order = json['order'];
    value = json['value'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['display_name'] = displayName;
    map['name'] = name;
    map['description'] = description;
    map['is_vertical'] = isVertical;
    map['is_horizontal'] = isHorizontal;
    map['is_special'] = isSpecial;
    map['order'] = order;
    map['value'] = value;
    map['is_active'] = isActive;
    return map;
  }
}
