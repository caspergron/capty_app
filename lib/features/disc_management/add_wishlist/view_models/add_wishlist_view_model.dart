import 'dart:async';

import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';

import 'package:app/constants/app_keys.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/features/disc_management/add_wishlist/components/added_to_wishlist_dialog.dart';
import 'package:app/features/disc_management/discs/discs_view_model.dart';
import 'package:app/models/disc/parent_disc.dart';
import 'package:app/models/disc/wishlist.dart';
import 'package:app/repository/disc_repo.dart';

class AddWishlistViewModel with ChangeNotifier {
  var loader = false;
  var discList = <ParentDisc>[];
  var _searchCounter = 0;

  void initViewModel() => disposeViewModel();

  void disposeViewModel() {
    loader = false;
    discList.clear();
    _searchCounter = 0;
  }

  Future<void> fetchSearchDiscs(String key) async {
    if (key.isEmpty) discList.clear();
    if (key.isEmpty) return notifyListeners();
    final currentRequest = ++_searchCounter;
    var body = {'query': key};
    var response = await sl<DiscRepository>().searchDiscByName(body: body, isWishlistSearch: true);
    if (currentRequest != _searchCounter) return;
    if (response.isNotEmpty) discList = response;
    notifyListeners();
  }

  Future<void> onAddedToWishlist(ParentDisc item, int index) async {
    loader = true;
    notifyListeners();
    var body = {'disc_id': item.id};
    var context = navigatorKey.currentState!.context;
    var response = await sl<DiscRepository>().addToWishlist(body);
    loader = false;
    if (response == null) return notifyListeners();
    unawaited(Provider.of<DiscsViewModel>(context, listen: false).fetchWishlistDiscs());
    discList[index].wishlistId = response;
    unawaited(addedToWishlistDialog());
    await Future.delayed(const Duration(milliseconds: 1500));
    backToPrevious();
    notifyListeners();
  }

  Future<void> onUpdateAndAddWishList(Wishlist wishlistItem) async {
    unawaited(addedToWishlistDialog());
    var context = navigatorKey.currentState!.context;
    unawaited(Provider.of<DiscsViewModel>(context, listen: false).fetchWishlistDiscs());
    await Future.delayed(const Duration(milliseconds: 1500));
    var index = discList.indexWhere((element) => element.id == wishlistItem.disc?.id);
    if (index >= 0) discList[index].wishlistId = 1;
    notifyListeners();
    backToPrevious();
  }

  Future<void> onRemoveFromWishlist(int wishlistId, int index) async {
    loader = true;
    notifyListeners();
    var context = navigatorKey.currentState!.context;
    var response = await sl<DiscRepository>().removeFromWishlist(wishlistId);
    loader = false;
    if (!response) return notifyListeners();
    unawaited(Provider.of<DiscsViewModel>(context, listen: false).fetchWishlistDiscs());
    discList[index].wishlistId = null;
    notifyListeners();
  }
}
