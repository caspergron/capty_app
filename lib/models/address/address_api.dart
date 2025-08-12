import 'package:app/models/address/address.dart';

class AddressApi {
  bool? success;
  String? message;
  List<Address>? addresses;

  AddressApi({this.success, this.message, this.addresses});

  AddressApi.fromJson(json) {
    success = json['success'];
    message = json['message'];
    addresses = [];
    if (json['data'] != null) json['data'].forEach((v) => addresses?.add(Address.fromJson(v)));
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    if (addresses != null) map['data'] = addresses?.map((v) => v.toJson()).toList();
    return map;
  }
}
