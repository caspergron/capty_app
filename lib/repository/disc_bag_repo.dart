import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/interfaces/api_interceptor.dart';
import 'package:app/libraries/flush_popup.dart';
import 'package:app/models/disc_bag/disc_bag.dart';
import 'package:app/models/disc_bag/disc_bag_api.dart';
import 'package:app/utils/api_url.dart';

class DiscBagRepository {
  Future<DiscBag?> createDiscBag(Map<String, dynamic> body) async {
    var endpoint = ApiUrl.user.createBag;
    var apiResponse = await sl<ApiInterceptor>().postRequest(endpoint: endpoint, body: body);
    if (apiResponse.status == 200) {
      FlushPopup.onInfo(message: 'bag_created_successfully'.recast);
      return DiscBag.fromJson(apiResponse.response['data']);
    } else {
      if (!apiResponse.response.containsKey('message')) return null;
      var isMessage = apiResponse.response['message'].toString().toKey == 'You already have a bag with this name.'.toKey;
      if (isMessage) FlushPopup.onError(message: 'you_already_have_a_bag_with_this_name'.recast);
      return null;
    }
  }

  Future<List<DiscBag>> fetchDiscBags({int page = 1}) async {
    var endpoint = '${ApiUrl.user.bagList}$page';
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    var bagsApi = DiscBagApi.fromJson(apiResponse.response);
    if (!bagsApi.discBags.haveList) return [];
    var bags = bagsApi.discBags!;
    bags.forEach((bag) => !bag.userDiscs.haveList ? bag.userDiscs = [] : bag.userDiscs!.forEach((disc) => disc.bagId = bag.id));
    return bags;
  }

  Future<DiscBag?> fetchDiscBagDetails(DiscBag bag) async {
    var endpoint = '${ApiUrl.user.bagDetails}${bag.id}';
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return null;
    return DiscBag.fromJson(apiResponse.response['data']);
  }

  Future<bool> moveDiscToAnotherBag(Map<String, dynamic> body) async {
    var endpoint = ApiUrl.user.moveDisc;
    var apiResponse = await sl<ApiInterceptor>().putRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) return false;
    return true;
    // return DiscBag.fromJson(apiResponse.response['data']);
  }

  Future<bool> deleteDiscBag(int bagId) async {
    var endpoint = '${ApiUrl.user.deleteDiscBag}$bagId';
    var apiResponse = await sl<ApiInterceptor>().deleteRequest(endpoint: endpoint);
    return apiResponse.status == 200;
  }
}
