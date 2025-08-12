import 'package:app/models/plastic/plastic.dart';

class PlasticApi {
  bool? success;
  String? message;
  List<Plastic>? plastics;

  PlasticApi({this.success, this.message, this.plastics});

  PlasticApi.fromJson(json) {
    success = json['success'];
    message = json['message'];
    plastics = [];
    if (json['data'] != null) json['data'].forEach((v) => plastics?.add(Plastic.fromJson(v)));
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    if (plastics != null) map['data'] = plastics?.map((v) => v.toJson()).toList();
    return map;
  }
}
