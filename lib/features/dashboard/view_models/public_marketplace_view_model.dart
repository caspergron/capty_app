import 'dart:async';

import 'package:flutter/cupertino.dart';

import 'package:app/constants/data_constants.dart';
import 'package:app/di.dart';
import 'package:app/features/dashboard/components/public_sales_ad_info_dialog.dart';
import 'package:app/libraries/locations.dart';
import 'package:app/models/marketplace/marketplace_category.dart';
import 'package:app/models/marketplace/sales_ad.dart';
import 'package:app/models/public/country.dart';
import 'package:app/models/system/loader.dart';
import 'package:app/repository/public_repo.dart';

class PublicMarketplaceViewModel with ChangeNotifier {
  var loader = DEFAULT_LOADER;
  var country = Country();
  var categories = <MarketplaceCategory>[];

  void initViewModel(Country item) {
    country = item;
    notifyListeners();
    _fetchMarketplaceDiscsByCountry(country.id!);
  }

  void disposeViewModel() {
    loader = DEFAULT_LOADER;
    country = Country();
    categories.clear();
  }

  Future<void> _fetchMarketplaceDiscsByCountry(int countryId) async {
    final coordinates = await sl<Locations>().fetchLocationPermission();
    final locationParams = '&latitude=${coordinates.lat}&longitude=${coordinates.lng}';
    // final params = '&page=1&sort_by=country&country_id=$countryId';
    final params = '&page=1&sort_by=country&country_id=$countryId$locationParams'.trim();
    final response = await sl<PublicRepository>().fetchSalesAdsByCountry(params);
    if (response.isNotEmpty) categories = response;
    loader = Loader(initial: false, common: false);
    notifyListeners();
  }

  Future<void> fetchMarketplaceDiscDetails(SalesAd salesAd) async {
    loader.common = true;
    notifyListeners();
    final coordinates = await sl<Locations>().fetchLocationPermission();
    final locationParams = '&latitude=${coordinates.lat}&longitude=${coordinates.lng}';
    final params = '${salesAd.id!}$locationParams'.trim();
    final response = await sl<PublicRepository>().fetchMarketplaceDetails(params);
    if (response != null) unawaited(publicSalesAdInfoDialog(disc: response));
    loader = Loader(initial: false, common: false);
    notifyListeners();
  }
}
