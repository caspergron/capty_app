import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';

import 'package:path/path.dart';
import 'package:provider/provider.dart';

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

  void _stopLoader() {
    loader = Loader(initial: false, common: false);
    notifyListeners();
  }

  Future<void> _fetchTournamentInfo() async {
    loader.common = true;
    notifyListeners();
    final response = await sl<UserRepository>().fetchPlayerTournamentInfo();
    if (response.isNotEmpty) upcomingTournaments = response;
    loader = Loader(initial: false, common: false);
    notifyListeners();
  }

  Future<void> _fetchSalesAdDiscs() async {
    final coordinates = await sl<Locations>().fetchLocationPermission();
    final locationParams = '&latitude=${coordinates.lat}&longitude=${coordinates.lng}';
    final params = '&page=1$locationParams';
    final response = await sl<MarketplaceRepository>().fetchSalesAdDiscs(params);
    salesAdDiscs.clear();
    if (response.isNotEmpty) salesAdDiscs = response;
    notifyListeners();
  }

  Future<void> onUpdateProfileImage(File file) async {
    loader.common = true;
    notifyListeners();
    final docFiles = await sl<FileHelper>().renderFilesInModel([file]);
    final docFile = docFiles.first;
    final imageName = basename(docFile.file!.path);
    final base64 = 'data:image/${docFile.file?.path.fileExtension};base64,${docFile.base64}';
    final body = {'type': 'image', 'section': 'user', 'alt_text': imageName, 'image': base64};
    final response = await sl<UserRepository>().uploadBase64Media(body);
    if (response == null) return _stopLoader();
    final userBody = {'media_id': response.id};
    final userResponse = await sl<UserRepository>().updateProfileInfo(userBody);
    if (userResponse == null) return _stopLoader();
    final context = navigatorKey.currentState!.context;
    unawaited(Provider.of<HomeViewModel>(context, listen: false).fetchDashboardCount());
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
    final context = navigatorKey.currentState!.context;
    final response = await sl<UserRepository>().updateProfileInfo(params);
    if (response == null) return _stopLoader();
    person = response;
    unawaited(Provider.of<HomeViewModel>(context, listen: false).fetchDashboardCount(isDelay: true));
    _stopLoader();
  }
}
