import 'dart:async';

import 'package:app/constants/data_constants.dart';
import 'package:app/di.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/marketplace/components/share_sales_ad_dialog.dart';
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
import 'package:app/preferences/user_preferences.dart';
import 'package:app/repository/marketplace_repo.dart';
import 'package:app/repository/user_repo.dart';
import 'package:app/services/api_status.dart';
import 'package:app/services/app_analytics.dart';
import 'package:flutter/cupertino.dart';

class MarketplaceViewModel with ChangeNotifier {
  var loader = DEFAULT_LOADER;
  var tag = Tag();
  var tags = <Tag>[];
  var salesAdDiscs = <SalesAd>[];
  var categories = <MarketplaceCategory>[];
  var clubTournament = ClubTournamentInfo();
  var filterOption = MarketplaceFilter(types: [], brands: [], tags: []);

  Future<void> initViewModel() async {
    unawaited(_fetchClubTournamentsInfo());
    if (ApiStatus.instance.marketplace) return;
    unawaited(fetchTags());
    unawaited(fetchSalesAdDiscs());
    await fetchMarketplaceDiscs(isLoader: true);
  }

  void updateUi() => notifyListeners();

  void clearStates() {
    loader = DEFAULT_LOADER;
    tag = Tag();
    tags.clear();
    salesAdDiscs.clear();
    categories.clear();
    filterOption = MarketplaceFilter();
  }

  Future<void> _fetchClubTournamentsInfo() async {
    var response = await sl<MarketplaceRepository>().fetchClubTournamentInfo();
    if (response != null) clubTournament = response;
    notifyListeners();
  }

  Future<void> fetchTags() async {
    var tagResponse = await sl<MarketplaceRepository>().fetchMarketplaceTags();
    if (tagResponse.isNotEmpty) tags = tagResponse;
    if (tags.isNotEmpty) tag = tags.first;
    notifyListeners();
  }

  Future<void> fetchSalesAdDiscs() async {
    var params = '&page=1';
    var response = await sl<MarketplaceRepository>().fetchSalesAdDiscs(params);
    salesAdDiscs.clear();
    if (response.isNotEmpty) salesAdDiscs = response;
    notifyListeners();
  }

