import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/interfaces/api_interceptor.dart';
import 'package:app/libraries/flush_popup.dart';
import 'package:app/libraries/toasts_popups.dart';
import 'package:app/models/address/address.dart';
import 'package:app/models/address/address_api.dart';
import 'package:app/utils/api_url.dart';

class AddressRepository {
  Future<Address?> createAddress(Map<String, dynamic> body) async {
    var endpoint = ApiUrl.user.createAddress;
    var apiResponse = await sl<ApiInterceptor>().postRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) return null;
    ToastPopup.onInfo(message: 'created_successfully'.recast);
    return Address.fromJson(apiResponse.response['data']);
  }

  Future<List<Address>> fetchAllAddresses() async {
    var endpoint = ApiUrl.user.addressList;
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    var addressesApi = AddressApi.fromJson(apiResponse.response);
    return addressesApi.addresses.haveList ? addressesApi.addresses! : [];
  }

  Future<Address?> updateAddress(Map<String, dynamic> body, Address address) async {
    var endpoint = '${ApiUrl.user.updateAddress}${address.id}';
    var apiResponse = await sl<ApiInterceptor>().putRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) return null;
    ToastPopup.onInfo(message: 'updated_successfully'.recast);
    return Address.fromJson(apiResponse.response['data']);
  }

  Future<bool> deleteAddress(Address address) async {
    var endpoint = '${ApiUrl.user.deleteAddress}${address.id}';
    var apiResponse = await sl<ApiInterceptor>().deleteRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return false;
    FlushPopup.onInfo(message: 'deleted_successfully'.recast);
    return true;
  }
}
