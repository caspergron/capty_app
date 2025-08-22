import 'package:http/http.dart';

import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/interfaces/api_interceptor.dart';
import 'package:app/interfaces/http_module.dart';
import 'package:app/libraries/flush_popup.dart';
import 'package:app/models/common/media.dart';
import 'package:app/models/common/media_api.dart';
import 'package:app/models/common/tournament.dart';
import 'package:app/models/common/tournament_api.dart';
import 'package:app/models/system/doc_file.dart';
import 'package:app/models/user/dashboard_count.dart';
import 'package:app/models/user/user.dart';
import 'package:app/preferences/user_preferences.dart';
import 'package:app/services/storage_service.dart';
import 'package:app/utils/api_url.dart';

class UserRepository {
  Future<User> fetchProfileInfo() async {
    var endpoint = ApiUrl.user.profile;
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return User();
    var userInfo = User.fromJson(apiResponse.response['data']['user']);
    UserPreferences.user = userInfo;
    sl<StorageService>().setUser(userInfo);
    return userInfo;
  }

  Future<DashboardCount?> fetchDashboardCount() async {
    var endpoint = ApiUrl.user.dashboardCount;
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return null;
    return DashboardCount.fromJson(apiResponse.response['data']);
  }

  Future<User?> updateProfileInfo(Map<String, dynamic> body) async {
    var endpoint = ApiUrl.user.updateProfile;
    var apiResponse = await sl<ApiInterceptor>().putRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) {
      if (!apiResponse.response.containsKey('message')) return null;
      var isMessage = apiResponse.response['message'].toString().toKey == 'PDGA number already exists.'.toKey;
      if (isMessage) FlushPopup.onWarning(message: 'pdga_number_already_used_please_try_your_unique_pdga_number'.recast);
      return null;
    } else {
      var userInfo = User.fromJson(apiResponse.response['data']['user']);
      UserPreferences.user = userInfo;
      sl<StorageService>().setUser(userInfo);
      return userInfo;
    }
  }

  Future<bool> deleteMedia(Map<String, dynamic> body) async {
    var endpoint = ApiUrl.user.deleteMedia;
    var apiResponse = await sl<ApiInterceptor>().deleteRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) return false;
    return true;
  }

  Future<Media?> uploadMultipartMedia(Map<String, String> body, DocFile docFile) async {
    var endpoint = ApiUrl.user.uploadMultipartMedia;
    var request = MultipartRequest('POST', Uri.parse(endpoint));
    // var fileType = sl<FileHelper>().getFileType(docFile.file?.path);
    request.fields.addAll(body);
    request.files.add(await MultipartFile.fromPath('files', docFile.file!.path));
    request.headers.addAll(await sl<HttpModule>().httpHeaders);
    var apiResponse = await sl<ApiInterceptor>().multipartRequest(request: request);
    if (apiResponse.status != 200) return null;
    var mediaApi = MediaApi.fromJson(apiResponse.response);
    return mediaApi.mediaList.haveList ? mediaApi.mediaList!.first : null;
  }

  Future<Media?> uploadBase64Media(Map<String, String> body) async {
    var endpoint = ApiUrl.user.uploadBase64Media;
    var apiResponse = await sl<ApiInterceptor>().postRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) return null;
    return Media.fromJson(apiResponse.response['data']);
  }

  /*Future<List<UserDisc>> fetchTournamentDiscs() async {
    var endpoint = ApiUrl.user.tournamentDisc;
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    var discBag = DiscBag.fromJson(apiResponse.response['data']);
    return discBag.userDiscs ?? [];
  }*/

  Future<List<Tournament>> fetchPlayerTournamentInfo() async {
    var endpoint = ApiUrl.user.tournamentInfo;
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    var tournamentApi = TournamentApi.fromJson(apiResponse.response);
    return tournamentApi.tournaments ?? [];
  }

  Future<bool> signOut() async {
    var endpoint = ApiUrl.user.signOut;
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    return apiResponse.status == 200;
  }

  Future<bool> deleteAccount() async {
    var endpoint = ApiUrl.user.deleteAccount;
    var apiResponse = await sl<ApiInterceptor>().deleteRequest(endpoint: endpoint);
    return apiResponse.status == 200;
  }
}
