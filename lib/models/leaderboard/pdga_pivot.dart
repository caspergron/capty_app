class PdgaPivot {
  int? clubId;
  int? userId;
  int? isAdmin;
  int? isDefault;
  String? createdAt;
  String? updatedAt;

  PdgaPivot({this.clubId, this.userId, this.isAdmin, this.isDefault, this.createdAt, this.updatedAt});

  PdgaPivot.fromJson(json) {
    clubId = json['club_id'];
    userId = json['user_id'];
    isAdmin = json['is_admin'];
    isDefault = json['is_default'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['club_id'] = clubId;
    map['user_id'] = userId;
    map['is_admin'] = isAdmin;
    map['is_default'] = isDefault;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }
}
