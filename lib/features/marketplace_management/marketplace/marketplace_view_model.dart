import 'dart:async';

import 'package:flutter/cupertino.dart';

import 'package:app/constants/data_constants.dart';
import 'package:app/di.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/marketplace_management/marketplace/components/share_sales_ad_dialog.dart';
import 'package:app/helpers/marketplace_helper.dart';
import 'package:app/libraries/flush_popup.dart';
import 'package:app/libraries/locations.dart';
import 'package:app/libraries/toasts_popups.dart';
import 'package:app/models/common/tag.dart';
import 'package:app/models/marketplace/club_tournament_info.dart';
import 'package:app/models/marketplace/marketplace_category.dart';
import 'package:app/models/marketplace/marketplace_filter.dart';
import 'package:app/models/marketplace/sales_ad.dart';
import 'package:app/models/system/doc_file.dart';
import 'package:app/models/system/loader.dart';
import 'package:app/models/system/paginate.dart';
import 'package:app/preferences/user_preferences.dart';
import 'package:app/repository/marketplace_repo.dart';
import 'package:app/repository/user_repo.dart';
import 'package:app/services/api_status.dart';
import 'package:app/services/app_analytics.dart';

class MarketplaceViewModel with ChangeNotifier {
  var loader = DEFAULT_LOADER;
  var searchKey = '';
  var tag = Tag();
  var tags = <Tag>[];
  var categories = <MarketplaceCategory>[];
  var clubTournament = ClubTournamentInfo();
  var filterOption = MarketplaceFilter(types: [], brands: [], tags: []);
  var salesAdDiscs = <SalesAd>[];
  var salesAdPaginate = Paginate();
  var salesAdScrollControl = ScrollController();
  var favCategories = <MarketplaceCategory>[];
  var favouritePaginate = Paginate();
  var favouriteScrollControl = ScrollController();

  Future<void> initViewModel() async {
    unawaited(_fetchClubTournamentsInfo());
    if (ApiStatus.instance.marketplace) return;
    unawaited(fetchTags());
    unawaited(fetchFavouriteDiscs(isInit: true));
    unawaited(fetchSalesAdDiscs());
  }

  void updateUi() => notifyListeners();

  void clearStates() {
    loader = DEFAULT_LOADER;
    searchKey = '';
    tag = Tag();
    tags.clear();
    categories.clear();
    clubTournament = ClubTournamentInfo();
    filterOption = MarketplaceFilter(types: [], brands: [], tags: []);
    salesAdDiscs.clear();
    salesAdPaginate = Paginate();
    salesAdScrollControl = ScrollController();
    favCategories = <MarketplaceCategory>[];
    favouritePaginate = Paginate();
    favouriteScrollControl = ScrollController();
  }

  Future<void> _fetchClubTournamentsInfo() async {
    final response = await sl<MarketplaceRepository>().fetchClubTournamentInfo();
    if (response != null) clubTournament = response;
    notifyListeners();
  }

  Future<void> fetchTags() async {
    final tagResponse = await sl<MarketplaceRepository>().fetchMarketplaceTags();
    if (tagResponse.isNotEmpty) tags = tagResponse;
    if (tags.isNotEmpty) tag = tags.first;
    notifyListeners();
    await generateFilterUrl(isLoader: true);
  }

  Future<void> fetchSalesAdDiscs({bool isPaginate = false}) async {
    if (salesAdPaginate.pageLoader) return;
    salesAdPaginate.pageLoader = isPaginate;
    notifyListeners();
    final params = '&page=${salesAdPaginate.page}';
    final response = await sl<MarketplaceRepository>().fetchSalesAdDiscs(params);
    if (salesAdPaginate.page == 1) salesAdDiscs.clear();
    salesAdPaginate.length = response.length;
    if (salesAdPaginate.length >= LENGTH_20) salesAdPaginate.page++;
    if (response.isNotEmpty) {
      salesAdDiscs.addAll(response);
      // final seenIds = <int>{};
      // salesAdDiscs.where((ad) => seenIds.add(ad.id.nullToInt)).toList();
    }
    salesAdPaginate.pageLoader = false;
    notifyListeners();
    if (salesAdDiscs.isNotEmpty) salesAdScrollControl.addListener(_salesAdPaginationCheck);
  }

  void _salesAdPaginationCheck() {
    final position = salesAdScrollControl.position;
    final isPosition70 = position.pixels >= position.maxScrollExtent * 0.75;
    if (isPosition70 && salesAdPaginate.length == LENGTH_20) fetchSalesAdDiscs(isPaginate: true);
  }

