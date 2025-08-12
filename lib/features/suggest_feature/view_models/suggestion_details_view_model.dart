import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'package:provider/provider.dart';

import 'package:app/constants/app_keys.dart';
import 'package:app/di.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/suggest_feature/view_models/suggest_feature_view_model.dart';
import 'package:app/libraries/flush_popup.dart';
import 'package:app/models/feature/feature.dart';
import 'package:app/preferences/user_preferences.dart';
import 'package:app/repository/pref_repo.dart';

class SuggestionDetailsViewModel with ChangeNotifier {
  var loader = true;
  var scrollControl = ScrollController();
  var feature = Feature();

  void initViewModel(Feature item) {
    feature = item;
    feature.comments ??= [];
    notifyListeners();
    _fetchSuggestedFeatures();
  }

  void disposeViewModel() {
    loader = true;
  }

  Future<void> _fetchSuggestedFeatures() async {
    // var response = await sl<PreferencesRepository>().fetchFeatureDetails(feature);
    // if (response != null) feature = response;
    loader = false;
    notifyListeners();
  }

  Future<void> onVote() async {
    if (feature.user?.id == UserPreferences.user.id) return FlushPopup.onWarning(message: 'you_cannot_vote_on_your_own_feature'.recast);
    if (feature.is_voted) return FlushPopup.onWarning(message: 'you_already_vote_on_this_feature'.recast);
    loader = true;
    notifyListeners();
    var body = {'feature_id': feature.id};
    var context = navigatorKey.currentState!.context;
    var response = await sl<PreferencesRepository>().voteOnAFeature(body);
    if (response != null) feature = response;
    if (response != null) Provider.of<SuggestFeatureViewModel>(context, listen: false).updateVote(response);
    loader = false;
    notifyListeners();
  }

  Future<void> scrollDown() async {
    await Future.delayed(const Duration(milliseconds: 200));
    var duration = const Duration(milliseconds: 500);
    if (!scrollControl.hasClients) return;
    await scrollControl.animateTo(scrollControl.position.maxScrollExtent, duration: duration, curve: Curves.linear);
  }

  Future<void> onPostFeedback(String feedback) async {
    loader = true;
    notifyListeners();
    var body = {'feature_id': feature.id, 'message': feedback};
    if (kDebugMode) print(body);
    var response = await sl<PreferencesRepository>().postFeatureComment(body);
    if (response != null) feature.comments?.add(response);
    if (response != null) unawaited(scrollDown());
    loader = false;
    notifyListeners();
  }
}
