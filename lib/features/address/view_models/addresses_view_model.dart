import 'package:flutter/cupertino.dart';

import 'package:app/constants/data_constants.dart';
import 'package:app/di.dart';
import 'package:app/models/address/address.dart';
import 'package:app/models/system/loader.dart';
import 'package:app/repository/address_repo.dart';

class AddressesViewModel with ChangeNotifier {
  var loader = DEFAULT_LOADER;
  var addresses = <Address>[];

  void initViewModel() {
    fetchAllAddresses();
  }

  void disposeViewModel() {}

  Future<void> fetchAllAddresses() async {
    var response = await sl<AddressRepository>().fetchAllAddresses();
    if (response.isNotEmpty) addresses = response;
    loader = Loader(initial: false, common: false);
    notifyListeners();
  }

  Future<void> deleteAddress(Address address, int index) async {
    loader.common = true;
    notifyListeners();
    var response = await sl<AddressRepository>().deleteAddress(address);
    if (response) addresses.removeAt(index);
    loader = Loader(initial: false, common: false);
    notifyListeners();
  }

  void updateAddressItem({required Address address, required bool isAdd}) {
    if (isAdd) addresses.add(address);
    if (isAdd) return notifyListeners();
    var index = addresses.indexWhere((element) => element.id == address.id);
    if (index >= 0) addresses[index] = address;
  }
}