  Future<void> fetchFavouriteDiscs({bool isInit = false, bool isLoader = false, bool isPaginate = false, int index = 0}) async {
    final invalidApiCall = favCategories.isNotEmpty && favCategories[index].is_page_loader;
    if (invalidApiCall) return;
    loader.common = isLoader;
    if (favCategories.isNotEmpty) favCategories[index].paginate?.pageLoader = isPaginate;
    notifyListeners();
    final coordinates = await sl<Locations>().fetchLocationPermission();
    final locationParams = '&latitude=${coordinates.lat}&longitude=${coordinates.lng}';
    final pageNumber = favCategories.isNotEmpty && isPaginate ? favCategories[index].paginate?.page ?? 1 : 1;
    final params = '$pageNumber$locationParams';
    final response = await sl<MarketplaceRepository>().fetchMarketplaceFavourites(params);
    if (isLoader) favCategories.clear();
    if (response.isEmpty) return isInit ? notifyListeners() : _turnOffLoaders(index: index);
    pageNumber == 1 ? favCategories = response : _updateFavouritesData(response);
    if (favCategories.isNotEmpty) unawaited(_favouriteDiscsPaginationCheck());
    return isInit ? notifyListeners() : _turnOffLoaders(index: index);
  }

  void _updateFavouritesData(List<MarketplaceCategory> responseList) {
    for (final entry in favCategories.asMap().entries) {
      final catIndex = entry.key;
      final catItem = entry.value;
      final newIndex = responseList.indexWhere((element) => element.name.toKey == catItem.name.toKey);
      if (newIndex >= 0) {
        final newItem = responseList[newIndex];
        favCategories[catIndex].salesAds ??= [];
        favCategories[catIndex].salesAds!.addAll(newItem.discs);
        favCategories[catIndex].pagination = newItem.pagination;
        final newLength = newItem.discs.length;
        favCategories[catIndex].paginate?.length = newLength;
        if (newLength >= LENGTH_10) favCategories[catIndex].paginate?.page = (favCategories[catIndex].paginate?.page ?? 0) + 1;
      }
    }
  }

  Future<void> _favouriteDiscsPaginationCheck() async {
    if (favCategories.isEmpty) return;
    for (final entry in favCategories.asMap().entries) {
      final index = entry.key;
      final category = entry.value;
      final scrollController = category.scrollControl;
      final paginate = category.paginate;
      if (scrollController == null || paginate == null) continue;
      if (!scrollController.hasListeners) {
        scrollController.addListener(() {
          final position = scrollController.position;
          final isPosition70 = position.pixels >= position.maxScrollExtent * 0.80;
          if (isPosition70 && paginate.length == LENGTH_10) fetchFavouriteDiscs(isPaginate: true, index: index);
        });
      }
    }
  }

  Future<void> onSetAsFavourite(SalesAd item) async {
    loader.common = true;
    notifyListeners();
    final body = {'sales_ad_id': item.id};
    final response = await sl<MarketplaceRepository>().setMarketplaceDiscAsFavourite(body);
    if (!response) return _stopLoader();
    unawaited(fetchFavouriteDiscs());
    updateFavStatusInMarketplaceData(item: item, isFav: true);
    _stopLoader();
  }

  Future<void> onRemoveFromFavourite(SalesAd item) async {
    loader.common = true;
    notifyListeners();
    final response = await sl<MarketplaceRepository>().removeMarketplaceDiscFromFavourite(item.id!);
    if (!response) return _stopLoader();
    updateFavStatusInFavouriteData(item: item);
    updateFavStatusInMarketplaceData(item: item);
    _stopLoader();
  }

  Future<void> generateFilterUrl({bool isLoader = false, bool isPaginate = false, int index = 0}) async {
    final invalidApiCall = categories.isNotEmpty && categories[index].is_page_loader;
    if (invalidApiCall) return;
    loader.common = isLoader;
    if (categories.isNotEmpty) categories[index].paginate?.pageLoader = isPaginate;
    notifyListeners();
    var params = '';
    final coordinates = await sl<Locations>().fetchLocationPermission();
    final locationParams = '&latitude=${coordinates.lat}&longitude=${coordinates.lng}';
    final pageNumber = categories.isNotEmpty && isPaginate ? categories[index].paginate?.page ?? 1 : 1;
    if (searchKey.isNotEmpty) {
      params = '&page=$pageNumber$locationParams&search=$searchKey'.trim();
      unawaited(_fetchMarketplaceDiscs(isLoader: isLoader, isPaginate: isPaginate, index: index, params: params));
    } else {
      if (tag.name.toKey == 'distance'.toKey && !coordinates.is_coordinate) return _turnOffLoaders(index: index, isPopup: true);
      params = sl<MarketplaceHelper>().generateMarketplaceApiParams(tag, pageNumber, locationParams, filterOption.parameters);
      unawaited(_fetchMarketplaceDiscs(isLoader: isLoader, isPaginate: isPaginate, index: index, params: params));
    }
  }

