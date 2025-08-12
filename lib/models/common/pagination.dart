class Pagination {
  int? currentPage;
  int? perPage;
  int? total;
  int? lastPage;

  Pagination({this.currentPage, this.perPage, this.total, this.lastPage});

  Pagination.fromJson(json) {
    currentPage = json['current_page'];
    perPage = json['per_page'];
    total = json['total'];
    lastPage = json['last_page'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['current_page'] = currentPage;
    map['per_page'] = perPage;
    map['total'] = total;
    map['last_page'] = lastPage;
    return map;
  }
}
