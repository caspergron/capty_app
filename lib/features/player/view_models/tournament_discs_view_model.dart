import 'dart:async';

import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';

import 'package:app/constants/app_keys.dart';
import 'package:app/constants/data_constants.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/disc_management/discs/components/disc_info_dialog.dart';
import 'package:app/features/disc_management/discs/components/edit_disc_dialog.dart';
import 'package:app/features/disc_management/discs/discs_view_model.dart';
import 'package:app/libraries/flush_popup.dart';
import 'package:app/models/disc/user_disc.dart';
import 'package:app/models/disc/user_disc_category.dart';
import 'package:app/models/system/loader.dart';
import 'package:app/models/user/user.dart';
import 'package:app/preferences/user_preferences.dart';
import 'package:app/repository/disc_repo.dart';
import 'package:app/repository/player_repo.dart';
import 'package:app/services/routes.dart';

class TournamentDiscsViewModel with ChangeNotifier {
  var loader = DEFAULT_LOADER;
  var categories = <UserDiscCategory>[];
  // var selectedDiscs = <UserDisc>[];

  void initViewModel(User player) {
    if (player.id == null) loader = Loader(initial: false, common: false);
    if (player.id == null) return notifyListeners();
    _fetchTournamentDiscsByCategory(playerId: player.id!, isLoader: true);
  }

  void disposeViewModel() {
    loader = DEFAULT_LOADER;
    categories.clear();
    // selectedDiscs.clear();
  }

  void _stopLoader() {
    loader = Loader(initial: false, common: false);
    notifyListeners();
  }

  Future<void> _fetchTournamentDiscsByCategory(
      {required int playerId, bool isLoader = false, bool isPaginate = false, int index = 0}) async {
    final invalidApiCall = categories.isNotEmpty && categories[index].is_page_loader;
    if (invalidApiCall) return;
    loader.common = isLoader;
    if (categories.isNotEmpty) categories[index].paginate?.pageLoader = isPaginate;
    notifyListeners();
    final pageNumber = categories.isNotEmpty && isPaginate ? categories[index].paginate?.page ?? 1 : 1;
    final params = '$playerId&page=$pageNumber';
    final response = await sl<PlayerRepository>().fetchTournamentDiscsByCategory(params: params);
    if (isLoader) categories.clear();
    if (response.isEmpty) return _stopLoader();
    pageNumber == 1 ? categories = response : _updateMarketplaceData(response);
    if (categories.isNotEmpty) unawaited(_paginationCheck(playerId: playerId));
    if (categories.isNotEmpty) categories[index].paginate?.pageLoader = false;
    _stopLoader();
  }

  void _updateMarketplaceData(List<UserDiscCategory> responseList) {
    for (final entry in categories.asMap().entries) {
      final catIndex = entry.key;
      final catItem = entry.value;
      final newIndex = responseList.indexWhere((element) => element.name?.toKey == catItem.name.toKey);
      if (newIndex >= 0) {
        final newItem = responseList[newIndex];
        categories[catIndex].userDiscs ??= [];
        categories[catIndex].userDiscs!.addAll(newItem.discs);
        categories[catIndex].pagination = newItem.pagination;
        final newLength = newItem.discs.length;
        categories[catIndex].paginate?.length = newLength;
        if (newLength >= LENGTH_10) categories[catIndex].paginate?.page = (categories[catIndex].paginate?.page ?? 0) + 1;
      }
    }
  }

  Future<void> _paginationCheck({required int playerId}) async {
    if (categories.isEmpty) return;
    for (final entry in categories.asMap().entries) {
      final index = entry.key;
      final category = entry.value;
      final scrollController = category.scrollControl;
      final paginate = category.paginate;
      if (scrollController == null || paginate == null) continue;
      if (!scrollController.hasListeners) {
        scrollController.addListener(() {
          final position = scrollController.position;
          final isPosition80 = position.pixels >= position.maxScrollExtent * 0.85;
          if (isPosition80 && paginate.length == LENGTH_10) {
            _fetchTournamentDiscsByCategory(playerId: playerId, isPaginate: true, index: index);
          }
        });
      }
    }
  }

  Future<void> onDiscItem(UserDisc item, bool isMySelf) async {
    loader.common = true;
    notifyListeners();
    final response = await sl<DiscRepository>().fetchUserDiscDetails(item.id!);
    loader.common = false;
    if (response == null) return notifyListeners();
    unawaited(discInfoDialog(
      isMySelf: isMySelf,
      disc: response,
      onDelete: () => onDeleteDisc(response),
      onSell: () => Routes.user.create_sales_ad(tabIndex: 1, disc: response).push(),
      onDetails: () => editDiscDialog(disc: response, onSave: _onUpdateDisc),
    ));
    notifyListeners();
  }

  Future<void> onDeleteDisc(UserDisc item) async {
    loader.common = true;
    notifyListeners();
    final context = navigatorKey.currentState!.context;
    final response = await sl<DiscRepository>().deleteUserDisc(item.id!);
    loader.common = false;
    if (!response) return notifyListeners();
    unawaited(Provider.of<DiscsViewModel>(context, listen: false).fetchAllDiscBags());
    _updateUserDiscFromCategoryData(item: item);
    notifyListeners();
  }

  Future<void> _onUpdateDisc(UserDisc item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final context = navigatorKey.currentState!.context;
    _updateUserDiscFromCategoryData(item: item, isDelete: false);
    unawaited(Provider.of<DiscsViewModel>(context, listen: false).fetchAllDiscBags());
    FlushPopup.onInfo(message: 'disc_update_successfully'.recast);
    notifyListeners();
  }

  void _updateUserDiscFromCategoryData({required UserDisc item, final isDelete = true}) {
    if (categories.isEmpty) return;
    categories.asMap().forEach((index, category) {
      final discsList = category.discs;
      final adIndex = discsList.indexWhere((element) => element.id == item.id);
      final shouldUpdate = adIndex >= 0 && (isDelete == false && item.bagId == discsList[adIndex].bagId);
      final shouldDelete = adIndex >= 0 && (isDelete == true || (isDelete == false && item.bagId != discsList[adIndex].bagId));
      if (shouldUpdate) categories[index].userDiscs?[adIndex] = item;
      if (shouldDelete) categories[index].userDiscs?.removeAt(adIndex);
    });
    categories.removeWhere((element) => element.discs.isEmpty);
    notifyListeners();
  }

  void removeDiscForCreatedSalesAd(UserDisc item) {
    if (categories.isEmpty) return;
    if (item.userId == null || item.id == null || item.userId != UserPreferences.user.id) return;
    _updateUserDiscFromCategoryData(item: item);
  }
}
