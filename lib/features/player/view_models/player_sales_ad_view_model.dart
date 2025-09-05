import 'dart:async';

import 'package:app/constants/app_keys.dart';
import 'package:app/constants/data_constants.dart';
import 'package:app/di.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/marketplace_management/marketplace/marketplace_view_model.dart';
import 'package:app/libraries/locations.dart';
import 'package:app/models/marketplace/marketplace_category.dart';
import 'package:app/models/marketplace/sales_ad.dart';
import 'package:app/models/system/loader.dart';
import 'package:app/models/user/user.dart';
import 'package:app/repository/marketplace_repo.dart';
import 'package:app/repository/player_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class PlayerSalesAdViewModel with ChangeNotifier {
  var loader = DEFAULT_LOADER;
  var categories = <MarketplaceCategory>[];

  void initViewModel(User player) {
    if (player.id == null) loader = Loader(initial: false, common: false);
    if (player.id == null) return notifyListeners();
    _fetchPlayerSalesAdDiscs(playerId: player.id!, isLoader: true);
  }

  void disposeViewModel() {
    loader = DEFAULT_LOADER;
    categories.clear();
  }

  void _stopLoader() {
    loader = Loader(initial: false, common: false);
    notifyListeners();
  }

  Future<void> _fetchPlayerSalesAdDiscs({required int playerId, bool isLoader = false, bool isPaginate = false, int index = 0}) async {
    var invalidApiCall = categories.isNotEmpty && categories[index].is_page_loader;
    if (invalidApiCall) return;
    loader.common = isLoader;
    if (categories.isNotEmpty) categories[index].paginate?.pageLoader = isPaginate;
    notifyListeners();
    final coordinates = await sl<Locations>().fetchLocationPermission();
    var locationParams = '&latitude=${coordinates.lat}&longitude=${coordinates.lng}';
    var pageNumber = categories.isNotEmpty && isPaginate ? categories[index].paginate?.page ?? 1 : 1;
    var params = '$playerId&page=$pageNumber$locationParams';
    var response = await sl<PlayerRepository>().fetchAllSalesAdDiscs(params);
    if (isLoader) categories.clear();
    if (response.isEmpty) return _stopLoader();
    pageNumber == 1 ? categories = response : _updateSalesAdsData(response);
    if (categories.isNotEmpty) unawaited(_salesAdsPaginationCheck(playerId: playerId));
    if (categories.isNotEmpty) categories[index].paginate?.pageLoader = false;
    _stopLoader();
  }

  void _updateSalesAdsData(List<MarketplaceCategory> responseList) {
    for (final entry in categories.asMap().entries) {
      final catIndex = entry.key;
      final catItem = entry.value;
      var newIndex = responseList.indexWhere((element) => element.name.toKey == catItem.name.toKey);
      if (newIndex >= 0) {
        var newItem = responseList[newIndex];
        categories[catIndex].salesAds ??= [];
        categories[catIndex].salesAds!.addAll(newItem.discs);
        categories[catIndex].pagination = newItem.pagination;
        var newLength = newItem.discs.length;
        categories[catIndex].paginate?.length = newLength;
        if (newLength >= LENGTH_10) categories[catIndex].paginate?.page = (categories[catIndex].paginate?.page ?? 0) + 1;
      }
    }
  }

  Future<void> _salesAdsPaginationCheck({required int playerId}) async {
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
          if (isPosition80 && paginate.length == LENGTH_10) _fetchPlayerSalesAdDiscs(playerId: playerId, isPaginate: true, index: index);
        });
      }
    }
  }

  Future<void> onSetAsFavourite(SalesAd item) async {
    loader.common = true;
    notifyListeners();
    var context = navigatorKey.currentState!.context;
    var body = {'sales_ad_id': item.id};
    var response = await sl<MarketplaceRepository>().setMarketplaceDiscAsFavourite(body);
    if (!response) return _stopLoader();
    _updateFavStatusInMarketplaceData(item: item, isFav: true);
    Provider.of<MarketplaceViewModel>(context, listen: false).updateFavStatusInMarketplaceData(item: item, isFav: true);
    unawaited(Provider.of<MarketplaceViewModel>(context, listen: false).fetchFavouriteDiscs(isLoader: true));
    _stopLoader();
  }

  Future<void> onRemoveFromFavourite(SalesAd item) async {
    loader.common = true;
    notifyListeners();
    var context = navigatorKey.currentState!.context;
    var response = await sl<MarketplaceRepository>().removeMarketplaceDiscFromFavourite(item.id!);
    if (!response) return _stopLoader();
    _updateFavStatusInMarketplaceData(item: item);
    Provider.of<MarketplaceViewModel>(context, listen: false).updateFavStatusInFavouriteData(item: item);
    Provider.of<MarketplaceViewModel>(context, listen: false).updateFavStatusInMarketplaceData(item: item);
    _stopLoader();
  }

  void _updateFavStatusInMarketplaceData({required SalesAd item, bool isFav = false}) {
    if (categories.isEmpty) return;
    var isFavorite = isFav ? 1 : 0;
    categories.asMap().forEach((index, category) {
      var discsList = category.discs;
      var adIndex = discsList.indexWhere((element) => element.id == item.id);
      if (adIndex >= 0) categories[index].salesAds?[adIndex].isFavorite = isFavorite;
    });
    notifyListeners();
  }
}
