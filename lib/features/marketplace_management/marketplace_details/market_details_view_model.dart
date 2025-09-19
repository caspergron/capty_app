import 'dart:async';

import 'package:flutter/cupertino.dart';

import 'package:app/constants/data_constants.dart';
import 'package:app/di.dart';
import 'package:app/libraries/locations.dart';
import 'package:app/models/address/address.dart';
import 'package:app/models/marketplace/club_tournament_info.dart';
import 'package:app/models/marketplace/sales_ad.dart';
import 'package:app/models/system/loader.dart';
import 'package:app/preferences/user_preferences.dart';
import 'package:app/repository/address_repo.dart';
import 'package:app/repository/marketplace_repo.dart';

class MarketDetailsViewModel with ChangeNotifier {
  var marketplace = SalesAd();
  var loader = DEFAULT_LOADER;
  var discList = <SalesAd>[];
  var sellerAddresses = <Address>[];
  var clubTournament = ClubTournamentInfo();
  var isShipping = false;

  Future<void> initViewModel(SalesAd infoItem, bool isDelay) async {
    if (isDelay) {
      loader.common = true;
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 1000));
    }
    marketplace = infoItem;
    notifyListeners();
    final userId = UserPreferences.user.id;
    final sellerUserId = marketplace.sellerInfo?.id;
    unawaited(_fetchDiscDetails());
    if (userId != sellerUserId) unawaited(_fetchMatchedWithSellerInfo());
    if (userId != sellerUserId) unawaited(_fetchSellerAddresses());
    if (userId != sellerUserId) unawaited(_fetchSellerShippingInfo());
    if (userId != sellerUserId) unawaited(_storeDiscPopularity());
    unawaited(_fetchMoreMarketplaceDiscsBySeller());
  }

  void disposeViewModel() {
    loader = DEFAULT_LOADER;
    marketplace = SalesAd();
    discList.clear();
    clubTournament = ClubTournamentInfo();
    sellerAddresses.clear();
    isShipping = false;
  }

  Future<void> _fetchDiscDetails() async {
    final coordinates = await sl<Locations>().fetchLocationPermission();
    final locationParams = '&latitude=${coordinates.lat}&longitude=${coordinates.lng}';
    final params = '${marketplace.id!}$locationParams'.trim();
    final response = await sl<MarketplaceRepository>().fetchMarketplaceDetails(params);
    if (response != null) marketplace = response;
    loader = Loader(initial: false, common: false);
    notifyListeners();
  }

  Future<void> _fetchMatchedWithSellerInfo() async {
    final sellerId = marketplace.sellerInfo?.id;
    final response = await sl<MarketplaceRepository>().fetchMatchedInfoWithSeller(sellerId!);
    if (response != null) clubTournament = response;
    notifyListeners();
  }

  Future<void> _fetchSellerShippingInfo() async {
    final sellerId = marketplace.sellerInfo?.id;
    if (sellerId == null) return;
    final response = await sl<AddressRepository>().fetchShippingInfo(sellerId);
    if (response != null) isShipping = response;
    notifyListeners();
  }

  Future<void> _storeDiscPopularity() async {
    final marketplaceId = marketplace.id;
    if (marketplaceId == null) return;
    await sl<MarketplaceRepository>().storeDiscPopularity(marketplaceId);
  }

  Future<void> _fetchSellerAddresses() async {
    final sellerId = marketplace.sellerInfo?.id;
    final response = await sl<MarketplaceRepository>().fetchSellerAddresses(sellerId!);
    sellerAddresses.clear();
    if (response.isNotEmpty) sellerAddresses = response;
    notifyListeners();
  }

  Future<void> _fetchMoreMarketplaceDiscsBySeller() async {
    final coordinates = await sl<Locations>().fetchLocationPermission();
    final locationParams = '&latitude=${coordinates.lat}&longitude=${coordinates.lng}';
    final params = '${marketplace.sellerInfo!.id!}&size=$LENGTH_20&page=1$locationParams';
    final response = await sl<MarketplaceRepository>().fetchMoreMarketplaceByUser(params);
    discList.clear();
    if (response.isNotEmpty) discList = response.where((item) => marketplace.id != null && item.id != marketplace.id).toList();
    loader = Loader(initial: false, common: false);
    notifyListeners();
  }
}
