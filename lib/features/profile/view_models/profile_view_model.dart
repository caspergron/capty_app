import 'dart:async';
import 'dart:io';

import 'package:app/constants/app_keys.dart';
import 'package:app/constants/data_constants.dart';
import 'package:app/di.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/home/home_view_model.dart';
import 'package:app/helpers/file_helper.dart';
import 'package:app/libraries/locations.dart';
import 'package:app/libraries/toasts_popups.dart';
import 'package:app/models/common/tournament.dart';
import 'package:app/models/marketplace/sales_ad.dart';
import 'package:app/models/system/loader.dart';
import 'package:app/models/user/user.dart';
import 'package:app/preferences/user_preferences.dart';
import 'package:app/repository/marketplace_repo.dart';
import 'package:app/repository/user_repo.dart';
import 'package:app/services/storage_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class ProfileViewModel with ChangeNotifier {
  var person = User();
  var loader = DEFAULT_LOADER;
  var salesAdDiscs = <SalesAd>[];
  var upcomingTournaments = <Tournament>[];

  Future<void> initViewModel() async {
    person = UserPreferences.user;
    notifyListeners();
    unawaited(_fetchSalesAdDiscs());
    await _fetchTournamentInfo();
    loader = Loader(initial: false, common: false);
    notifyListeners();
  }

  void disposeViewModel() {
    person = User();
    loader = DEFAULT_LOADER;
    upcomingTournaments.clear();
    salesAdDiscs.clear();
  }

  Future<void> _fetchTournamentInfo() async {
    loader.common = true;
    notifyListeners();
    var response = await sl<UserRepository>().fetchPlayerTournamentInfo();
    if (response.isNotEmpty) upcomingTournaments = response;
    loader = Loader(initial: false, common: false);
    notifyListeners();
  }

  Future<void> _fetchSalesAdDiscs() async {
    var coordinates = await sl<Locations>().fetchLocationPermission();
    var locationParams = '&latitude=${coordinates.lat}&longitude=${coordinates.lng}';
    var params = '&page=1$locationParams';
    var response = await sl<MarketplaceRepository>().fetchSalesAdDiscs(params);
    salesAdDiscs.clear();
    if (response.isNotEmpty) salesAdDiscs = response;
    notifyListeners();
  }

  Future<void> onUpdateProfileImage(File file) async {
    loader.common = true;
    notifyListeners();
    var docFiles = await sl<FileHelper>().renderFilesInModel([file]);
    var docFile = docFiles.first;
    var imageName = basename(docFile.file!.path);
    var base64 = 'data:image/${docFile.file?.path.fileExtension};base64,${docFile.base64}';
    var body = {'type': 'image', 'section': 'user', 'alt_text': imageName, 'image': base64};
    var response = await sl<UserRepository>().uploadBase64Media(body);
    if (response == null) {
      loader.common = false;
      return notifyListeners();
    }
    var userBody = {'media_id': response.id};
    var userResponse = await sl<UserRepository>().updateProfileInfo(userBody);
    if (userResponse == null) {
      loader.common = false;
      return notifyListeners();
    }
    var context = navigatorKey.currentState!.context;
    unawaited(Provider.of<HomeViewModel>(context, listen: false).fetchDashboardCount());
    await Future.delayed(const Duration(seconds: 4));
    person = userResponse;
    UserPreferences.user = userResponse;
    sl<StorageService>().setUser(userResponse);
    ToastPopup.onInfo(message: 'profile_picture_uploaded_successfully'.recast);
    loader.common = false;
    notifyListeners();
  }

  Future<void> onUpdateProfile(Map<String, dynamic> params) async {
    loader.common = true;
    notifyListeners();
    var response = await sl<UserRepository>().updateProfileInfo(params);
    if (response != null) {
      person = response;
      var context = navigatorKey.currentState!.context;
      unawaited(Provider.of<HomeViewModel>(context, listen: false).fetchDashboardCount());
    }
    loader.common = false;
    notifyListeners();
  }
}
