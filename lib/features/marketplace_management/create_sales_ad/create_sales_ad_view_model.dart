import 'dart:async';

import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';

import 'package:app/constants/app_keys.dart';
import 'package:app/constants/data_constants.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/club/view_models/club_view_model.dart';
import 'package:app/features/disc_management/discs/discs_view_model.dart';
import 'package:app/features/marketplace_management/create_sales_ad/components/add_home_address_dialog.dart';
import 'package:app/features/marketplace_management/marketplace/marketplace_view_model.dart';
import 'package:app/features/player/view_models/tournament_discs_view_model.dart';
import 'package:app/libraries/toasts_popups.dart';
import 'package:app/models/address/address.dart';
import 'package:app/models/common/sales_ad_type.dart';
import 'package:app/models/common/tag.dart';
import 'package:app/models/disc/user_disc.dart';
import 'package:app/models/plastic/plastic.dart';
import 'package:app/models/system/doc_file.dart';
import 'package:app/models/system/loader.dart';
import 'package:app/preferences/app_preferences.dart';
import 'package:app/preferences/user_preferences.dart';
import 'package:app/repository/address_repo.dart';
import 'package:app/repository/disc_repo.dart';
import 'package:app/repository/marketplace_repo.dart';
import 'package:app/repository/user_repo.dart';
import 'package:app/services/app_analytics.dart';
import 'package:app/services/routes.dart';

class CreateSalesAdViewModel with ChangeNotifier {
  var step = 1;
  var userDisc = UserDisc();
  var loader = DEFAULT_LOADER;
  var isEditDetails = false;
  var address = Address();
  // var discType = DISC_TYPES_LIST.first;
  var usedValue = 10.0;
  var specialTags = <Tag>[];
  var discFile = DocFile();
  var plastic = Plastic();
  var plastics = <Plastic>[];
  var salesAdTypeId = 1;
  // var isShipping = false;

  void initViewModel(UserDisc item) {
    clearStates();
    userDisc = item;
    notifyListeners();
    _fetchSalesAdTypeId();
    fetchAllAddresses();
    _fetchPlasticsByDiscBrandId(item);
    // _fetchDiscSpecialTypes();
    AppPreferences.fetchSpecialDiscTags();
  }

  void clearStates() {
    step = 1;
    userDisc = UserDisc();
    isEditDetails = false;
    address = Address();
    loader = DEFAULT_LOADER;
    // discType = DISC_TYPES_LIST.first;
    specialTags.clear();
    usedValue = 10.0;
    discFile = DocFile();
    plastic = Plastic();
    plastics.clear();
    salesAdTypeId = 1;
    // isShipping = false;
  }

  Future<void> _fetchSalesAdTypeId() async {
    var response = await sl<MarketplaceRepository>().fetchSalesAdTypes();
    if (response.isEmpty) return;
    var salesAdType = response.where((e) => e.name.toKey == 'DISC'.toKey).cast<SalesAdType?>().firstOrNull;
    salesAdTypeId = salesAdType?.id ?? 1;
    notifyListeners();
  }

  Future<void> fetchAllAddresses() async {
    var response = await sl<AddressRepository>().fetchAllAddresses();
    if (response.isEmpty) return unawaited(addHomeAddressDialog());
    var homeAddress = response.where((item) => item.label.toKey == 'home'.toKey).cast<Address?>().firstOrNull;
    homeAddress != null ? address = homeAddress : unawaited(addHomeAddressDialog());
    notifyListeners();
  }

  void updateAddress(Address addressItem) {
    address = addressItem;
    notifyListeners();
  }

  Future<void> _fetchPlasticsByDiscBrandId(UserDisc uDiscItem) async {
    var brandId = userDisc.brand?.id;
    if (brandId == null) loader = Loader(initial: false, common: false);
    if (brandId == null) return notifyListeners();
    var response = await sl<DiscRepository>().plasticsByDiscBrandId(brandId);
    if (response.isNotEmpty) plastics = response;
    var invalidPlastic = plastics.isEmpty || uDiscItem.plastic?.id == null;
    var index = invalidPlastic ? -1 : plastics.indexWhere((item) => item.id.nullToInt == uDiscItem.plastic?.id.nullToInt);
    if (index >= 0) plastic = plastics[index];
    loader = Loader(initial: false, common: false);
    notifyListeners();
  }

  /*Future<void> _fetchSalesAdTypes() async {
    var response = await sl<MarketplaceRepository>().fetchSalesAdTypes();
    if (response.isNotEmpty) salesAdTypes = response;
    if (salesAdTypes.isNotEmpty) salesAdType = salesAdTypes.first;
    notifyListeners();
  }*/

  /*void onShipping(bool value) {
    if (address.id == null) return FlushPopup.onWarning(message: 'please_add_your_address'.recast);
    isShipping = value;
    notifyListeners();
  }*/

  Future<void> onImage(DocFile file) async {
    discFile = file;
    notifyListeners();
  }

  Future<int?> _fetchMediaId() async {
    var base64 = 'data:image/jpeg;base64,${discFile.base64}';
    var mediaBody = {'section': 'disc', 'alt_texts': 'sales_ad_disc', 'type': 'image', 'image': base64};
    var response = await sl<UserRepository>().uploadBase64Media(mediaBody);
    return response?.id;
  }

  Future<void> onCreateSalesAd(Map<String, dynamic> params, int? salesAdMediaId) async {
    loader.common = true;
    notifyListeners();
    var updatedMediaId = discFile.file == null ? salesAdMediaId : await _fetchMediaId();
    if (updatedMediaId == null) loader.common = false;
    if (updatedMediaId == null) return notifyListeners();
    var specialityIds = specialTags.isEmpty ? <int>[] : specialTags.map((e) => e.id ?? DEFAULT_ID).toList();
    var body = {
      'user_disc_id': userDisc.id,
      'sales_ad_type_id': 1,
      'parent_disc_id': userDisc.parentDiscId,
      'disc_plastic_id': plastic.id,
      'currency_id': UserPreferences.currency.id,
      'shipping_method': null,
      'used_range': usedValue.toInt(),
      'tags': specialityIds,
      'address_id': address.id,
      'media_id': updatedMediaId,
      // 'is_shipping': isShipping,
      // 'sales_ad_type_id': salesAdType.id,
      // 'condition': discType.valueInt,
      // 'condition': USED_DISC_INFO[conditionIndex - 1],
    };
    body.addAll(params);
    final context = navigatorKey.currentState!.context;
    final marketplaceModel = Provider.of<MarketplaceViewModel>(context, listen: false);
    final discsViewModel = Provider.of<DiscsViewModel>(context, listen: false);
    final clubViewModel = Provider.of<ClubViewModel>(context, listen: false);
    final tournamentDiscsModel = Provider.of<TournamentDiscsViewModel>(context, listen: false);
    var response = await sl<MarketplaceRepository>().createSalesAdDisc(body);
    loader.common = false;
    if (response == null) return notifyListeners();
    unawaited(discsViewModel.fetchAllDiscBags());
    unawaited(marketplaceModel.generateFilterUrl());
    unawaited(marketplaceModel.fetchSalesAdDiscs());
    tournamentDiscsModel.removeDiscForCreatedSalesAd(userDisc);
    if (clubViewModel.club.id != null) unawaited(clubViewModel.fetchSellingDiscs());
    sl<AppAnalytics>().logEvent(name: 'created_sales_ad', parameters: response.analyticParams);
    ToastPopup.onInfo(message: 'sales_ad_disc_created_successfully'.recast);
    unawaited(Routes.user.created_disc(disc: response.userDisc!).push());
    notifyListeners();
  }
}
