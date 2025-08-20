import 'package:app/constants/data_constants.dart';

class Paginate {
  int page;
  int length;
  bool pageLoader;

  Paginate({this.page = 1, this.length = LENGTH_20, this.pageLoader = false});

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['page'] = page;
    map['length'] = length;
    map['pageLoader'] = pageLoader;
    return map;
  }
}
