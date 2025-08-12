import 'dart:async';

import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';

import 'package:app/constants/app_keys.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/features/discs/components/added_to_wishlist_dialog.dart';
import 'package:app/features/discs/view_models/discs_view_model.dart';
import 'package:app/models/disc/parent_disc.dart';
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
    // loader = false;
    notifyListeners();
  }

  Future<void> onAddedToWishlist(ParentDisc item, int index) async {
    loader = true;
    notifyListeners();
    var body = {'disc_id': item.id};
    var response = await sl<DiscRepository>().addToWishlist(body);
    if (response != null) {
      var context = navigatorKey.currentState!.context;
      unawaited(Provider.of<DiscsViewModel>(context, listen: false).fetchWishlistDiscs());
      discList[index].wishlistId = response;
      unawaited(addedToWishlistDialog());
      await Future.delayed(const Duration(milliseconds: 1500));
      backToPrevious();
    }
    loader = false;
    notifyListeners();
  }

  Future<void> onRemoveFromWishlist(int wishlistId, int index) async {
    loader = true;
    notifyListeners();
    var response = await sl<DiscRepository>().removeFromWishlist(wishlistId);
    if (response) {
      var context = navigatorKey.currentState!.context;
      unawaited(Provider.of<DiscsViewModel>(context, listen: false).fetchWishlistDiscs());
      discList[index].wishlistId = null;
    }
    loader = false;
    notifyListeners();
  }
}