  Future<void> fetchMarketplaceDiscs({bool isLoader = false, bool isPaginate = false, String filterParams = '', int index = 0}) async {
    var invalidApiCall = categories.isNotEmpty && categories[index].is_page_loader;
    if (invalidApiCall) return;
    loader.common = isLoader;
    if (categories.isNotEmpty) categories[index].paginate?.pageLoader = isPaginate;
    notifyListeners();
    var params = '';
    var coordinates = await sl<Locations>().fetchLocationPermission();
    var locationParams = '&latitude=${coordinates.lat}&longitude=${coordinates.lng}';
    var pageNumber = categories.isNotEmpty && isPaginate ? categories[index].paginate?.page ?? 1 : 1;
    if (tag.id == null) {
      params = '&page=$pageNumber$locationParams$filterParams'.trim();
    } else if (tag.name.toKey == 'all'.toKey) {
      params = '&page=$pageNumber$locationParams$filterParams'.trim();
    } else if (tag.name.toKey == 'country'.toKey) {
      var countryId = UserPreferences.user.countryId;
      params = '&page=$pageNumber&sort_by=${tag.name.toKey}&country_id=$countryId$locationParams$filterParams'.trim();
    } else if (tag.name.toKey == 'club'.toKey || tag.name.toKey == 'tournament'.toKey) {
      params = '&page=$pageNumber&sort_by=${tag.name.toKey}$locationParams$filterParams'.trim();
    } else if (tag.name.toKey == 'distance'.toKey) {
      if (!coordinates.is_coordinate) return _turnOffLoaders(index: index, isPopup: true);
      params = '&page=$pageNumber&sort_by=${tag.name.toKey}&distance=${tag.value.nullToInt}$locationParams$filterParams'.trim();
    } else {
      params = '&page=$pageNumber$locationParams$filterParams'.trim();
    }
    var response = await sl<MarketplaceRepository>().fetchMarketplaceDiscs(params: params);
    if (isLoader) categories.clear();
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
          categories[catIndex].salesAds ??= [];
          categories[catIndex].salesAds!.addAll(newItem.discs);
          categories[catIndex].pagination = newItem.pagination;
          var newLength = newItem.discs.length;
          categories[catIndex].paginate?.length = newLength;
          if (newLength >= SALES_AD_LENGTH_05) categories[catIndex].paginate?.page = (categories[catIndex].paginate?.page ?? 0) + 1;
        }
      }
    }
    if (categories.isNotEmpty) unawaited(_paginationCheck());
    ApiStatus.instance.marketplace = true;
    _turnOffLoaders(index: index);
  }

  void _turnOffLoaders({int index = 0, bool isPopup = false}) {
    if (isPopup) FlushPopup.onInfo(message: 'your_location_is_turned_off'.recast);
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
          if (maxPosition && paginate.length == SALES_AD_LENGTH_05) fetchMarketplaceDiscs(isPaginate: true, index: index);
        });
      }
    }
  }

  void onMarketplaceFilter(MarketplaceFilter option, String filterParams) {
    filterOption = option;
    notifyListeners();
    fetchMarketplaceDiscs(isLoader: true, filterParams: filterParams);
  }

  void onTag(Tag item) {
    tag = item;
    notifyListeners();
    fetchMarketplaceDiscs(isLoader: true);
  }

  Future<void> onShareSalesAd() async {
    loader.common = true;
    notifyListeners();
    var response = await sl<MarketplaceRepository>().fetchShareSalesAdLink();
    if (response != null) unawaited(shareSalesAdDialog(url: response));
    loader.common = false;
    notifyListeners();
  }

  Future<void> onUpdatePrice(String price, SalesAd marketplace, int index) async {
    loader.common = true;
    notifyListeners();
    var body = {'price': price, 'currency_id': UserPreferences.currency.id};
    var response = await sl<MarketplaceRepository>().updateSalesAdDisc(marketplace.id!, body);
    if (response != null) salesAdDiscs[index] = response;
    if (response != null) ToastPopup.onInfo(message: 'price_updated_successfully'.recast);
    loader.common = false;
    notifyListeners();
  }

  Future<void> onMarkAsSold(Map<String, dynamic> params, SalesAd salesAd, int index) async {
    loader.common = true;
    notifyListeners();
    var response = await sl<MarketplaceRepository>().updateSalesAdDisc(salesAd.id!, params);
    if (response != null) {
      _removeSalesAdFromMarketplace(salesAd);
      await fetchSalesAdDiscs();
      if (params['sold_through'].toString().toKey == 'capty'.toKey) sl<AppAnalytics>().logEvent(name: 'sold_through_capty');
      ToastPopup.onInfo(message: 'sold_information_updated_successfully'.recast);
    }
    loader.common = false;
    notifyListeners();
  }

  Future<void> onRemoveSalesAd(SalesAd salesAd, int index) async {
    loader.common = true;
    notifyListeners();
    var response = await sl<MarketplaceRepository>().deleteSalesAdDisc(salesAd.id!);
    if (response) {
      _removeSalesAdFromMarketplace(salesAd);
      await fetchSalesAdDiscs();
      ToastPopup.onInfo(message: 'disc_deleted_successfully'.recast);
    }
    loader.common = false;
    notifyListeners();
  }

  Future<int?> _fetchMediaId(DocFile docFile) async {
    var base64 = 'data:image/jpeg;base64,${docFile.base64}';
    var mediaBody = {'section': 'disc', 'alt_texts': 'user_disc', 'type': 'image', 'image': base64};
    var response = await sl<UserRepository>().uploadBase64Media(mediaBody);
    return response?.id;
  }

  Future<void> onUpdateSalesAdDisc(SalesAd item, int index, Map<String, dynamic> body, DocFile? docFile) async {
    loader.common = true;
    notifyListeners();
    var mediaId = null as int?;
    if (docFile == null) {
      mediaId = item.userDisc?.media?.id;
    } else {
      mediaId = await _fetchMediaId(docFile);
    }
    if (mediaId == null) {
      loader.common = false;
      return notifyListeners();
    }
    var salesAdId = item.id!;
    body.addAll({'media_id': mediaId});
    var response = await sl<MarketplaceRepository>().updateSalesAdDisc(salesAdId, body);
    if (response != null) salesAdDiscs[index] = response;
    loader.common = false;
    notifyListeners();
  }

  void _removeSalesAdFromMarketplace(SalesAd salesAdItem) {
    if (categories.isEmpty) return;
    categories.asMap().forEach((index, category) {
      var discsList = category.discs;
      var adIndex = discsList.indexWhere((element) => element.id == salesAdItem.id);
      if (adIndex >= 0) categories[index].salesAds?.removeAt(adIndex);
    });
    notifyListeners();
  }
}
