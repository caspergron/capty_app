import 'dart:async';

import 'package:provider/provider.dart';

import 'package:app/constants/app_keys.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/home/home_view_model.dart';
import 'package:app/interfaces/api_interceptor.dart';
import 'package:app/libraries/toasts_popups.dart';
import 'package:app/models/address/address.dart';
import 'package:app/models/address/address_api.dart';
import 'package:app/models/common/sales_ad_type.dart';
import 'package:app/models/common/sales_ad_types_api.dart';
import 'package:app/models/common/tag.dart';
import 'package:app/models/common/tags_api.dart';
import 'package:app/models/marketplace/club_tournament_info.dart';
import 'package:app/models/marketplace/marketplace_api.dart';
import 'package:app/models/marketplace/marketplace_category.dart';
import 'package:app/models/marketplace/sales_ad.dart';
import 'package:app/models/marketplace/sales_ad_api.dart';
import 'package:app/preferences/user_preferences.dart';
import 'package:app/utils/api_url.dart';

class MarketplaceRepository {
  Future<List<Tag>> fetchSpecialityDiscMenus({int isSpecial = 1}) async {
    final endpoint = '${ApiUrl.user.tagList}?is_special=$isSpecial';
    final apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    final tagsApi = TagsApi.fromJson(apiResponse.response);
    return tagsApi.tags.haveList ? tagsApi.tags! : [];
  }

  Future<List<Tag>> fetchMarketplaceTags({int isHorizontal = 1}) async {
    final endpoint = '${ApiUrl.user.tagList}?is_horizontal=$isHorizontal';
    final apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    final tagsApi = TagsApi.fromJson(apiResponse.response);
    final tagList = tagsApi.tags ?? [];
    if (tagList.isEmpty) return [];
    final index = tagList.indexWhere((item) => item.name.toKey == 'country'.toKey);
    if (index >= 0) tagList[index].displayName = UserPreferences.user.country?.name ?? 'country'.recast;
    return tagList;
  }

  Future<List<MarketplaceCategory>> fetchMarketplaceDiscs({String params = ''}) async {
    final endpoint = '${ApiUrl.user.marketplaceList}$params';
    final apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    final marketplaceApi = MarketplaceApi.fromJson(apiResponse.response);
    final categories = marketplaceApi.categories ?? [];
    return categories;
  }

  /*Future<List<MarketplaceCategory>> fetchMarketplaceDiscsByCategory({int page = 1}) async {
    final endpoint = '${ApiUrl.user.marketplaceList}?size=$LENGTH_08&page=$page';
    final apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    final marketplaceApi = MarketplaceApi.fromJson(apiResponse.response);
    return marketplaceApi.categories.haveList ? marketplaceApi.categories! : <MarketplaceCategory>[];
  }*/

  Future<List<SalesAd>> fetchMoreMarketplaceByUser(String params) async {
    final endpoint = '${ApiUrl.user.marketplacesByUser}$params';
    final apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    final salesAdApi = SalesAdApi.fromJson(apiResponse.response);
    return salesAdApi.salesAdList.haveList ? salesAdApi.salesAdList! : [];
  }

  Future<SalesAd?> fetchMarketplaceDetails(String params) async {
    final endpoint = '${ApiUrl.user.marketplaceDetails}$params';
    final apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return null;
    return SalesAd.fromJson(apiResponse.response['data']);
  }

  Future<List<SalesAd>> searchInMarketplace(String searchKey) async {
    final endpoint = '${ApiUrl.user.searchMarketplace}$searchKey';
    final apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    final salesAdApi = SalesAdApi.fromJson(apiResponse.response);
    return salesAdApi.salesAdList.haveList ? salesAdApi.salesAdList! : [];
  }

  Future<List<SalesAdType>> fetchSalesAdTypes() async {
    final endpoint = ApiUrl.user.salesAdTypes;
    final apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    final salesAdTypeApi = SalesAdTypesApi.fromJson(apiResponse.response);
    return salesAdTypeApi.types.haveList ? salesAdTypeApi.types! : [];
  }