  Future<void> _fetchMarketplaceDiscs({bool isLoader = false, bool isPaginate = false, String params = '', int index = 0}) async {
    final pageNumber = categories.isNotEmpty && isPaginate ? categories[index].paginate?.page ?? 1 : 1;
    final response = await sl<MarketplaceRepository>().fetchMarketplaceDiscs(params: params);
    if (isLoader) categories.clear();
    if (response.isEmpty) return _turnOffLoaders(index: index);
    pageNumber == 1 ? categories = response : _updateMarketplaceData(response);
    if (categories.isNotEmpty) unawaited(_marketplacePaginationCheck());
    ApiStatus.instance.marketplace = true;
    if (categories.isNotEmpty) categories[index].paginate?.pageLoader = false;
    _turnOffLoaders(index: index);
  }

  void _updateMarketplaceData(List<MarketplaceCategory> responseList) {
    for (final entry in categories.asMap().entries) {
      final catIndex = entry.key;
      final catItem = entry.value;
      final newIndex = responseList.indexWhere((element) => element.name.toKey == catItem.name.toKey);
      if (newIndex >= 0) {
        final newItem = responseList[newIndex];
        categories[catIndex].salesAds ??= [];
        categories[catIndex].salesAds!.addAll(newItem.discs);
        categories[catIndex].pagination = newItem.pagination;
        final newLength = newItem.discs.length;
        categories[catIndex].paginate?.length = newLength;
        if (newLength >= LENGTH_10) categories[catIndex].paginate?.page = (categories[catIndex].paginate?.page ?? 0) + 1;
      }
    }
  }

  /*void _updateMarketplaceData(List<MarketplaceCategory> responseList) {
    for (final entry in categories.asMap().entries) {
      final catIndex = entry.key;
      final catItem = entry.value;
      final newIndex = responseList.indexWhere((element) => element.name.toKey == catItem.name.toKey);
      if (newIndex >= 0) {
        final newItem = responseList[newIndex];
        categories[catIndex].salesAds ??= [];
        final existingIds = categories[catIndex].salesAds!.map((e) => e.id).toSet();
        final uniqueDiscs = newItem.discs.where((disc) => !existingIds.contains(disc.id)).toList();
        categories[catIndex].salesAds!.addAll(uniqueDiscs);
        categories[catIndex].pagination = newItem.pagination;
        final newLength = newItem.discs.length;
        categories[catIndex].paginate?.length = newLength;
        if (newLength >= LENGTH_10) categories[catIndex].paginate?.page = (categories[catIndex].paginate?.page ?? 0) + 1;
      }
    }
  }*/

  Future<void> _marketplacePaginationCheck() async {
    if (categories.isEmpty) return;
    for (final entry in categories.asMap().entries) {
      final index = entry.key;
      final category = entry.value;
      final scrollController = category.scrollControl;
      final paginate = category.paginate;
      if (scrollController == null || paginate == null) continue;
      if (!scrollController.hasListeners) {
        scrollController.addListener(() {
          final position = scrollController.position;
          final isPosition80 = position.pixels >= position.maxScrollExtent * 0.85;
          if (isPosition80 && paginate.length == LENGTH_10) generateFilterUrl(isPaginate: true, index: index);
        });
      }
    }
  }

  void _stopLoader() {
    loader = Loader(initial: false, common: false);
    notifyListeners();
  }

  void _turnOffLoaders({int index = 0, bool isPopup = false}) {
    if (isPopup) FlushPopup.onInfo(message: 'your_location_is_turned_off'.recast);
    loader = Loader(initial: false, common: false);
    return notifyListeners();
  }

  void onMarketplaceFilter(MarketplaceFilter option) {
    searchKey = '';
    filterOption = option;
    notifyListeners();
    generateFilterUrl(isLoader: true);
  }

  void onTag(Tag item) {
    searchKey = '';
    tag = item;
    notifyListeners();
    generateFilterUrl(isLoader: true);
  }

