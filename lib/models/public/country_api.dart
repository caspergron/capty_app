import 'package:app/models/public/country.dart';

class CountryApi {
  bool? success;
  String? message;
  List<Country>? countries;

  CountryApi({this.success, this.message, this.countries});

  CountryApi.fromJson(json) {
    success = json['success'];
    message = json['message'];
    countries = [];
    if (json['data'] != null) json['data'].forEach((v) => countries?.add(Country.fromJson(v)));
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    if (countries != null) map['data'] = countries?.map((v) => v.toJson()).toList();
    return map;
  }
}
