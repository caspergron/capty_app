import 'dart:async';

import 'package:app/constants/app_keys.dart';
import 'package:app/constants/data_constants.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/discs/components/added_to_wishlist_dialog.dart';
import 'package:app/features/discs/view_models/discs_view_model.dart';
import 'package:app/models/disc/disc_category.dart';
import 'package:app/models/disc/parent_disc.dart';
import 'package:app/models/system/loader.dart';
import 'package:app/repository/disc_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../../di.dart';

class PgdaDiscsViewModel with ChangeNotifier {
  var loader = DEFAULT_LOADER;
  var categories = <DiscCategory>[];
  var scrollControl = ScrollController();

  void initViewModel() {
    _fetchPdgaDiscsByCategory(isLoader: true);
    _paginationCheck();
  }

  void disposeViewModel() {
    loader = DEFAULT_LOADER;
    categories.clear();
  }

  Future<void> _fetchPdgaDiscsByCategory({bool isLoader = false, bool isPaginate = false, int index = 0}) async {
    var invalidApiCall = categories.isNotEmpty && categories[index].is_page_loader;
    if (invalidApiCall) return;
    loader.common = isLoader;
    if (categories.isNotEmpty) categories[index].paginate?.pageLoader = isPaginate;
    notifyListeners();
    var pageNumber = categories.isNotEmpty && isPaginate ? categories[index].paginate?.page ?? 1 : 1;
    var response = await sl<DiscRepository>().fetchParentDiscsByCategory(page: pageNumber, isWishlistSearch: true);
    if (response.isEmpty) return _turnOffLoaders(index: index);
    if (pageNumber == 1) {
      categories = response;
    } else {
      for (final entry in categories.asMap().entries) {
        final catIndex = entry.key;
        final catItem = entry.value;
        var newIndex = response.indexWhere((element) => element.name.toKey == catItem.name.toKey);
        if (newIndex >= 0) {
          var newItem = response[newIndex];
          categories[catIndex].parentDiscs ??= [];
          categories[catIndex].parentDiscs!.addAll(newItem.discs);
          categories[catIndex].pagination = newItem.pagination;
          var newLength = newItem.discs.length;
          categories[catIndex].paginate?.length = newLength;
          if (newLength >= LENGTH_08) categories[catIndex].paginate?.page = (categories[catIndex].paginate?.page ?? 0) + 1;
        }
      }
    }
    if (categories.isNotEmpty) unawaited(_paginationCheck());
    _turnOffLoaders(index: index);
  }

  void _turnOffLoaders({int index = 0}) {
    loader = Loader(initial: false, common: false);
    if (categories.isNotEmpty) categories[index].paginate?.pageLoader = false;
    return notifyListeners();
  }

  Future<void> _paginationCheck() async {
    if (categories.isEmpty) return;
    for (var entry in categories.asMap().entries) {
      final index = entry.key;
      final category = entry.value;
      final scrollController = category.scrollControl;
      final paginate = category.paginate;
      if (scrollController == null || paginate == null) continue;
      if (!scrollController.hasListeners) {
        scrollController.addListener(() {
          final maxPosition = scrollController.position.pixels == scrollController.position.maxScrollExtent;
          if (maxPosition && paginate.length == LENGTH_08) _fetchPdgaDiscsByCategory(isPaginate: true, index: index);
        });
      }
    }
  }

  Future<void> onAddedToWishlist(ParentDisc item, int index) async {
    loader.common = true;
    notifyListeners();
    var body = {'disc_id': item.id};
    var context = navigatorKey.currentState!.context;
    var response = await sl<DiscRepository>().addToWishlist(body);
    loader.common = false;
    if (response == null) return notifyListeners();
    unawaited(addedToWishlistDialog());
    unawaited(Provider.of<DiscsViewModel>(context, listen: false).fetchWishlistDiscs());
    await Future.delayed(const Duration(milliseconds: 1500));
    _updateFavouriteDisc(item, wishlistId: response);
    backToPrevious();
    notifyListeners();
  }

  Future<void> onRemoveFromWishlist(ParentDisc item, int index) async {
    loader.common = true;
    notifyListeners();
    var context = navigatorKey.currentState!.context;
    var response = await sl<DiscRepository>().removeFromWishlist(item.wishlistId!);
    loader.common = false;
    if (!response) return notifyListeners();
    unawaited(Provider.of<DiscsViewModel>(context, listen: false).fetchWishlistDiscs());
    _updateFavouriteDisc(item);
    notifyListeners();
  }

  void _updateFavouriteDisc(ParentDisc discItem, {int? wishlistId}) {
    if (categories.isEmpty) return;
    categories.asMap().forEach((index, category) {
      var discsList = category.discs;
      var discIndex = discsList.indexWhere((element) => element.id == discItem.id);
      if (discIndex >= 0) categories[index].discs[discIndex].wishlistId = wishlistId;
    });
    notifyListeners();
  }
}
