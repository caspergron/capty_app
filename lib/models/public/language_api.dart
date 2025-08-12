import 'package:app/models/public/language.dart';

class LanguageApi {
  String? status;
  String? message;
  List<Language>? languages;

  LanguageApi({this.status, this.languages, this.message});

  LanguageApi.fromJson(json) {
    status = json['status'];
    languages = [];
    if (json['data'] != null) json['data'].forEach((v) => languages?.add(Language.fromJson(v)));
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (languages != null) map['data'] = languages?.map((v) => v.toJson()).toList();
    map['message'] = message;
    return map;
  }
}
