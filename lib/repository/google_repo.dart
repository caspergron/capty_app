import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:app/models/map/coordinates.dart';
import 'package:app/utils/api_url.dart';

class GoogleRepository {
  Future<List<dynamic>> fetchPredictions(String input, Coordinates coordinates, String countryCode) async {
    var headers = {'Accept': 'application/json'};
    var position = '${coordinates.lat},${coordinates.lng}';
    var endpoint = '$GOOGLE_API_AUTOCOMPLETE&input=$input&location=$position&radius=2000&components=country:$countryCode';
    var response = await http.get(Uri.parse(endpoint), headers: headers);
    if (response.statusCode != 200) return [];
    var json = jsonDecode(response.body);
    return json['predictions'];
  }

  Future<Map<String, dynamic>?> addressInfoByPlaceId(String placeId) async {
    var headers = {'Accept': 'application/json'};
    var endpoint = '$GOOGLE_API&place_id=$placeId';
    var response = await http.get(Uri.parse(endpoint), headers: headers);
    if (response.statusCode != 200) return null;
    var json = jsonDecode(response.body);
    if (json['results'] == null || json['results'].isEmpty) return null;
    var addressData = json['results'][0];
    var address = addressData['formatted_address'];
    var position = addressData['geometry']['location'];
    var coordinates = Coordinates(lat: position['lat'], lng: position['lng']);
    var components = addressData['address_components'] as List;
    var city = '';
    var postalCode = '';
    var state = '';
    for (var component in components) {
      var types = component['types'] as List;
      if (types.contains('locality')) city = component['long_name'];
      if (types.contains('postal_code')) postalCode = component['long_name'];
      if (types.contains('administrative_area_level_1')) state = component['long_name'];
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

    if (address == null || !coordinates.is_coordinate || city.isEmpty || postalCode.isEmpty) return null;
    return {'address': address, 'coordinates': coordinates, 'city': city, 'state': state, 'postal_code': postalCode};
  }

  Future<Map<String, dynamic>?> addressInfoByCoordinates(Coordinates coordinates) async {
    var headers = {'Accept': 'application/json'};
    var endpoint = '$GOOGLE_API&latlng=${coordinates.lat},${coordinates.lng}';
    var response = await http.get(Uri.parse(endpoint), headers: headers);
    if (response.statusCode != 200) return null;
    var json = jsonDecode(response.body);
    if (json['results'] == null || json['results'].isEmpty) return null;
    var addressData = json['results'][0];
    var address = addressData['formatted_address'];
    var components = addressData['address_components'] as List;
    var city = '';
    var postalCode = '';
    var state = '';
    for (var component in components) {
      var types = component['types'] as List;
      if (types.contains('locality')) city = component['long_name'];
      if (types.contains('postal_code')) postalCode = component['long_name'];
      if (types.contains('administrative_area_level_1')) state = component['long_name'];
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

    // print({'address': address, 'coordinates': coordinates, 'city': city, 'state': state, 'postal_code': postalCode});
    if (address == null || city.isEmpty || postalCode.isEmpty || state.isEmpty) return null;
    return {'address': address, 'coordinates': coordinates, 'city': city, 'state': state, 'postal_code': postalCode};
  }

  Future<Coordinates?> coordinatesOfACountry({required String countryCode}) async {
    var headers = {'Accept': 'application/json'};
    var endpoint = '$GOOGLE_API&components=country:$countryCode';
    var response = await http.get(Uri.parse(endpoint), headers: headers);
    if (response.statusCode != 200) return null;
    var json = jsonDecode(response.body);
    if (json['results'] == null || json['results'].isEmpty) return null;
    var location = json['results'][0]['geometry']['location'];
    var coordinates = Coordinates(lat: location['lat'], lng: location['lat']);
    return coordinates;
  }

/*Future<LatLng?> coordinatesFromPlaceId(String placeId) async {
    var headers = {'Accept': 'application/json'};
    var endpoint = '$GOOGLE_API&placeid=$placeId';
    var response = await http.get(Uri.parse(endpoint), headers: headers);
    if (response.statusCode != 200) return null;
    var json = jsonDecode(response.body);
    var locationData = json['result']['geometry']['location'];
    return LatLng(locationData['lat'], locationData['lng']);
  }*/
}
