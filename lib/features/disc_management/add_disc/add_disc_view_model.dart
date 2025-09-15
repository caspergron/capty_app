import 'dart:async';

import 'package:app/constants/app_keys.dart';
import 'package:app/constants/data_constants.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/features/disc_management/discs/discs_view_model.dart';
import 'package:app/models/disc/parent_disc.dart';
import 'package:app/models/disc_bag/disc_bag.dart';
import 'package:app/models/plastic/plastic.dart';
import 'package:app/models/system/doc_file.dart';
import 'package:app/models/system/loader.dart';
import 'package:app/repository/disc_bag_repo.dart';
import 'package:app/repository/disc_repo.dart';
import 'package:app/repository/user_repo.dart';
import 'package:app/services/app_analytics.dart';
import 'package:app/services/routes.dart';
import 'package:app/themes/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class AddDiscViewModel with ChangeNotifier {
  var loader = DEFAULT_LOADER;
  var isEditDetails = false;
  var selectedRadio = DISC_OPTIONS.first;
  var color = const Color(0xFFFD131B);
  var discFile = DocFile();
  var disc = ParentDisc();
  var discBag = DiscBag();
  var plastic = Plastic();
  var discBags = <DiscBag>[];
  var plastics = <Plastic>[];

  void initViewModel(ParentDisc item) {
    clearStates();
    disc = item;
    notifyListeners();
    _fetchPlasticsByDiscBrandId();
    _fetchAllDiscBags();
  }

  void clearStates() {
    loader = DEFAULT_LOADER;
    isEditDetails = false;
    selectedRadio = DISC_OPTIONS.first;
    color = const Color(0xFFFD131B);
    discFile = DocFile();
    disc = ParentDisc();
    plastic = Plastic();
    discBag = DiscBag();
    discBags.clear();
    plastics.clear();
  }

  Future<void> _fetchPlasticsByDiscBrandId() async {
    var response = await sl<DiscRepository>().plasticsByDiscBrandId(disc.discBrandId!);
    if (response.isNotEmpty) plastics = response;
    // if (plastics.isNotEmpty) plastic = plastics.first;
    notifyListeners();
  }

  Future<void> _fetchAllDiscBags() async {
    final context = navigatorKey.currentState!.context;
    final bag = Provider.of<DiscsViewModel>(context, listen: false).discBag;
    var response = await sl<DiscBagRepository>().fetchDiscBags();
    if (response.isNotEmpty) discBags = response;
    final findIndex = discBags.isEmpty ? -1 : discBags.indexWhere((element) => element.id == bag.id);
    if (findIndex >= 0) discBag = discBags[findIndex];
    loader = Loader(initial: false, common: false);
    notifyListeners();
  }

  void onRadioChange(String value) {
    if (selectedRadio == value) return;
    selectedRadio = value;
    color = primary;
    discFile = DocFile();
    notifyListeners();
  }

  Future<void> onImage(DocFile file) async {
    discFile = file;
    notifyListeners();
  }

  Future<void> onAddDisc(Map<String, dynamic> params) async {
    loader.common = true;
    notifyListeners();
    var mediaId = null as int?;
    var isMediaUpload = selectedRadio == 'image';
    if (isMediaUpload) {
      var base64 = 'data:image/jpeg;base64,${discFile.base64}';
      var mediaBody = {'section': 'disc', 'alt_texts': 'user_disc', 'type': 'image', 'image': base64};
      var mediaResponse = await sl<UserRepository>().uploadBase64Media(mediaBody);
      if (mediaResponse == null) loader.common = false;
      if (mediaResponse == null) return notifyListeners();
      mediaId = mediaResponse.id;
    }
    var colorValue = color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2);
    var body = {
      'disc_id': disc.id,
      'bag_id': discBag.id,
      'disc_plastic_id': plastic.id,
      'color': isMediaUpload ? null : colorValue,
      'media_id': isMediaUpload ? mediaId : null,
    };
    body.addAll(params);
    var context = navigatorKey.currentState!.context;
    var response = await sl<DiscRepository>().createUserDisc(body);
    loader.common = false;
    if (response == null) return notifyListeners();
    sl<AppAnalytics>().logEvent(name: 'added_disc', parameters: response.analyticParams);
    unawaited(Provider.of<DiscsViewModel>(context, listen: false).fetchAllDiscBags());
    unawaited(Routes.user.created_disc(isDisc: true, disc: response).push());
    notifyListeners();
  }
}
