import 'dart:async';

import 'package:flutter/cupertino.dart';

import 'package:app/di.dart';
import 'package:app/features/waitlist/components/success_waitlist_dialog.dart';
import 'package:app/models/system/default_country.dart';
import 'package:app/preferences/app_preferences.dart';
import 'package:app/repository/public_repo.dart';

class WaitlistViewModel with ChangeNotifier {
  var loader = false;
  var country = null as DefaultCountry?;

  void initViewModel() {
    AppPreferences.fetchCountries();
  }

  void disposeViewModel() {
    loader = false;
    country = null;
  }

  Future<void> onSubmit(String name, String email) async {
    loader = true;
    notifyListeners();
    final body = {'name': name, 'email': email, 'phone': null, 'country_code': country?.code, 'country_name': country?.name};
    final response = await sl<PublicRepository>().addInWaitlist(body);
    if (response) unawaited(successWaitlistDialog(name: name));
    loader = false;
    notifyListeners();
  }
}
