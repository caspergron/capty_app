import 'package:app/models/public/currency.dart';

class CurrencyApi {
  bool? success;
  String? message;
  List<Currency>? currencies;

  CurrencyApi({this.success, this.message, this.currencies});

  CurrencyApi.fromJson(json) {
    success = json['success'];
    message = json['message'];
    currencies = [];
    if (json['data'] != null) json['data'].forEach((v) => currencies?.add(Currency.fromJson(v)));
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    if (currencies != null) map['data'] = currencies?.map((v) => v.toJson()).toList();
    return map;
  }
}
