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
    final endpoint = ApiUrl.user.profile;
    final apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return User();
    final userInfo = User.fromJson(apiResponse.response['data']['user']);
    UserPreferences.user = userInfo;
    sl<StorageService>().setUser(userInfo);
    return userInfo;
  }

  Future<DashboardCount?> fetchDashboardCount() async {
    final endpoint = ApiUrl.user.dashboardCount;
    final apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return null;
    return DashboardCount.fromJson(apiResponse.response['data']);
  }

  Future<User?> updateProfileInfo(Map<String, dynamic> body) async {
    final endpoint = ApiUrl.user.updateProfile;
    final apiResponse = await sl<ApiInterceptor>().putRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) {
      if (!apiResponse.response.containsKey('message')) return null;
      final isMessage = apiResponse.response['message'].toString().toKey == 'PDGA number already exists.'.toKey;
      if (isMessage) FlushPopup.onWarning(message: 'pdga_number_already_used_please_try_your_unique_pdga_number'.recast);
      return null;
    } else {
      final userInfo = User.fromJson(apiResponse.response['data']['user']);
      UserPreferences.user = userInfo;
      sl<StorageService>().setUser(userInfo);
      return userInfo;
    }
  }

  Future<bool> deleteMedia(Map<String, dynamic> body) async {
    final endpoint = ApiUrl.user.deleteMedia;
    final apiResponse = await sl<ApiInterceptor>().deleteRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) return false;
    return true;
  }

  Future<Media?> uploadMultipartMedia(Map<String, String> body, DocFile docFile) async {
    final endpoint = ApiUrl.user.uploadMultipartMedia;
    final request = MultipartRequest('POST', Uri.parse(endpoint));
    // final fileType = sl<FileHelper>().getFileType(docFile.file?.path);
    request.fields.addAll(body);
    request.files.add(await MultipartFile.fromPath('files', docFile.file!.path));
    request.headers.addAll(await sl<HttpModule>().httpHeaders);
    final apiResponse = await sl<ApiInterceptor>().multipartRequest(request: request);
    if (apiResponse.status != 200) return null;
    final mediaApi = MediaApi.fromJson(apiResponse.response);
    return mediaApi.mediaList.haveList ? mediaApi.mediaList!.first : null;
  }

  Future<Media?> uploadBase64Media(Map<String, String> body) async {
    final endpoint = ApiUrl.user.uploadBase64Media;
    final apiResponse = await sl<ApiInterceptor>().postRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) return null;
    return Media.fromJson(apiResponse.response['data']);
  }

  /*Future<List<UserDisc>> fetchTournamentDiscs() async {
    final endpoint = ApiUrl.user.tournamentDisc;
    final apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    final discBag = DiscBag.fromJson(apiResponse.response['data']);
    return discBag.userDiscs ?? [];
  }*/

  Future<List<Tournament>> fetchPlayerTournamentInfo() async {
    final endpoint = ApiUrl.user.tournamentInfo;
    final apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    final tournamentApi = TournamentApi.fromJson(apiResponse.response);
    return tournamentApi.tournaments ?? [];
  }

  Future<User?> updateLeaderboardSharing(Map<String, dynamic> body) async {
    final endpoint = ApiUrl.user.updateProfile;
    final apiResponse = await sl<ApiInterceptor>().putRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) return null;
    final userInfo = User.fromJson(apiResponse.response['data']['user']);
    UserPreferences.user = userInfo;
    sl<StorageService>().setUser(userInfo);
    return userInfo;
  }

  Future<bool> signOut() async {
    final endpoint = ApiUrl.user.signOut;
    final apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    return apiResponse.status == 200;
  }

  Future<bool> deleteAccount() async {
    final endpoint = ApiUrl.user.deleteAccount;
    final apiResponse = await sl<ApiInterceptor>().deleteRequest(endpoint: endpoint);
    return apiResponse.status == 200;
  }
}
