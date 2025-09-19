import 'package:app/di.dart';
import 'package:app/extensions/number_ext.dart';
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
    final endpoint = ApiUrl.pref.userPreferences;
    final apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return null;
    return Settings.fromJson(apiResponse.response['data']['preferences']);
  }

  Future<Settings?> updateCurrency(Map<String, dynamic> body) async {
    final endpoint = '${ApiUrl.pref.updatePreference}/${UserPreferences.user.id}';
    final apiResponse = await sl<ApiInterceptor>().putRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) return null;
    FlushPopup.onSuccess(message: 'currency_updated_successfully'.recast);
    return Settings.fromJson(apiResponse.response['data']['preferences']);
  }

  Future<Settings?> updatePreferences(Map<String, dynamic> body) async {
    final endpoint = '${ApiUrl.pref.updatePreference}/${UserPreferences.user.id}';
    final apiResponse = await sl<ApiInterceptor>().putRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) return null;
    return Settings.fromJson(apiResponse.response['data']['preferences']);
  }

  Future<Report?> createReport(Map<String, dynamic> body) async {
    final endpoint = ApiUrl.pref.reportProblem;
    final apiResponse = await sl<ApiInterceptor>().postRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) return null;
    FlushPopup.onSuccess(message: 'report_sent_successfully'.recast);
    return Report.fromJson(apiResponse.response['data']);
  }

  Future<List<Feature>> fetchSuggestedFeaturesList() async {
    final endpoint = ApiUrl.pref.suggestedFeaturesList;
    final apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    final featureApi = FeaturesApi.fromJson(apiResponse.response);
    final features = featureApi.features ?? [];
    if (features.isEmpty) return [];
    features.sort((item1, item2) => item2.totalVotes.nullToInt.compareTo(item1.totalVotes.nullToInt));
    return features;
  }

  Future<Feature?> createSuggestFeature(Map<String, dynamic> body) async {
    final endpoint = ApiUrl.pref.createSuggestedFeature;
    final apiResponse = await sl<ApiInterceptor>().postRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) return null;
    FlushPopup.onSuccess(message: 'suggestion_sent_successfully'.recast);
    return Feature.fromJson(apiResponse.response['data']);
  }

  Future<Feature?> voteOnAFeature(Map<String, dynamic> body) async {
    final endpoint = ApiUrl.pref.voteOnAFeature;
    final apiResponse = await sl<ApiInterceptor>().postRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) return null;
    FlushPopup.onInfo(message: 'vote_successful'.recast);
    return Feature.fromJson(apiResponse.response['data']);
  }

  Future<Feature?> fetchFeatureDetails(Feature feature) async {
    final endpoint = '${ApiUrl.pref.featureDetails}${feature.id}';
    final apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return null;
    return Feature.fromJson(apiResponse.response['data']);
  }

  Future<FeatureComment?> postFeatureComment(Map<String, dynamic> body) async {
    final endpoint = ApiUrl.pref.postFeatureComment;
    final apiResponse = await sl<ApiInterceptor>().postRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) return null;
    return FeatureComment.fromJson(apiResponse.response['data']);
  }
}
