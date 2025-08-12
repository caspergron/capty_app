import 'dart:async';

import 'package:app/constants/data_constants.dart';
import 'package:app/di.dart';
import 'package:app/libraries/locations.dart';
import 'package:app/models/address/address.dart';
import 'package:app/models/marketplace/club_tournament_info.dart';
import 'package:app/models/marketplace/sales_ad.dart';
import 'package:app/models/system/loader.dart';
import 'package:app/preferences/user_preferences.dart';
import 'package:app/repository/marketplace_repo.dart';
import 'package:flutter/cupertino.dart';

class MarketDetailsViewModel with ChangeNotifier {
  var marketplace = SalesAd();
  var loader = DEFAULT_LOADER;
  var discList = <SalesAd>[];
  var sellerAddresses = <Address>[];
  var clubTournament = ClubTournamentInfo();

  Future<void> initViewModel(SalesAd infoItem, bool isDelay) async {
    if (isDelay) {
      loader.common = true;
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 1000));
    }
    marketplace = infoItem;
    notifyListeners();
    var userId = UserPreferences.user.id;
    var sellerUserId = marketplace.sellerInfo?.id;
    unawaited(_fetchDiscDetails());
    if (userId != sellerUserId) unawaited(_fetchMatchedWithSellerInfo());
    if (userId != sellerUserId) unawaited(_fetchSellerAddresses());
    unawaited(_fetchMoreMarketplaceDiscsBySeller());
  }

  void disposeViewModel() {
    loader = DEFAULT_LOADER;
    marketplace = SalesAd();
    discList.clear();
    clubTournament = ClubTournamentInfo();
    sellerAddresses.clear();
  }

  Future<void> _fetchDiscDetails() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    // var response = await sl<MarketplaceRepository>().fetchMarketplaceDetails(marketplace.id!);
    // if (response != null) marketplace = response;
    notifyListeners();
  }

  Future<void> _fetchMatchedWithSellerInfo() async {
    var sellerId = marketplace.sellerInfo?.id;
    var response = await sl<MarketplaceRepository>().fetchMatchedInfoWithSeller(sellerId!);
    if (response != null) clubTournament = response;
    notifyListeners();
  }

  Future<void> _fetchSellerAddresses() async {
    var sellerId = marketplace.sellerInfo?.id;
    var response = await sl<MarketplaceRepository>().fetchSellerAddresses(sellerId!);
    sellerAddresses.clear();
    if (response.isNotEmpty) sellerAddresses = response;
    notifyListeners();
  }

  Future<void> _fetchMoreMarketplaceDiscsBySeller() async {
    var coordinates = await sl<Locations>().fetchLocationPermission();
    var locationParams = '&latitude=${coordinates.lat}&longitude=${coordinates.lng}';
    var params = '${marketplace.userId!}$locationParams';
    var response = await sl<MarketplaceRepository>().fetchMoreMarketplaceByUser(params);
    discList.clear();
    if (response.isNotEmpty) discList = response.where((item) => marketplace.id != null && item.id != marketplace.id).toList();
    loader = Loader(initial: false, common: false);
    notifyListeners();
  }
}
