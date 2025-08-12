import 'package:app/models/map/coordinates.dart';
import 'package:app/models/public/currency.dart';
import 'package:app/models/user/user.dart';

class UserPreferences {
  static var user = User();
  static var currency = Currency();
  static var currencyCode = 'DKK';
  static var coordinates = Coordinates();

  static void clearPreferences() {
    user = User();
    currency = Currency();
    currencyCode = 'DKK';
    coordinates = Coordinates();
  }
}
