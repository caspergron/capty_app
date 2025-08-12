import 'package:app/models/feature/feature.dart';

class FeaturesApi {
  bool? success;
  String? message;
  List<Feature>? features;

  FeaturesApi({this.success, this.message, this.features});

  FeaturesApi.fromJson(json) {
    success = json['success'];
    message = json['message'];
    features = [];
    if (json['data'] != null) json['data'].forEach((v) => features?.add(Feature.fromJson(v)));
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    if (features != null) map['data'] = features?.map((v) => v.toJson()).toList();
    return map;
  }
}