  Future<List<SalesAd>> fetchSalesAdDiscs(String params) async {
    final endpoint = '${ApiUrl.user.salesAdList}$params';
    final apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    final salesAdApi = SalesAdApi.fromJson(apiResponse.response);
    // final salesAdList = salesAdApi.salesAdList ?? [];
    // if (salesAdList.isEmpty) return [];
    // final seenIds = <int>{};
    // return salesAdList.where((ad) => seenIds.add(ad.id.nullToInt)).toList();
    return salesAdApi.salesAdList.haveList ? salesAdApi.salesAdList! : [];
  }

  Future<SalesAd?> createSalesAdDisc(Map<String, dynamic> body) async {
    final context = navigatorKey.currentState!.context;
    final endpoint = ApiUrl.user.createSalesAd;
    final apiResponse = await sl<ApiInterceptor>().postRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) return null;
    unawaited(Provider.of<HomeViewModel>(context, listen: false).fetchDashboardCount());
    return SalesAd.fromJson(apiResponse.response['data']);
  }

  Future<SalesAd?> updateSalesAdDisc(int salesAdId, Map<String, dynamic> body) async {
    final endpoint = '${ApiUrl.user.updateSalesAd}$salesAdId';
    final apiResponse = await sl<ApiInterceptor>().putRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) return null;
    ToastPopup.onInfo(message: 'disc_updated_successfully'.recast);
    return SalesAd.fromJson(apiResponse.response['data']);
  }

  Future<bool> deleteSalesAdDisc(int salesAdId) async {
    final context = navigatorKey.currentState!.context;
    final endpoint = '${ApiUrl.user.deleteSalesAd}$salesAdId';
    final apiResponse = await sl<ApiInterceptor>().deleteRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return false;
    unawaited(Provider.of<HomeViewModel>(context, listen: false).fetchDashboardCount());
    return true;
  }

  Future<List<SalesAd>> fetchSalesDiscsByClub(String params) async {
    final endpoint = '${ApiUrl.user.salesDiscByClub}$params';
    final apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    final salesAdApi = SalesAdApi.fromJson(apiResponse.response);
    return salesAdApi.salesAdList.haveList ? salesAdApi.salesAdList! : [];
  }

  Future<String?> fetchShareSalesAdLink() async {
    final endpoint = ApiUrl.user.shareSalesAd;
    final apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return null;
    return apiResponse.response['data']['link'].toString();
  }

  Future<ClubTournamentInfo?> fetchClubTournamentInfo() async {
    final endpoint = ApiUrl.user.clubTournamentInfo;
    final apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return null;
    return ClubTournamentInfo.fromJson(apiResponse.response['data']);
  }

  Future<ClubTournamentInfo?> fetchMatchedInfoWithSeller(int sellerId) async {
    final endpoint = '${ApiUrl.user.matchedInfoWithSeller}$sellerId';
    final apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return null;
    return ClubTournamentInfo.fromJson(apiResponse.response['data']);
  }

  Future<List<Address>> fetchSellerAddresses(int sellerId) async {
    final endpoint = '${ApiUrl.user.addressList}?user_id=$sellerId';
    final apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    final addressesApi = AddressApi.fromJson(apiResponse.response);
    return addressesApi.addresses.haveList ? addressesApi.addresses! : [];
  }

  Future<bool> storeDiscPopularity(int salesAdId) async {
    final endpoint = ApiUrl.user.popularityCount;
    final body = {'sales_ad_id': salesAdId};
    final apiResponse = await sl<ApiInterceptor>().postRequest(endpoint: endpoint, body: body);
    return apiResponse.status == 200;
  }

  Future<List<MarketplaceCategory>> fetchMarketplaceFavourites(String params) async {
    final endpoint = '${ApiUrl.user.marketplaceFavouriteList}$params';
    final apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    final marketplaceApi = MarketplaceApi.fromJson(apiResponse.response);
    final categories = marketplaceApi.categories ?? [];
    return categories;
  }

  Future<bool> setMarketplaceDiscAsFavourite(Map<String, dynamic> body) async {
    final endpoint = ApiUrl.user.setMarketplaceDiscAsFavourite;
    final apiResponse = await sl<ApiInterceptor>().postRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) return false;
    return true;
  }

  Future<bool> removeMarketplaceDiscFromFavourite(int salesAdId) async {
    final endpoint = '${ApiUrl.user.RemoveMarketplaceDiscFromFavourite}$salesAdId';
    final apiResponse = await sl<ApiInterceptor>().deleteRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return false;
    return true;
  }
}
