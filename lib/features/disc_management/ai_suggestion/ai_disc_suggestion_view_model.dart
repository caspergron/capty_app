import 'dart:async';

import 'package:flutter/cupertino.dart';

import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/libraries/flush_popup.dart';
import 'package:app/models/system/data_model.dart';
import 'package:app/services/routes.dart';

class AiDiscSuggestionViewModel with ChangeNotifier {
  var loader = false;
  var step = 1;
  var distance = DataModel();
  var strongestList = <DataModel>[];
  var stabilityList = <DataModel>[];
  var windList = <DataModel>[];
  var plasticList = <DataModel>[];
  var gripList = <DataModel>[];
  var fieldList = <DataModel>[];

  Future<void> initViewModel() async {
    strongestList = _STRONGEST_LIST;
    stabilityList = _STABILITY_LIST;
    windList = _WIND_LIST;
    plasticList = _PLASTIC_LIST;
    gripList = _GRIP_LIST;
    fieldList = _FIELDS_LIST;

    strongestList.forEach((item) => item.valueInt = 0);
    stabilityList.forEach((item) => item.valueInt = 0);
    windList.forEach((item) => item.valueInt = 0);
    plasticList.forEach((item) => item.valueInt = 0);
    gripList.forEach((item) => item.valueInt = 0);
    fieldList.forEach((item) => item.valueInt = 0);
  }

  void disposeViewModel() {
    loader = false;
    strongestList = [];
    stabilityList = [];
    windList = [];
    plasticList = [];
    gripList = [];
    fieldList = [];
  }

  void onSelectStrongest(DataModel item, int index) {
    strongestList[index].valueInt = item.valueInt == 0 ? 1 : 0;
    notifyListeners();
  }

  void onSelectStability(DataModel item, int index) {
    stabilityList.forEach((item) => item.valueInt = 0);
    stabilityList[index].valueInt = 1;
    notifyListeners();
  }

  void onSelectWind(DataModel item, int index) {
    windList.forEach((item) => item.valueInt = 0);
    windList[index].valueInt = 1;
    notifyListeners();
  }

  void onSelectPlastic(DataModel item, int index) {
    plasticList.forEach((item) => item.valueInt = 0);
    plasticList[index].valueInt = 1;
    notifyListeners();
  }

  void onSelectGrip(DataModel item, int index) {
    gripList.forEach((item) => item.valueInt = 0);
    gripList[index].valueInt = 1;
    notifyListeners();
  }

  void onSelectField(DataModel item, int index) {
    fieldList.forEach((item) => item.valueInt = 0);
    fieldList[index].valueInt = 1;
    notifyListeners();
  }

  void onBack() {
    if (step < 2) return backToPrevious();
    step--;
    notifyListeners();
  }

  void onNext() {
    if (step == 1) {
      if (distance.value.isEmpty) return FlushPopup.onWarning(message: 'please_select_your_backhand_distance'.recast);
      step++;
      notifyListeners();
    } else if (step == 2) {
      var strongestItems = strongestList.where((item) => item.valueInt == 1).toList().length;
      if (strongestItems != 3) return FlushPopup.onWarning(message: 'please_select_3_option'.recast);
      step++;
      notifyListeners();
    } else if (step == 3) {
      var stabilityItems = stabilityList.where((item) => item.valueInt == 1).toList().length;
      var windItems = windList.where((item) => item.valueInt == 1).toList().length;
      if (stabilityItems != 1 || windItems != 1) return FlushPopup.onWarning(message: 'please_select_1_option'.recast);
      step++;
      notifyListeners();
    } else {
      var plasticItems = plasticList.where((item) => item.valueInt == 1).toList().length;
      var gripItems = gripList.where((item) => item.valueInt == 1).toList().length;
      var fieldItems = fieldList.where((item) => item.valueInt == 1).toList().length;
      if (plasticItems != 1 || gripItems != 1 || fieldItems != 1) return FlushPopup.onWarning(message: 'please_select_1_option'.recast);
      _fetchAiSuggestion();
    }
  }

  Future<void> _fetchAiSuggestion() async {
    loader = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    loader = false;
    notifyListeners();
    unawaited(Routes.user.recommended_disc(disc: '').pushAndRemove());
  }
}

List<DataModel> _STRONGEST_LIST = [
  DataModel(label: 'Max distance drive', value: 'max_distance_drive'),
  DataModel(label: 'Controlled Distance (Fairway Driver)', value: 'controlled_distance'),
  DataModel(label: 'Straight Midrange', value: 'straight_midrange'),
  DataModel(label: 'Over stable utility Midrange', value: 'over_stable_utility_midrange'),
  DataModel(label: 'Understandable Turnover Midrange', value: 'understandable_turnover_midrange'),
  DataModel(label: 'Approach Shots (Short-range control)', value: 'approach_shots'),
  DataModel(label: 'Over stable Approach(Flicks,Wind,Flex shots)', value: 'over_stable_approach'),
  DataModel(label: 'Putter for Circle 1 Puts', value: 'putter_for_circle_1_puts'),
  DataModel(label: 'Putter for Driving/Circle 2 Putts', value: 'putter_for_driving_circle_2_putts'),
];

List<DataModel> _STABILITY_LIST = [
  DataModel(label: 'I prefer very over stable discs', value: 'i_prefer_very_over_stable_discs'),
  DataModel(label: 'I like stable/straight flyers', value: 'i_like_stable_straight_flyers'),
  DataModel(label: 'I prefer under stable discs (easier turnover/flex lines)', value: 'i_prefer_under_stable_discs'),
  DataModel(label: 'I like a mix depending on the situation', value: 'i_like_a_mix_depending_on_the_situation'),
];

List<DataModel> _WIND_LIST = [
  DataModel(label: 'Yes', value: 'yes'),
  DataModel(label: 'No', value: 'no'),
  DataModel(label: 'Sometimes', value: 'sometimes'),
];

List<DataModel> _PLASTIC_LIST = [
  DataModel(label: 'Base Plastic', value: 'base_plastic'),
  DataModel(label: 'Premium Plastic', value: 'premium_plastic'),
  DataModel(label: 'Mix/No Preference', value: 'mix_no_preference'),
];

List<DataModel> _GRIP_LIST = [
  DataModel(label: 'Very important', value: 'very_important'),
  DataModel(label: 'Somewhat important', value: 'somewhat_important'),
  DataModel(label: 'Not important', value: 'not_important'),
];
List<DataModel> _FIELDS_LIST = [
  DataModel(label: 'Wooded courses', value: 'wooded_courses'),
  DataModel(label: 'Open field', value: 'open_field'),
  DataModel(label: 'Both', value: 'both'),
];
