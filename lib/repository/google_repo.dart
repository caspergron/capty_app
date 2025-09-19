import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:app/models/map/coordinates.dart';
import 'package:app/utils/api_url.dart';

class GoogleRepository {
  Future<List<dynamic>> fetchPredictions(String input, Coordinates coordinates, String countryCode) async {
    final headers = {'Accept': 'application/json'};
    final position = '${coordinates.lat},${coordinates.lng}';
    final endpoint = '$GOOGLE_API_AUTOCOMPLETE&input=$input&location=$position&radius=2000&components=country:$countryCode';
    final response = await http.get(Uri.parse(endpoint), headers: headers);
    if (response.statusCode != 200) return [];
    final json = jsonDecode(response.body);
    return json['predictions'];
  }

  Future<Map<String, dynamic>?> addressInfoByPlaceId(String placeId) async {
    final headers = {'Accept': 'application/json'};
    final endpoint = '$GOOGLE_API&place_id=$placeId';
    final response = await http.get(Uri.parse(endpoint), headers: headers);
    if (response.statusCode != 200) return null;
    final json = jsonDecode(response.body);
    if (json['results'] == null || json['results'].isEmpty) return null;
    final addressData = json['results'][0];
    final address = addressData['formatted_address'];
    final position = addressData['geometry']['location'];
    final coordinates = Coordinates(lat: position['lat'], lng: position['lng']);
    final components = addressData['address_components'] as List;
    var city = '';
    var postalCode = '';
    var state = '';
    for (final component in components) {
      final types = component['types'] as List;
      if (types.contains('locality')) city = component['long_name'];
      if (types.contains('postal_code')) postalCode = component['long_name'];
      if (types.contains('administrative_area_level_1')) state = component['long_name'];
    }

    // print({'address': address, 'coordinates': coordinates, 'city': city, 'state': state, 'postal_code': postalCode, 'place_id': placeId});
    if (address == null || !coordinates.is_coordinate) return null;
    return {'address': address, 'coordinates': coordinates, 'city': city, 'state': state, 'postal_code': postalCode, 'place_id': placeId};
  }

  Future<Map<String, dynamic>?> addressInfoByCoordinates(Coordinates coordinates) async {
    final headers = {'Accept': 'application/json'};
    final endpoint = '$GOOGLE_API&latlng=${coordinates.lat},${coordinates.lng}';
    final response = await http.get(Uri.parse(endpoint), headers: headers);
    if (response.statusCode != 200) return null;
    final json = jsonDecode(response.body);
    if (json['results'] == null || json['results'].isEmpty) return null;
    final addressData = json['results'][0];
    final address = addressData['formatted_address'];
    final placeId = addressData['place_id'] ?? '';
    final components = addressData['address_components'] as List;
    var city = '';
    var postalCode = '';
    var state = '';
    for (final component in components) {
      final types = component['types'] as List;
      if (types.contains('locality')) city = component['long_name'];
      if (types.contains('postal_code')) postalCode = component['long_name'];
      if (types.contains('administrative_area_level_1')) state = component['long_name'];
    }
    if (address == null) return null;
    return {'address': address, 'coordinates': coordinates, 'city': city, 'state': state, 'postal_code': postalCode, 'place_id': placeId};
  }

  Future<Coordinates?> coordinatesOfACountry({required String countryCode}) async {
    final headers = {'Accept': 'application/json'};
    final endpoint = '$GOOGLE_API&components=country:$countryCode';
    final response = await http.get(Uri.parse(endpoint), headers: headers);
    if (response.statusCode != 200) return null;
    final json = jsonDecode(response.body);
    if (json['results'] == null || json['results'].isEmpty) return null;
    final location = json['results'][0]['geometry']['location'];
    final coordinates = Coordinates(lat: location['lat'], lng: location['lat']);
    return coordinates;
  }

/*Future<LatLng?> coordinatesFromPlaceId(String placeId) async {
    final headers = {'Accept': 'application/json'};
    final endpoint = '$GOOGLE_API&placeid=$placeId';
    final response = await http.get(Uri.parse(endpoint), headers: headers);
    if (response.statusCode != 200) return null;
    final json = jsonDecode(response.body);
    final locationData = json['result']['geometry']['location'];
    return LatLng(locationData['lat'], locationData['lng']);
  }*/
}

/*if (address == null) {
      FlushPopup.onInfo(message: 'address_information_not_found'.recast);
      return null;
    } else if (!coordinates.is_coordinate) {
      FlushPopup.onInfo(message: 'address_coordinates_not_found'.recast);
      return null;
    } else if (city.isEmpty) {
      FlushPopup.onInfo(message: 'city_not_found'.recast);
      return null;
    } else if (state.isEmpty) {
      FlushPopup.onInfo(message: 'state_not_found'.recast);
      return null;
    } else if (postalCode.isEmpty) {
      FlushPopup.onInfo(message: 'postal_code_not_found'.recast);
      return null;
    } else {
      return {'address': address, 'coordinates': coordinates, 'city': city, 'state': state, 'postal_code': postalCode};
    }*/
