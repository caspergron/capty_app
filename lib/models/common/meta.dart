class Meta {
  int? perPage;
  int? currentPage;
  int? lastPage;
  int? total;

  Meta({this.perPage, this.currentPage, this.lastPage, this.total});

  Meta.fromJson(json) {
    perPage = json['per_page'];
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['per_page'] = perPage;
    map['current_page'] = currentPage;
    map['last_page'] = lastPage;
    map['total'] = total;
    return map;
  }
}
