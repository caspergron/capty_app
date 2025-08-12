import 'package:location/location.dart';

import 'package:app/models/map/coordinates.dart';
import 'package:app/preferences/user_preferences.dart';

// import 'package:geocoding/geocoding.dart';

class Locations {
  final _location = Location();

  Future<Coordinates> fetchLocationPermission() async {
    if (!await _isServiceEnabled) return Coordinates();
    var permissionStatus = await _location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await _location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) return Coordinates();
    }
    var locationData = await _location.getLocation();
    var coordinates = Coordinates(lat: locationData.latitude, lng: locationData.longitude);
    UserPreferences.coordinates = coordinates;
    return coordinates;
  }

  Future<bool> get _isServiceEnabled async {
    var isEnabled = await _location.serviceEnabled();
    if (isEnabled) return true;
    isEnabled = await _location.requestService();
    return isEnabled;
  }

  /*Future<String?> fetchLocationNameFromCoordinates(Coordinates coordinates) async {
    var placeMarks = await placemarkFromCoordinates(coordinates.lat!, coordinates.lng!);
    if (placeMarks.isEmpty) return null;
    var placeMark = placeMarks.first;
    return placeMark.subLocality;
  }*/
}
