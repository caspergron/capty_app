import 'dart:async';

import 'package:provider/provider.dart';

import 'package:app/constants/app_keys.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/home/home_view_model.dart';
import 'package:app/interfaces/api_interceptor.dart';
import 'package:app/libraries/flush_popup.dart';
import 'package:app/libraries/toasts_popups.dart';
import 'package:app/models/disc/disc_api.dart';
import 'package:app/models/disc/parent_disc.dart';
import 'package:app/models/disc/parent_disc_category.dart';
import 'package:app/models/disc/parent_disc_category_api.dart';
import 'package:app/models/disc/user_disc.dart';
import 'package:app/models/disc/wishlist.dart';
import 'package:app/models/disc/wishlist_api.dart';
import 'package:app/models/plastic/plastic.dart';
import 'package:app/models/plastic/plastic_api.dart';
import 'package:app/services/app_analytics.dart';
import 'package:app/utils/api_url.dart';

class DiscRepository {
  Future<List<ParentDisc>> fetchParentDiscs({int page = 1, bool isWishlistSearch = false}) async {
    var endpoint = '${ApiUrl.user.discList}&page=$page';
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    var discsApi = DiscApi.fromJson(apiResponse.response);
    var discs = discsApi.discs.haveList ? discsApi.discs! : <ParentDisc>[];
    if (isWishlistSearch == false) return discs;
    if (discs.isEmpty) return discs;
    return discs.where((item) => item.is_wishListed == false).toList();
  }

  Future<List<ParentDiscCategory>> fetchParentDiscsByCategory({int page = 1, bool isWishlistSearch = false}) async {
    var endpoint = '${ApiUrl.user.discListByCategory}$page';
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    var discCategoriesApi = ParentDiscCategoryApi.fromJson(apiResponse.response);
    var categories = discCategoriesApi.categories ?? [];
    if (categories.isEmpty) return [];
    if (isWishlistSearch == false) return categories;
    List<ParentDiscCategory> filteredCategories = [];
    for (var category in categories) {
      if (category.discs.isEmpty) continue;
      var unWishListedDiscs = category.discs.where((disc) => disc.is_wishListed == false).toList();
      filteredCategories.add(category.copyWith(parentDiscs: unWishListedDiscs));
    }
    return filteredCategories;
  }

  Future<List<ParentDisc>> searchDiscByName({required Map<String, dynamic> body, bool isWishlistSearch = false}) async {
    var endpoint = ApiUrl.user.searchDiscs;
    var apiResponse = await sl<ApiInterceptor>().postRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) return [];
    var discsApi = DiscApi.fromJson(apiResponse.response);
    var discs = discsApi.discs.haveList ? discsApi.discs! : <ParentDisc>[];
    if (isWishlistSearch == false) return discs;
    if (discs.isEmpty) return discs;
    return discs.where((item) => item.is_wishListed == false).toList();
  }

  Future<List<Plastic>> plasticsByDiscBrandId(int brandId) async {
    var endpoint = '${ApiUrl.user.plasticByDiscId}$brandId';
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    var plasticsApi = PlasticApi.fromJson(apiResponse.response);
    return plasticsApi.plastics.haveList ? plasticsApi.plastics! : [];
  }

  Future<UserDisc?> createUserDisc(Map<String, dynamic> body) async {
    var context = navigatorKey.currentState!.context;
    var endpoint = ApiUrl.user.createUserDisc;
    var apiResponse = await sl<ApiInterceptor>().postRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) return null;
    unawaited(Provider.of<HomeViewModel>(context, listen: false).fetchDashboardCount());
    ToastPopup.onInfo(message: 'disc_created_successfully'.recast);
    return UserDisc.fromJson(apiResponse.response['data']);
  }

  Future<UserDisc?> updateUserDisc(int discId, Map<String, dynamic> body, {bool isFlash = false}) async {
    var endpoint = '${ApiUrl.user.updateUserDisc}$discId';
    var apiResponse = await sl<ApiInterceptor>().putRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) return null;
    if (isFlash) FlushPopup.onInfo(message: 'disc_update_successfully'.recast);
    return UserDisc.fromJson(apiResponse.response['data']);
  }

  Future<UserDisc?> fetchUserDiscDetails(int discId) async {
    var endpoint = '${ApiUrl.user.UserDiscDetails}$discId';
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return null;
    return UserDisc.fromJson(apiResponse.response['data']);
  }

  Future<bool> deleteUserDisc(int discId) async {
    var context = navigatorKey.currentState!.context;
    var endpoint = '${ApiUrl.user.deleteUserDisc}$discId';
    var apiResponse = await sl<ApiInterceptor>().deleteRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return false;
    FlushPopup.onInfo(message: 'disc_deleted_successfully'.recast);
    unawaited(Provider.of<HomeViewModel>(context, listen: false).fetchDashboardCount());
    return true;
  }

  Future<List<Wishlist>> fetchWishlistDiscs() async {
    var endpoint = ApiUrl.user.wishlistDiscs;
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    var wishlistApi = WishlistApi.fromJson(apiResponse.response);
    return wishlistApi.wishlists.haveList ? wishlistApi.wishlists! : [];
  }

  Future<int?> addToWishlist(Map<String, dynamic> body) async {
    var endpoint = ApiUrl.user.createWishlist;
    var apiResponse = await sl<ApiInterceptor>().postRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) return null;
    var params = {'wishlist_id': apiResponse.response['data']['id']};
    sl<AppAnalytics>().logEvent(name: 'created_wishlist_disc', parameters: params);
    return apiResponse.response['data']['id'];
  }

  Future<bool> removeFromWishlist(int wishlistId) async {
    var endpoint = '${ApiUrl.user.removeWishlist}$wishlistId';
    var apiResponse = await sl<ApiInterceptor>().deleteRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return false;
    FlushPopup.onInfo(message: 'removed_successfully_from_wishlist'.recast);
    return true;
  }

  Future<Wishlist?> updateWishlistDisc(Map<String, dynamic> body) async {
    var endpoint = ApiUrl.user.updateWishlistDisc;
    var apiResponse = await sl<ApiInterceptor>().putRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) return null;
    return Wishlist.fromJson(apiResponse.response['data']);
  }

  Future<Wishlist?> addAndUpdateWishlistDisc(Map<String, dynamic> body) async {
    var endpoint = ApiUrl.user.updateWishlistDisc;
    var apiResponse = await sl<ApiInterceptor>().putRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) return null;
    return Wishlist.fromJson(apiResponse.response['data']);
  }

  Future<Wishlist?> createWishlistWithUserDisc(Map<String, dynamic> body) async {
    var endpoint = ApiUrl.user.createWishlistWithUserDisc;
    var apiResponse = await sl<ApiInterceptor>().postRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) return null;
    return Wishlist.fromJson(apiResponse.response['data']);
  }

  Future<bool> requestDisc(Map<String, dynamic> body) async {
    var endpoint = ApiUrl.user.requestDisc;
    var apiResponse = await sl<ApiInterceptor>().postRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) return false;
    return true;
  }
}
