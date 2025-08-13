import 'dart:async';

import 'package:provider/provider.dart';

import 'package:app/constants/app_keys.dart';
import 'package:app/constants/data_constants.dart';
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
    var endpoint = '${ApiUrl.user.tagList}?is_special=$isSpecial';
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    var tagsApi = TagsApi.fromJson(apiResponse.response);
    return tagsApi.tags.haveList ? tagsApi.tags! : [];
  }

  Future<List<Tag>> fetchMarketplaceTags({int isHorizontal = 1}) async {
    var endpoint = '${ApiUrl.user.tagList}?is_horizontal=$isHorizontal';
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    var tagsApi = TagsApi.fromJson(apiResponse.response);
    var tagList = tagsApi.tags ?? [];
    if (tagList.isEmpty) return [];
    var index = tagList.indexWhere((item) => item.name.toKey == 'country'.toKey);
    if (index >= 0) tagList[index].displayName = UserPreferences.user.country?.name ?? 'country'.recast;
    return tagList;
  }

  Future<List<MarketplaceCategory>> fetchMarketplaceDiscs({String params = ''}) async {
    var endpoint = '${ApiUrl.user.marketplaceList}?size=$SALES_AD_LENGTH_05$params';
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    var marketplaceApi = MarketplaceApi.fromJson(apiResponse.response);
    var categories = marketplaceApi.categories ?? [];
    return categories;
  }

  /*Future<List<MarketplaceCategory>> fetchMarketplaceDiscsByCategory({int page = 1}) async {
    var endpoint = '${ApiUrl.user.marketplaceList}?size=$SALES_AD_LENGTH_05&page=$page';
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    var marketplaceApi = MarketplaceApi.fromJson(apiResponse.response);
    return marketplaceApi.categories.haveList ? marketplaceApi.categories! : <MarketplaceCategory>[];
  }*/

  Future<List<SalesAd>> fetchMoreMarketplaceByUser(String params) async {
    var endpoint = '${ApiUrl.user.marketplacesByUser}$params';
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    var salesAdApi = SalesAdApi.fromJson(apiResponse.response);
    return salesAdApi.salesAdList.haveList ? salesAdApi.salesAdList! : [];
  }

  Future<SalesAd?> fetchMarketplaceDetails(int marketplaceId) async {
    var endpoint = '${ApiUrl.user.marketplaceDetails}$marketplaceId';
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return null;
    return SalesAd.fromJson(apiResponse.response['data']);
  }

  Future<List<SalesAd>> searchInMarketplace(String searchKey) async {
    var endpoint = '${ApiUrl.user.searchMarketplace}$searchKey';
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    var salesAdApi = SalesAdApi.fromJson(apiResponse.response);
    return salesAdApi.salesAdList.haveList ? salesAdApi.salesAdList! : [];
  }

  Future<List<SalesAdType>> fetchSalesAdTypes() async {
    var endpoint = ApiUrl.user.salesAdTypes;
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    var salesAdTypeApi = SalesAdTypesApi.fromJson(apiResponse.response);
    return salesAdTypeApi.types.haveList ? salesAdTypeApi.types! : [];
  }

  Future<List<SalesAd>> fetchSalesAdDiscs(String params) async {
    var endpoint = '${ApiUrl.user.salesAdList}$params';
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    var salesAdApi = SalesAdApi.fromJson(apiResponse.response);
    return salesAdApi.salesAdList.haveList ? salesAdApi.salesAdList! : [];
  }

  Future<SalesAd?> createSalesAdDisc(Map<String, dynamic> body) async {
    var context = navigatorKey.currentState!.context;
    var endpoint = ApiUrl.user.createSalesAd;
    var apiResponse = await sl<ApiInterceptor>().postRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) return null;
    unawaited(Provider.of<HomeViewModel>(context, listen: false).fetchDashboardCount());
    await Future.delayed(const Duration(seconds: 4));
    return SalesAd.fromJson(apiResponse.response['data']);
  }

  Future<SalesAd?> updateSalesAdDisc(int salesAdId, Map<String, dynamic> body) async {
    var endpoint = '${ApiUrl.user.updateSalesAd}$salesAdId';
    var apiResponse = await sl<ApiInterceptor>().putRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) return null;
    await Future.delayed(const Duration(seconds: 4));
    ToastPopup.onInfo(message: 'disc_updated_successfully'.recast);
    return SalesAd.fromJson(apiResponse.response['data']);
  }

  Future<bool> deleteSalesAdDisc(int salesAdId) async {
    var context = navigatorKey.currentState!.context;
    var endpoint = '${ApiUrl.user.deleteSalesAd}$salesAdId';
    var apiResponse = await sl<ApiInterceptor>().deleteRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return false;
    unawaited(Provider.of<HomeViewModel>(context, listen: false).fetchDashboardCount());
    return true;
  }

  Future<List<SalesAd>> fetchSalesDiscsByClub(String params) async {
    var endpoint = '${ApiUrl.user.salesDiscByClub}$params';
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    var salesAdApi = SalesAdApi.fromJson(apiResponse.response);
    return salesAdApi.salesAdList.haveList ? salesAdApi.salesAdList! : [];
  }

  Future<String?> fetchShareSalesAdLink() async {
    var endpoint = ApiUrl.user.shareSalesAd;
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return null;
    return apiResponse.response['data']['link'].toString();
  }

  Future<ClubTournamentInfo?> fetchClubTournamentInfo() async {
    var endpoint = ApiUrl.user.clubTournamentInfo;
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return null;
    return ClubTournamentInfo.fromJson(apiResponse.response['data']);
  }

  Future<ClubTournamentInfo?> fetchMatchedInfoWithSeller(int sellerId) async {
    var endpoint = '${ApiUrl.user.matchedInfoWithSeller}$sellerId';
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return null;
    return ClubTournamentInfo.fromJson(apiResponse.response['data']);
  }

  Future<List<Address>> fetchSellerAddresses(int sellerId) async {
    var endpoint = '${ApiUrl.user.addressList}?user_id=$sellerId';
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    var addressesApi = AddressApi.fromJson(apiResponse.response);
    return addressesApi.addresses.haveList ? addressesApi.addresses! : [];
  }

  Future<bool> storeDiscPopularity(int salesAdId) async {
    var endpoint = ApiUrl.user.popularityCount;
    var body = {'sales_ad_id': salesAdId};
    var apiResponse = await sl<ApiInterceptor>().postRequest(endpoint: endpoint, body: body);
    return apiResponse.status == 200;
  }
}
