import 'dart:async';

import 'package:flutter/cupertino.dart';

import 'package:app/di.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/libraries/flush_popup.dart';
import 'package:app/models/feature/feature.dart';
import 'package:app/preferences/user_preferences.dart';
import 'package:app/repository/pref_repo.dart';

class SuggestFeatureViewModel with ChangeNotifier {
  var loader = true;
  var suggestedFeatures = <Feature>[];

  void initViewModel() => _fetchSuggestedFeatures();

  void disposeViewModel() {
    loader = true;
    suggestedFeatures.clear();
  }

  Future<void> _fetchSuggestedFeatures() async {
    final response = await sl<PreferencesRepository>().fetchSuggestedFeaturesList();
    if (response.isNotEmpty) suggestedFeatures = response;
    loader = false;
    notifyListeners();
  }

  Future<void> onVote(Feature item) async {
    if (item.user?.id == UserPreferences.user.id) return FlushPopup.onWarning(message: 'you_cannot_vote_on_your_own_feature'.recast);
    if (item.is_voted) return FlushPopup.onWarning(message: 'you_already_vote_on_this_feature'.recast);
    loader = true;
    notifyListeners();
    final body = {'feature_id': item.id};
    final response = await sl<PreferencesRepository>().voteOnAFeature(body);
    if (response != null) updateVote(response);
    loader = false;
    notifyListeners();
  }

  Future<bool> onSendSuggestion({required String title, required String feature}) async {
    loader = true;
    notifyListeners();
    final body = {'title': title, 'description': feature};
    final response = await sl<PreferencesRepository>().createSuggestFeature(body);
    if (response != null) suggestedFeatures.add(response);
    suggestedFeatures.sort((item1, item2) => item2.totalVotes.nullToInt.compareTo(item1.totalVotes.nullToInt));
    loader = false;
    notifyListeners();
    return response != null;
  }

  void updateVote(Feature feature) {
    final index = suggestedFeatures.indexWhere((item) => item.id == feature.id);
    if (index < 0) return;
    suggestedFeatures[index] = feature;
    suggestedFeatures.sort((item1, item2) => item2.totalVotes.nullToInt.compareTo(item1.totalVotes.nullToInt));
    notifyListeners();
  }
}
