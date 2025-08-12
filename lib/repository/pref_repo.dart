import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/interfaces/api_interceptor.dart';
import 'package:app/libraries/flush_popup.dart';
import 'package:app/models/feature/feature.dart';
import 'package:app/models/feature/feature_comment.dart';
import 'package:app/models/feature/features_api.dart';
import 'package:app/models/settings/report.dart';
import 'package:app/models/settings/settings.dart';
import 'package:app/preferences/user_preferences.dart';
import 'package:app/utils/api_url.dart';

class PreferencesRepository {
  Future<Settings?> fetchAllPreferences() async {
    var endpoint = ApiUrl.pref.userPreferences;
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return null;
    return Settings.fromJson(apiResponse.response['data']['preferences']);
  }

  Future<Settings?> updateCurrency(Map<String, dynamic> body) async {
    var endpoint = '${ApiUrl.pref.updatePreference}/${UserPreferences.user.id}';
    var apiResponse = await sl<ApiInterceptor>().putRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) return null;
    FlushPopup.onSuccess(message: 'currency_updated_successfully'.recast);
    return Settings.fromJson(apiResponse.response['data']['preferences']);
  }

  Future<Settings?> updatePreferences(Map<String, dynamic> body) async {
    var endpoint = '${ApiUrl.pref.updatePreference}/${UserPreferences.user.id}';
    var apiResponse = await sl<ApiInterceptor>().putRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) return null;
    return Settings.fromJson(apiResponse.response['data']['preferences']);
  }

  Future<Report?> createReport(Map<String, dynamic> body) async {
    var endpoint = ApiUrl.pref.reportProblem;
    var apiResponse = await sl<ApiInterceptor>().postRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) return null;
    FlushPopup.onSuccess(message: 'report_sent_successfully'.recast);
    return Report.fromJson(apiResponse.response['data']);
  }

  Future<List<Feature>> fetchSuggestedFeaturesList() async {
    var endpoint = ApiUrl.pref.suggestedFeaturesList;
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    var featureApi = FeaturesApi.fromJson(apiResponse.response);
    return featureApi.features.haveList ? featureApi.features! : [];
  }

  Future<Feature?> createSuggestFeature(Map<String, dynamic> body) async {
    var endpoint = ApiUrl.pref.createSuggestedFeature;
    var apiResponse = await sl<ApiInterceptor>().postRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) return null;
    FlushPopup.onSuccess(message: 'suggestion_sent_successfully'.recast);
    return Feature.fromJson(apiResponse.response['data']);
  }

  Future<Feature?> voteOnAFeature(Map<String, dynamic> body) async {
    var endpoint = ApiUrl.pref.voteOnAFeature;
    var apiResponse = await sl<ApiInterceptor>().postRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) return null;
    FlushPopup.onInfo(message: 'vote_successful'.recast);
    return Feature.fromJson(apiResponse.response['data']);
  }

  Future<Feature?> fetchFeatureDetails(Feature feature) async {
    var endpoint = '${ApiUrl.pref.featureDetails}${feature.id}';
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return null;
    return Feature.fromJson(apiResponse.response['data']);
  }

  Future<FeatureComment?> postFeatureComment(Map<String, dynamic> body) async {
    var endpoint = ApiUrl.pref.postFeatureComment;
    var apiResponse = await sl<ApiInterceptor>().postRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) return null;
    return FeatureComment.fromJson(apiResponse.response['data']);
  }
}
