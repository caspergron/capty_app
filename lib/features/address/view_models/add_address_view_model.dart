import 'dart:async';

import 'package:flutter/cupertino.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'package:app/components/dialogs/countries_dialog.dart';
import 'package:app/constants/app_keys.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/address/view_models/seller_settings_view_model.dart';
import 'package:app/libraries/locations.dart';
import 'package:app/models/address/address.dart';
import 'package:app/models/map/coordinates.dart';
import 'package:app/models/public/country.dart';
import 'package:app/preferences/user_preferences.dart';
import 'package:app/repository/address_repo.dart';
import 'package:app/repository/google_repo.dart';

class AddAddressViewModel with ChangeNotifier {
  var loader = false;
  var country = Country();
  var addressInfo = null as Map<String, dynamic>?;
  var suggestions = <dynamic>[];
  var markers = <Marker>{};
  var centerLocation = Coordinates(lat: 23.622857, lng: 90.499010);

  Future<void> initViewModel(Address item) async {
    var google = sl<GoogleRepository>();
    if (item.id == null) {
      country = UserPreferences.user.country_item;
      notifyListeners();
      await countriesDialog(country: country, onChanged: _onCountry);
      var position = await sl<Locations>().fetchLocationPermission();
      var coordinates = position.is_coordinate ? position : await google.coordinatesOfACountry(countryCode: country.code!);
      if (coordinates?.is_coordinate == true) centerLocation = coordinates!;
      notifyListeners();
    } else {
      addressInfo = {
        'address': item.addressLine1,
        'city': item.city,
        'coordinates': item.coordinates,
        'state': item.state,
        'postal_code': item.zipCode,
        'place_id': item.placeId,
      };
      country = item.country?.id == null ? UserPreferences.user.country_item : item.country!;
      var coordinates = item.is_coordinate ? item.coordinates : await google.coordinatesOfACountry(countryCode: country.code!);
      if (coordinates?.is_coordinate == true) centerLocation = coordinates!;
      notifyListeners();
    }
  }

  void disposeViewModel() {
    loader = false;
    country = Country();
    addressInfo = null;
    suggestions.clear();
    markers.clear();
    centerLocation = Coordinates(lat: 23.622857, lng: 90.499010);
  }

  void _onCountry(Country item) {
    country = item;
    notifyListeners();
  }

  Future<void> fetchAddressPredictions(String input, Coordinates coordinates) async {
    suggestions.clear();
    var response = await sl<GoogleRepository>().fetchPredictions(input, coordinates, country.code!);
    if (response.isEmpty) return;
    suggestions = response;
    notifyListeners();
  }

  Future<Map<String, dynamic>?> fetchAddressInfoByPlaceId(String input) async {
    var response = await sl<GoogleRepository>().addressInfoByPlaceId(input);
    suggestions.clear();
    if (response != null) addressInfo = response;
    notifyListeners();
    return response;
  }

  Future<Map<String, dynamic>?> fetchAddressInfoByCoordinates(Coordinates coordinates) async {
    var response = await sl<GoogleRepository>().addressInfoByCoordinates(coordinates);
    suggestions.clear();
    if (response != null) addressInfo = response;
    notifyListeners();
    return response;
  }

  Future<void> onCreateOrUpdateAddress(Address item) async {
    loader = true;
    notifyListeners();
    var isAddress = item.id == null;
    var context = navigatorKey.currentState!.context;
    var coordinates = addressInfo?['coordinates'] as Coordinates;
    var addressLabel = item.label.toKey == 'home'.toKey ? 'home' : 'other';
    var body = {
      'place_id': addressInfo?['place_id'],
      'address_line_1': addressInfo?['address'],
      'city': addressInfo?['city'],
      'latitude': coordinates.lat,
      'longitude': coordinates.lng,
      'state': addressInfo?['state'],
      'zip_code': addressInfo?['postal_code'],
      'country_id': country.id,
      'label': addressLabel,
    };
    var repo = sl<AddressRepository>();
    var response = isAddress ? await repo.createAddress(body) : await repo.updateAddress(body, item);
    loader = false;
    if (response == null) return notifyListeners();
    notifyListeners();
    var addressModel = Provider.of<SellerSettingsViewModel>(context, listen: false);
    addressModel.updateAddressItem(addressItem: response, isAdd: isAddress);
    backToPrevious();
  }
}
