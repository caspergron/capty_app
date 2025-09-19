import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:path/path.dart';

import 'package:app/components/sheets/image_option_sheet.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/helpers/file_helper.dart';
import 'package:app/libraries/locations.dart';
import 'package:app/models/club/club.dart';
import 'package:app/models/public/country.dart';
import 'package:app/models/system/doc_file.dart';
import 'package:app/preferences/app_preferences.dart';
import 'package:app/repository/auth_repo.dart';
import 'package:app/repository/public_repo.dart';
import 'package:app/repository/user_repo.dart';
import 'package:app/services/routes.dart';

class SetProfileViewModel with ChangeNotifier {
  var loader = false;
  var isPGDANumber = false;
  var clubs = <Club>[];
  var isNoClub = false;
  var isNotMember = false;
  var avatar = DocFile();
  var country = Country();
  var phoneCheck = ''; // loader, failed, success
  var emailCheck = ''; // loader, failed, success

  void initViewModel(Map<String, dynamic> params) {
    final countryItem = params['country'] as Country;
    country = countryItem.id == null ? AppPreferences.countries.first : countryItem;
    notifyListeners();
    if (params.containsKey('email') && params['email'].toString().isNotEmpty) checkUniqueEmail(params['email']);
  }

  void disposeViewModel() {
    loader = false;
    isPGDANumber = false;
    clubs.clear();
    isNoClub = false;
    isNotMember = false;
    avatar = DocFile();
    country = Country();
    phoneCheck = '';
    emailCheck = '';
  }

  void clearStates() {
    loader = false;
    isPGDANumber = false;
    clubs.clear();
    isNoClub = false;
    isNotMember = false;
    avatar = DocFile();
    country = Country();
    phoneCheck = '';
    emailCheck = '';
  }

  void updateUi() => notifyListeners();

  void onUpload() {
    if (avatar.unit8List != null) {
      avatar = DocFile();
      notifyListeners();
      return;
    }
    imageOptionSheet(onFile: onUpdateImage);
  }

  Future<void> checkUniquePhoneNumber(String phone) async {
    if (phone.length < 6) return;
    phoneCheck = 'loader';
    notifyListeners();
    final body = {'field': 'phone', 'value': '${country.phonePrefix}$phone'};
    final response = await sl<AuthRepository>().checkUniqueUser(body);
    phoneCheck = response ? 'success' : 'failed';
    notifyListeners();
  }

  Future<void> checkUniqueEmail(String email) async {
    if (email.isEmpty) return;
    final parts = email.split('@');
    final isValidEmail = parts.length == 2 && parts[0].isNotEmpty && parts[1].contains('.');
    if (!isValidEmail) return;
    emailCheck = 'loader';
    notifyListeners();
    final body = {'field': 'email', 'value': email};
    final response = await sl<AuthRepository>().checkUniqueUser(body);
    emailCheck = response ? 'success' : 'failed';
    notifyListeners();
  }

  Future<void> onAllowLocation(Map<String, dynamic> data) async {
    loader = true;
    notifyListeners();
    final coordinates = await sl<Locations>().fetchLocationPermission();
    if (!coordinates.is_coordinate) loader = false;
    if (!coordinates.is_coordinate) unawaited(Routes.auth.set_profile_4(data: data).push());
    if (!coordinates.is_coordinate) return notifyListeners();
    final response = await sl<PublicRepository>().findClubs(coordinates);
    clubs.clear();
    if (response.isNotEmpty) clubs = response.sublist(0, response.length > 3 ? 3 : response.length);
    clubs.isEmpty ? unawaited(Routes.auth.set_profile_4(data: data).push()) : unawaited(Routes.auth.set_profile_3(data: data).push());
    loader = false;
    notifyListeners();
  }

  void onClubAction(Club item, int index) {
    final isMember = clubs[index].is_member;
    final totalMember = clubs[index].totalMember.nullToInt;
    clubs[index].totalMember = isMember ? totalMember - 1 : totalMember + 1;
    clubs[index].isMember = item.is_member ? false : true;
    final totalJoined = clubs.where((item) => item.is_member).toList().length;
    if (totalJoined > 0) isNoClub = false;
    if (totalJoined > 0) isNotMember = false;
    notifyListeners();
  }

  void onNoClub() {
    isNoClub = !isNoClub;
    if (clubs.isNotEmpty) _resetClubs();
    notifyListeners();
  }

  void onNotAMember() {
    isNotMember = !isNotMember;
    if (clubs.isNotEmpty) _resetClubs();
    notifyListeners();
  }

  void _resetClubs() {
    clubs.forEach((item) {
      if (item.is_member) item.totalMember = item.totalMember.nullToInt - 1;
      item.isMember = false;
    });
    notifyListeners();
  }

  Future<void> onUpdateImage(File file) async {
    loader = true;
    notifyListeners();
    final docFiles = await sl<FileHelper>().renderFilesInModel([file]);
    if (docFiles.isNotEmpty) avatar = docFiles.first;
    loader = false;
    notifyListeners();
  }

  Future<int?> _uploadProfileAvatar() async {
    final imageName = basename(avatar.file!.path);
    final base64 = 'data:image/${avatar.file?.path.fileExtension};base64,${avatar.base64}';
    final body = {'type': 'image', 'section': 'user', 'alt_text': imageName, 'image': base64};
    final response = await sl<UserRepository>().uploadBase64Media(body);
    return response == null ? null : response.id;
  }

  Future<void> onSignUp(Map<String, dynamic> params) async {
    loader = true;
    notifyListeners();
    var mediaId = null as int?;
    if (avatar.file != null) {
      mediaId = await _uploadProfileAvatar();
      if (mediaId == null) loader = false;
      if (mediaId == null) return;
    }
    final clubItems = clubs.isEmpty ? <Club>[] : clubs.where((item) => item.is_member).toList();
    final clubIds = clubItems.isEmpty ? <int>[] : clubItems.map((item) => item.id.nullToInt).toList();
    final pdgaNo = params['pgda_number'] as String;
    final body = {
      'name': params['name'],
      'email': params['email'],
      'phone': '${country.phonePrefix}${params['phone']}',
      'medium': params['medium'],
      if (params['medium'] != 0) 'social_id': params['social_id'],
      'country_id': country.id,
      'currency_id': country.currency?.id,
      'pdga_number': pdgaNo.isEmpty ? null : pdgaNo,
      'media_id': mediaId,
      'is_club_exist': clubIds.isEmpty ? isNoClub : false,
      'is_club_member': clubIds.isEmpty ? isNotMember : false,
      'club_id': clubIds,
    };
    final response = await sl<AuthRepository>().createAccount(body);
    if (response != null) unawaited(Routes.auth.signed_up(user: response.user!).pushAndRemove());
    loader = false;
    notifyListeners();
  }
}