  void onSearch(String key) {
    searchKey = key;
    filterOption = MarketplaceFilter(types: [], brands: [], tags: []);
    notifyListeners();
    generateFilterUrl(isLoader: true);
  }

  Future<void> onShareSalesAd() async {
    loader.common = true;
    notifyListeners();
    final response = await sl<MarketplaceRepository>().fetchShareSalesAdLink();
    if (response != null) unawaited(shareSalesAdDialog(url: response));
    loader.common = false;
    notifyListeners();
  }

  Future<void> onUpdatePrice(String price, SalesAd marketplace, int index) async {
    loader.common = true;
    notifyListeners();
    final body = {'price': price, 'currency_id': UserPreferences.currency.id};
    final response = await sl<MarketplaceRepository>().updateSalesAdDisc(marketplace.id!, body);
    if (response != null) salesAdDiscs[index] = response;
    if (response != null) ToastPopup.onInfo(message: 'price_updated_successfully'.recast);
    loader.common = false;
    notifyListeners();
  }

  Future<void> onMarkAsSold(Map<String, dynamic> params, SalesAd salesAd, int index) async {
    loader.common = true;
    notifyListeners();
    final response = await sl<MarketplaceRepository>().updateSalesAdDisc(salesAd.id!, params);
    if (response == null) return _stopLoader();
    _removeSalesAdFromMarketplace(salesAd);
    await fetchSalesAdDiscs();
    if (params['sold_through'].toString().toKey == 'capty'.toKey) sl<AppAnalytics>().logEvent(name: 'sold_through_capty');
    ToastPopup.onInfo(message: 'sold_information_updated_successfully'.recast);
    _stopLoader();
  }

  Future<void> onRemoveSalesAd(SalesAd salesAd, int index) async {
    loader.common = true;
    notifyListeners();
    final response = await sl<MarketplaceRepository>().deleteSalesAdDisc(salesAd.id!);
    if (!response) return _stopLoader();
    _removeSalesAdFromMarketplace(salesAd);
    await fetchSalesAdDiscs();
    ToastPopup.onInfo(message: 'disc_deleted_successfully'.recast);
    _stopLoader();
  }

  Future<int?> _fetchMediaId(DocFile docFile) async {
    final base64 = 'data:image/jpeg;base64,${docFile.base64}';
    final mediaBody = {'section': 'disc', 'alt_texts': 'user_disc', 'type': 'image', 'image': base64};
    final response = await sl<UserRepository>().uploadBase64Media(mediaBody);
    return response?.id;
  }

  Future<void> onUpdateSalesAdDisc(SalesAd item, int index, Map<String, dynamic> body, DocFile? docFile) async {
    loader.common = true;
    notifyListeners();
    var mediaId = null as int?;
    mediaId = docFile == null ? item.userDisc?.media?.id : await _fetchMediaId(docFile);
    if (mediaId == null) return _stopLoader();
    final salesAdId = item.id!;
    body.addAll({'media_id': mediaId});
    final response = await sl<MarketplaceRepository>().updateSalesAdDisc(salesAdId, body);
    if (response != null) salesAdDiscs[index] = response;
    _stopLoader();
  }

  void _removeSalesAdFromMarketplace(SalesAd salesAdItem) {
    if (categories.isEmpty) return;
    categories.asMap().forEach((index, category) {
      final discsList = category.discs;
      final adIndex = discsList.indexWhere((element) => element.id == salesAdItem.id);
      if (adIndex >= 0) categories[index].salesAds?.removeAt(adIndex);
    });
    notifyListeners();
  }

  void updateFavStatusInMarketplaceData({required SalesAd item, bool isFav = false}) {
    if (categories.isEmpty) return;
    final isFavorite = isFav ? 1 : 0;
    categories.asMap().forEach((index, category) {
      final discsList = category.discs;
      final adIndex = discsList.indexWhere((element) => element.id == item.id);
      if (adIndex >= 0) categories[index].salesAds?[adIndex].isFavorite = isFavorite;
    });
    notifyListeners();
  }

  void updateFavStatusInFavouriteData({required SalesAd item}) {
    if (favCategories.isEmpty) return;
    favCategories.asMap().forEach((index, category) {
      final discsList = category.discs;
      final adIndex = discsList.indexWhere((element) => element.id == item.id);
      if (adIndex >= 0) favCategories[index].salesAds?.removeAt(adIndex);
    });
    favCategories.removeWhere((element) => element.discs.isEmpty);
    notifyListeners();
  }
}
