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
    final endpoint = '${ApiUrl.user.discList}&page=$page';
    final apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    final discsApi = DiscApi.fromJson(apiResponse.response);
    final discs = discsApi.discs.haveList ? discsApi.discs! : <ParentDisc>[];
    if (isWishlistSearch == false) return discs;
    if (discs.isEmpty) return discs;
    return discs.where((item) => item.is_wishListed == false).toList();
  }

  Future<List<ParentDiscCategory>> fetchParentDiscsByCategory({int page = 1, bool isWishlistSearch = false}) async {
    final endpoint = '${ApiUrl.user.discListByCategory}$page';
    final apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    final discCategoriesApi = ParentDiscCategoryApi.fromJson(apiResponse.response);
    final categories = discCategoriesApi.categories ?? [];
    if (categories.isEmpty) return [];
    if (isWishlistSearch == false) return categories;
    List<ParentDiscCategory> filteredCategories = [];
    for (final category in categories) {
      if (category.discs.isEmpty) continue;
      final unWishListedDiscs = category.discs.where((disc) => disc.is_wishListed == false).toList();
      filteredCategories.add(category.copyWith(parentDiscs: unWishListedDiscs));
    }
    return filteredCategories;
  }

  Future<List<ParentDisc>> searchDiscByName({required Map<String, dynamic> body, bool isWishlistSearch = false}) async {
    final endpoint = ApiUrl.user.searchDiscs;
    final apiResponse = await sl<ApiInterceptor>().postRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) return [];
    final discsApi = DiscApi.fromJson(apiResponse.response);
    final discs = discsApi.discs.haveList ? discsApi.discs! : <ParentDisc>[];
    if (isWishlistSearch == false) return discs;
    if (discs.isEmpty) return discs;
    return discs.where((item) => item.is_wishListed == false).toList();
  }

  Future<List<Plastic>> plasticsByDiscBrandId(int brandId) async {
    final endpoint = '${ApiUrl.user.plasticByDiscId}$brandId';
    final apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    final plasticsApi = PlasticApi.fromJson(apiResponse.response);
    return plasticsApi.plastics.haveList ? plasticsApi.plastics! : [];
  }

  Future<UserDisc?> createUserDisc(Map<String, dynamic> body) async {
    final context = navigatorKey.currentState!.context;
    final endpoint = ApiUrl.user.createUserDisc;
    final apiResponse = await sl<ApiInterceptor>().postRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) return null;
    unawaited(Provider.of<HomeViewModel>(context, listen: false).fetchDashboardCount());
    ToastPopup.onInfo(message: 'disc_created_successfully'.recast);
    return UserDisc.fromJson(apiResponse.response['data']);
  }

  Future<UserDisc?> updateUserDisc(int discId, Map<String, dynamic> body, {bool isFlash = false}) async {
    final endpoint = '${ApiUrl.user.updateUserDisc}$discId';
    final apiResponse = await sl<ApiInterceptor>().putRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) return null;
    if (isFlash) FlushPopup.onInfo(message: 'disc_update_successfully'.recast);
    return UserDisc.fromJson(apiResponse.response['data']);
  }

  Future<UserDisc?> fetchUserDiscDetails(int discId) async {
    final endpoint = '${ApiUrl.user.UserDiscDetails}$discId';
    final apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return null;
    return UserDisc.fromJson(apiResponse.response['data']);
  }

  Future<bool> deleteUserDisc(int discId) async {
    final context = navigatorKey.currentState!.context;
    final endpoint = '${ApiUrl.user.deleteUserDisc}$discId';
    final apiResponse = await sl<ApiInterceptor>().deleteRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return false;
    FlushPopup.onInfo(message: 'disc_deleted_successfully'.recast);
    unawaited(Provider.of<HomeViewModel>(context, listen: false).fetchDashboardCount());
    return true;
  }

  Future<List<Wishlist>> fetchWishlistDiscs() async {
    final endpoint = ApiUrl.user.wishlistDiscs;
    final apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    final wishlistApi = WishlistApi.fromJson(apiResponse.response);
    return wishlistApi.wishlists.haveList ? wishlistApi.wishlists! : [];
  }

  Future<int?> addToWishlist(Map<String, dynamic> body) async {
    final endpoint = ApiUrl.user.createWishlist;
    final apiResponse = await sl<ApiInterceptor>().postRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) return null;
    final params = {'wishlist_id': apiResponse.response['data']['id']};
    sl<AppAnalytics>().logEvent(name: 'created_wishlist_disc', parameters: params);
    return apiResponse.response['data']['id'];
  }

  Future<bool> removeFromWishlist(int wishlistId) async {
    final endpoint = '${ApiUrl.user.removeWishlist}$wishlistId';
    final apiResponse = await sl<ApiInterceptor>().deleteRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return false;
    FlushPopup.onInfo(message: 'removed_successfully_from_wishlist'.recast);
    return true;
  }

  Future<Wishlist?> updateWishlistDisc(Map<String, dynamic> body) async {
    final endpoint = ApiUrl.user.updateWishlistDisc;
    final apiResponse = await sl<ApiInterceptor>().putRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) return null;
    return Wishlist.fromJson(apiResponse.response['data']);
  }

  Future<Wishlist?> addAndUpdateWishlistDisc(Map<String, dynamic> body) async {
    final endpoint = ApiUrl.user.updateWishlistDisc;
    final apiResponse = await sl<ApiInterceptor>().putRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) return null;
    return Wishlist.fromJson(apiResponse.response['data']);
  }

  Future<Wishlist?> createWishlistWithUserDisc(Map<String, dynamic> body) async {
    final endpoint = ApiUrl.user.createWishlistWithUserDisc;
    final apiResponse = await sl<ApiInterceptor>().postRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) return null;
    return Wishlist.fromJson(apiResponse.response['data']);
  }

  Future<bool> requestDisc(Map<String, dynamic> body) async {
    final endpoint = ApiUrl.user.requestDisc;
    final apiResponse = await sl<ApiInterceptor>().postRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) return false;
    return true;
  }
}
