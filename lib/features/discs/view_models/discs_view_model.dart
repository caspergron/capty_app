import 'dart:async';

import 'package:flutter/cupertino.dart';

import 'package:app/constants/data_constants.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/discs/components/disc_info_dialog.dart';
import 'package:app/features/discs/components/edit_disc_dialog.dart';
import 'package:app/libraries/flush_popup.dart';
import 'package:app/models/disc/user_disc.dart';
import 'package:app/models/disc/wishlist.dart';
import 'package:app/models/disc_bag/disc_bag.dart';
import 'package:app/models/system/loader.dart';
import 'package:app/repository/disc_bag_repo.dart';
import 'package:app/repository/disc_repo.dart';
import 'package:app/services/api_status.dart';
import 'package:app/services/routes.dart';

var _ALL_CATEGORY = DiscBag(id: 1000001, name: 'all');

class DiscsViewModel with ChangeNotifier {
  var loader = DEFAULT_LOADER;
  var discBag = _ALL_CATEGORY;
  var discBags = <DiscBag>[];
  var wishlistDiscs = <Wishlist>[];

  void initViewModel() {
    if (ApiStatus.instance.discs) return;
    fetchWishlistDiscs();
    fetchAllDiscBags();
  }

  void updateUi() => notifyListeners();

  void clearStates() {
    loader = DEFAULT_LOADER;
    discBag = _ALL_CATEGORY;
    discBags.clear();
    wishlistDiscs.clear();
  }

  List<UserDisc> get allDiscs {
    if (discBags.isEmpty) return [];
    return discBags.where((item) => item.userDiscs.haveList).expand((item) => item.userDiscs!).toList();
  }

  Future<void> fetchAllDiscBags() async {
    var response = await sl<DiscBagRepository>().fetchDiscBags();
    allDiscs.clear();
    discBags.clear();
    if (response.isNotEmpty) discBags = response;
    var index = discBag.id == 1000001 || discBag.id == 1000002 ? -1 : discBags.indexWhere((e) => e.id == discBag.id);
    if (index >= 0) discBag = discBags[index];
    ApiStatus.instance.discs = true;
    loader = Loader(initial: false, common: false);
    notifyListeners();
  }

  Future<void> onCreateDisBag(Map<String, dynamic> body) async {
    loader.common = true;
    notifyListeners();
    var response = await sl<DiscBagRepository>().createDiscBag(body);
    if (response != null) discBags.add(response);
    if (response != null && discBags.length == 1 && discBag.id == null) discBag = discBags.first;
    loader.common = false;
    notifyListeners();
  }

  void onDiscBag(DiscBag bag) {
    discBag = bag;
    if (discBag.userDiscs.haveList) discBag.userDiscs!.forEach((item) => item.selected = false);
    notifyListeners();
  }

  Future<void> onMoveDiscToAnotherBag(Map<String, dynamic> body, String bag) async {
    loader.common = true;
    notifyListeners();
    var response = await sl<DiscBagRepository>().moveDiscToAnotherBag(body);
    if (response) await fetchAllDiscBags();
    if (response) FlushPopup.onInfo(message: '${'disc_added_in'.recast} $bag');
    loader.common = false;
    notifyListeners();
  }

  Future<void> onDiscItem(UserDisc item, int index) async {
    loader.common = true;
    notifyListeners();
    var response = await sl<DiscRepository>().fetchUserDiscDetails(item.id!);
    loader.common = false;
    if (response == null) return notifyListeners();
    unawaited(discInfoDialog(
      disc: response,
      onDelete: () => onDeleteDisc(response, index),
      onSell: () => Routes.user.create_sales_ad(tabIndex: 1, disc: response).push(),
      onDetails: () => editDiscDialog(disc: response, onSave: (params) => _onUpdateDisc(response, index)),
    ));
    notifyListeners();
  }

  Future<void> _onUpdateDisc(UserDisc item, int index) async {
    loader.common = true;
    notifyListeners();
    await fetchAllDiscBags();
    await Future.delayed(const Duration(seconds: 4));
    FlushPopup.onInfo(message: 'disc_update_successfully'.recast);
    loader.common = false;
    notifyListeners();
  }

  Future<void> onDeleteBag(DiscBag item) async {
    var isSelected = discBag.id != null && discBag.id == item.id;
    var index = discBags.indexWhere((element) => element.id == item.id);
    if (index < 0) return;
    loader.common = true;
    notifyListeners();
    var response = await sl<DiscBagRepository>().deleteDiscBag(item.id!);
    if (response) {
      await fetchAllDiscBags();
      if (isSelected) discBag = _ALL_CATEGORY;
      FlushPopup.onInfo(message: 'bag_deleted_successfully'.recast);
    }
    loader.common = false;
    notifyListeners();
  }

  Future<void> onDeleteDisc(UserDisc item, int index) async {
    loader.common = true;
    notifyListeners();
    var response = await sl<DiscRepository>().deleteUserDisc(item.id!);
    if (response) await fetchAllDiscBags();
    loader.common = false;
    notifyListeners();
  }

  Future<void> fetchWishlistDiscs() async {
    var response = await sl<DiscRepository>().fetchWishlistDiscs();
    if (response.isNotEmpty) wishlistDiscs = response;
    notifyListeners();
  }

  Future<void> onRemoveFromWishlist(Wishlist wishlist, int index) async {
    loader.common = true;
    notifyListeners();
    var response = await sl<DiscRepository>().removeFromWishlist(wishlist.id!);
    if (response) wishlistDiscs.removeAt(index);
    loader.common = false;
    notifyListeners();
  }

  Future<void> onUpdateWishlistDisc(int index, Wishlist updatedItem) async {
    loader.common = true;
    wishlistDiscs[index] = updatedItem;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    FlushPopup.onInfo(message: 'disc_update_successfully'.recast);
    loader.common = false;
    notifyListeners();
  }

  /*Future<void> fetchBagDetails(DiscBag bag) async {
    var invalidBag = discBags.isEmpty || discBags.where((item) => item.id == bag.id).toList().length < 1;
    if (invalidBag) return;
    loader.common = true;
    notifyListeners();
    var response = await sl<DiscBagRepository>().fetchDiscBagDetails(bag);
    loader.common = false;
    if (response == null) return notifyListeners();
    var index = discBags.isEmpty ? -1 : discBags.indexWhere((item) => item.id == bag.id);
    if (index >= 0) discBags[index] = response;
    if (discBag.id != null && discBag.id == bag.id) discBag = response;
    notifyListeners();
  }*/
}
