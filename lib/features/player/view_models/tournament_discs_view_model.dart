import 'dart:async';

import 'package:app/constants/data_constants.dart';
import 'package:app/di.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/models/disc/disc_category.dart';
import 'package:app/models/system/loader.dart';
import 'package:app/models/user/user.dart';
import 'package:app/repository/disc_repo.dart';
import 'package:flutter/cupertino.dart';

class TournamentDiscsViewModel with ChangeNotifier {
  var loader = DEFAULT_LOADER;
  var categories = <DiscCategory>[];
  var scrollControl = ScrollController();

  void initViewModel(User player) {
    if (player.id == null) loader = Loader(initial: false, common: false);
    if (player.id == null) return notifyListeners();
    _fetchTournamentDiscsByCategory(playerId: player.id!, isLoader: true);
  }

  void disposeViewModel() {
    loader = DEFAULT_LOADER;
    categories.clear();
  }

  void _stopLoader() {
    loader = Loader(initial: false, common: false);
    notifyListeners();
  }

  Future<void> _fetchTournamentDiscsByCategory(
      {required int playerId, bool isLoader = false, bool isPaginate = false, int index = 0}) async {
    var invalidApiCall = categories.isNotEmpty && categories[index].is_page_loader;
    if (invalidApiCall) return;
    loader.common = isLoader;
    if (categories.isNotEmpty) categories[index].paginate?.pageLoader = isPaginate;
    notifyListeners();
    var pageNumber = categories.isNotEmpty && isPaginate ? categories[index].paginate?.page ?? 1 : 1;
    var response = await sl<DiscRepository>().fetchParentDiscsByCategory(page: pageNumber, isWishlistSearch: true);
    if (isLoader) categories.clear();
    if (response.isEmpty) return _stopLoader();
    pageNumber == 1 ? categories = response : _updateMarketplaceData(response);
    if (categories.isNotEmpty) unawaited(_paginationCheck(playerId: playerId));
    if (categories.isNotEmpty) categories[index].paginate?.pageLoader = false;
    _stopLoader();
  }

  void _updateMarketplaceData(List<DiscCategory> responseList) {
    for (final entry in categories.asMap().entries) {
      final catIndex = entry.key;
      final catItem = entry.value;
      var newIndex = responseList.indexWhere((element) => element.name?.toKey == catItem.name.toKey);
      if (newIndex >= 0) {
        var newItem = responseList[newIndex];
        categories[catIndex].parentDiscs ??= [];
        categories[catIndex].parentDiscs!.addAll(newItem.discs);
        categories[catIndex].pagination = newItem.pagination;
        var newLength = newItem.discs.length;
        categories[catIndex].paginate?.length = newLength;
        if (newLength >= LENGTH_10) categories[catIndex].paginate?.page = (categories[catIndex].paginate?.page ?? 0) + 1;
      }
    }
  }

  Future<void> _paginationCheck({required int playerId}) async {
    if (categories.isEmpty) return;
    for (var entry in categories.asMap().entries) {
      final index = entry.key;
      final category = entry.value;
      final scrollController = category.scrollControl;
      final paginate = category.paginate;
      if (scrollController == null || paginate == null) continue;
      if (!scrollController.hasListeners) {
        scrollController.addListener(() {
          final position = scrollController.position;
          final isPosition80 = position.pixels >= position.maxScrollExtent * 0.85;
          if (isPosition80 && paginate.length == LENGTH_10)
            _fetchTournamentDiscsByCategory(playerId: playerId, isPaginate: true, index: index);
        });
      }
    }
  }

  /*Future<void> onDiscItem(UserDisc item, int index) async {
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
  }*/
}
