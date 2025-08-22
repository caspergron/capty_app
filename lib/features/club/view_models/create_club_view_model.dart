import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:app/constants/data_constants.dart';
import 'package:app/di.dart';
import 'package:app/features/club/components/club_created_dialog.dart';
import 'package:app/libraries/locations.dart';
import 'package:app/models/club/club.dart';
import 'package:app/models/club/course.dart';
import 'package:app/models/map/coordinates.dart';
import 'package:app/models/system/loader.dart';
import 'package:app/preferences/user_preferences.dart';
import 'package:app/repository/club_repo.dart';
import 'package:app/repository/google_repo.dart';

class CreateClubViewModel with ChangeNotifier {
  var step = 1;
  var loader = DEFAULT_LOADER;
  var coordinates = INITIAL_COORDINATES;
  var clubs = <Club>[];
  var courses = <Course>[];
  var selectedCourses = <Course>[];
  var homeCourse = Course();

  Future<void> initViewModel() async {
    var country = UserPreferences.user.country_item;
    var currentPosition = await sl<Locations>().fetchLocationPermission();
    var position = currentPosition.is_coordinate
        ? currentPosition
        : await sl<GoogleRepository>().coordinatesOfACountry(countryCode: country.code ?? 'DK');
    // if (!currentPosition.is_coordinate) FlushPopup.onInfo(message: 'your_location_is_turned_off'.recast);
    if (position?.is_coordinate == true) coordinates = position!;
    loader = Loader(initial: false, common: false);
    notifyListeners();
    await _fetchNearbyCourses();
  }

  void disposeViewModel() {
    step = 1;
    loader = DEFAULT_LOADER;
    coordinates = Coordinates();
    clubs.clear();
    courses.clear();
    selectedCourses.clear();
    homeCourse = Course();
  }

  /*void _onDisabledLocation() {
    FlushPopup.onInfo(message: 'your_location_is_turned_off'.recast);
    loader = Loader(initial: false, common: false);
    notifyListeners();
  }*/

  Future<void> _fetchNearbyCourses() async {
    loader = Loader(initial: false, common: false);
    notifyListeners();
    // var position = Coordinates(lat: 23.622418, lng: 90.496595);
    var response = await sl<ClubRepository>().findNearbyCourses(coordinates);
    clubs.clear();
    courses.clear();
    loader = Loader(initial: false, common: false);
    if (response == null) return notifyListeners();
    if (response['is_course']) {
      var courseItems = response['data'] as List<Course>;
      if (courseItems.isNotEmpty) courses = courseItems;
    } else {
      var clubItems = response['data'] as List<Club>;
      if (clubItems.isNotEmpty) clubs = clubItems;
    }
    notifyListeners();
  }

  void onSetHomeCourse(Course item) {
    homeCourse = item;
    var index = selectedCourses.isEmpty ? -1 : selectedCourses.indexWhere((element) => element.id == item.id);
    if (index >= 0) selectedCourses.removeAt(index);
    notifyListeners();
  }

  void onSetCourse(Course item) {
    var index = selectedCourses.isEmpty ? -1 : selectedCourses.indexWhere((element) => element.id == item.id);
    if (index < 0) selectedCourses.add(item);
    if (homeCourse.id != null && homeCourse.id == item.id) homeCourse = Course();
    notifyListeners();
  }

  Future<void> onCreateClub(Map<String, dynamic> body) async {
    loader.common = true;
    notifyListeners();
    var additionalData = {
      'media_id': null,
      'latitude': '${coordinates.lat}',
      'longitude': '${coordinates.lng}',
      'home_course_id': homeCourse.id
    };
    body.addAll(additionalData);
    var response = await sl<ClubRepository>().createClub(body);
    if (response != null) {
      if (selectedCourses.isNotEmpty) await _onCreateClubCourse(response.id!);
      unawaited(clubCreatedDialog(club: response));
    }
    loader.common = false;
    notifyListeners();
  }

  Future<bool> _onCreateClubCourse(int clubId) async {
    var clubIds = selectedCourses.map((item) => item.id ?? DEFAULT_ID).toList();
    var courseBody = {'club_id': clubId, 'course_id': clubIds, 'home_course_id': homeCourse.id};
    return sl<ClubRepository>().createClubCourse(courseBody);
  }
}
