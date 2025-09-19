import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/interfaces/api_interceptor.dart';
import 'package:app/libraries/flush_popup.dart';
import 'package:app/libraries/toasts_popups.dart';
import 'package:app/models/friend/friend.dart';
import 'package:app/models/friend/friend_info.dart';
import 'package:app/models/friend/friends_api.dart';
import 'package:app/models/friend/search_friend_api.dart';
import 'package:app/utils/api_url.dart';

class FriendRepository {
  Future<List<Friend>> fetchAllFriends({int page = 1}) async {
    final endpoint = '${ApiUrl.user.friendList}$page';
    final apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    final friendsApi = FriendsApi.fromJson(apiResponse.response);
    return friendsApi.friends.haveList ? friendsApi.friends! : [];
  }

  Future<FriendInfo?> searchForFriend(String query) async {
    final endpoint = '${ApiUrl.user.searchUserForFriend}$query';
    final apiResponse = await sl<ApiInterceptor>().postRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return null;
    final friendApi = SearchFriendApi.fromJson(apiResponse.response);
    final haveFriends = friendApi.friends.haveList;
    final notFriendIssue = '${'we_could_not_find_your_friend'.recast}. ${'please_ask_your_friend_to_sign_up_in_capty'.recast}';
    if (!haveFriends) FlushPopup.onInfo(message: notFriendIssue);
    if (!haveFriends) return null;
    final friend = friendApi.friends!.first;
    final isFriend = friend.isFriend != null && friend.isFriend! && friend.friendStatus != null && friend.friendStatus == 1;
    if (isFriend) FlushPopup.onInfo(message: 'already_added_as_friend'.recast);
    if (isFriend) return null;
    return friend;
  }

  Future<Friend?> sendFriendRequest(Map<String, dynamic> body) async {
    final endpoint = ApiUrl.user.sentRequestForFriend;
    final apiResponse = await sl<ApiInterceptor>().postRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) return null;
    ToastPopup.onInfo(message: 'request_sent_successfully'.recast);
    return Friend.fromJson(apiResponse.response['data']);
  }

  Future<Friend?> acceptFriendRequest(int friendId) async {
    final endpoint = '${ApiUrl.user.acceptFriendRequest}$friendId';
    final apiResponse = await sl<ApiInterceptor>().postRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return null;
    return Friend.fromJson(apiResponse.response['data']);
  }

  Future<bool> rejectFriendRequest(int friendId) async {
    final endpoint = '${ApiUrl.user.rejectFriendRequest}$friendId';
    final apiResponse = await sl<ApiInterceptor>().postRequest(endpoint: endpoint);
    // ToastPopup.onInfo(message: 'request_rejected'.recast);
    return apiResponse.status == 200;
  }

  Future<List<Friend>> fetchAllFriendRequests() async {
    final endpoint = ApiUrl.user.friendRequestList;
    final apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    final friendsApi = FriendsApi.fromJson(apiResponse.response);
    return friendsApi.friends.haveList ? friendsApi.friends! : [];
  }
}
