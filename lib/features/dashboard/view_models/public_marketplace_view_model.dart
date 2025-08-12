import 'package:flutter/cupertino.dart';

import 'package:app/constants/data_constants.dart';
import 'package:app/di.dart';
import 'package:app/models/marketplace/marketplace_category.dart';
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
    // var coordinates = await sl<Locations>().fetchLocationPermission();
    // print('_fetchMarketplaceDiscsByCountry 1: ${coordinates.toJson()}');
    // var locationParams = '&latitude=${coordinates.lat}&longitude=${coordinates.lng}';
    // var params = '&page=1&country_id=$countryId$locationParams';
    var params = '&page=1&country_id=$countryId';
    var response = await sl<PublicRepository>().fetchSalesAdsByCountry(params);
    if (response.isNotEmpty) categories = response;
    loader = Loader(initial: false, common: false);
    notifyListeners();
  }
}
