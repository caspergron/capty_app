import 'package:app/constants/data_constants.dart';
import 'package:app/di.dart';
import 'package:app/models/address/address.dart';
import 'package:app/models/system/loader.dart';
import 'package:app/preferences/user_preferences.dart';
import 'package:app/repository/address_repo.dart';
import 'package:flutter/cupertino.dart';

class SellerSettingsViewModel with ChangeNotifier {
  var loader = DEFAULT_LOADER;
  var addresses = <Address>[];
  var isShipping = false;

  void initViewModel() {
    isShipping = UserPreferences.user.is_shipping;
    notifyListeners();
    fetchShippingInfo();
    fetchAllAddresses();
  }

  void disposeViewModel() {}

  void clearStates() {
    loader = DEFAULT_LOADER;
    addresses.clear();
    isShipping = false;
  }

  Future<void> fetchAllAddresses() async {
    var response = await sl<AddressRepository>().fetchAllAddresses();
    if (response.isNotEmpty) addresses = response;
    loader = Loader(initial: false, common: false);
    notifyListeners();
  }

  Future<void> deleteAddress(Address addressItem) async {
    loader.common = true;
    notifyListeners();
    var index = addresses.indexWhere((element) => element.id == addressItem.id);
    var response = await sl<AddressRepository>().deleteAddress(addressItem);
    if (response) addresses.removeAt(index);
    loader = Loader(initial: false, common: false);
    notifyListeners();
  }

  void updateAddressItem({required Address addressItem, required bool isAdd}) {
    if (isAdd) addresses.add(addressItem);
    if (isAdd) return notifyListeners();
    var index = addresses.indexWhere((element) => element.id == addressItem.id);
    if (index >= 0) addresses[index] = addressItem;
    notifyListeners();
  }

  Future<void> fetchShippingInfo() async {
    var userId = UserPreferences.user.id;
    if (userId == null) return;
    var response = await sl<AddressRepository>().fetchShippingInfo(userId);
    if (response != null) isShipping = response;
    notifyListeners();
  }

  Future<void> onUpdateShippingInfo(bool value) async {
    loader.common = true;
    notifyListeners();
    var response = await sl<AddressRepository>().updateShippingInfo(value);
    if (response != null) isShipping = response;
    loader.common = false;
    notifyListeners();
  }
}
