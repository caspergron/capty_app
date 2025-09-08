import 'dart:async';

import 'package:flutter/foundation.dart';

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
  var _lastQuery = '';
  Timer? _debounceTimer;

  void initViewModel() => disposeViewModel();

  void disposeViewModel() {
    loader = false;
    discList.clear();
    _searchCounter = 0;
    _lastQuery = '';
    _debounceTimer?.cancel();
  }

  void onDebounceSearch(String query) {
    _debounceTimer?.cancel();
    if (query.trim().isEmpty || query.length < 2) return _onEmptyKey();
    if (query == _lastQuery) return;
    _lastQuery = query;
    _debounceTimer = Timer(const Duration(milliseconds: 300), () => _fetchSearchDisc(query));
  }

  Future<void> _fetchSearchDisc(String pattern) async {
    final currentRequest = ++_searchCounter;
    var body = {'query': pattern};
    try {
      var response = await sl<DiscRepository>().searchDiscByName(body: body, isWishlistSearch: true);
      if (currentRequest != _searchCounter) return;
      discList.clear();
      if (response.isNotEmpty) discList.addAll(response);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) print('Search error: $e');
    }
  }

  void _onEmptyKey() {
    discList.clear();
    _lastQuery = '';
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
