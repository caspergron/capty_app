import 'package:app/constants/app_keys.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/auth/view_models/otp_view_model.dart';
import 'package:app/features/auth/view_models/set_profile_view_model.dart';
import 'package:app/features/auth/view_models/sign_in_view_model.dart';
import 'package:app/features/club/view_models/club_view_model.dart';
import 'package:app/features/discs/view_models/discs_view_model.dart';
import 'package:app/features/friends/view_models/friends_view_model.dart';
import 'package:app/features/home/home_view_model.dart';
import 'package:app/features/landing/landing_view_model.dart';
import 'package:app/features/marketplace/view_models/marketplace_view_model.dart';
import 'package:app/interfaces/api_interceptor.dart';
import 'package:app/libraries/flush_popup.dart';
import 'package:app/libraries/formatters.dart';
import 'package:app/models/club/club.dart';
import 'package:app/models/club/clubs_api.dart';
import 'package:app/models/common/brand.dart';
import 'package:app/models/common/brands_api.dart';
import 'package:app/models/common/tag.dart';
import 'package:app/models/common/tags_api.dart';
import 'package:app/models/map/coordinates.dart';
import 'package:app/models/marketplace/marketplace_api.dart';
import 'package:app/models/marketplace/marketplace_category.dart';
import 'package:app/models/marketplace/sales_ad.dart';
import 'package:app/models/public/app_statistics.dart';
import 'package:app/models/public/country.dart';
import 'package:app/models/public/country_api.dart';
import 'package:app/models/public/currency.dart';
import 'package:app/models/public/currency_api.dart';
import 'package:app/models/public/language.dart';
import 'package:app/models/public/language_api.dart';
import 'package:app/preferences/app_preferences.dart';
import 'package:app/preferences/user_preferences.dart';
import 'package:app/services/storage_service.dart';
import 'package:app/utils/api_url.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

class PublicRepository {
  Future<List<Country>> fetchCountries() async {
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: ApiUrl.public.countries);
    if (apiResponse.status != 200) return [];
    var countryApi = CountryApi.fromJson(apiResponse.response);
    var countries = countryApi.countries ?? [];
    if (countries.isEmpty) return [];
    var validCountries = countries.where((item) => item.currency?.id != null).toList();
    if (validCountries.isEmpty) return [];
    validCountries.sort((item1, item2) => item1.name!.compareTo(item2.name!));
    return validCountries;
  }

  Future<List<Currency>> fetchCurrencies() async {
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: ApiUrl.public.currencies);
    if (apiResponse.status != 200) return [];
    var currenciesApi = CurrencyApi.fromJson(apiResponse.response);
    return currenciesApi.currencies.haveList ? currenciesApi.currencies! : [];
  }

  Future<List<Language>> fetchLanguages() async {
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: ApiUrl.public.languages);
    if (apiResponse.status != 200) return [];
    var languageApi = LanguageApi.fromJson(apiResponse.response);
    return languageApi.languages.haveList ? languageApi.languages! : [];
  }

  Future<Map<String, dynamic>?> fetchTranslations(Language language) async {
    var endpoint = '${ApiUrl.public.translations}${language.code ?? 'en'}';
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return null;
    var translations = apiResponse.response['data'];
    if (translations == null) return null;
    await initializeDateFormatting(language.code);
    Formatters.registerTimeAgoLocales(language.code ?? 'en');
    sl<StorageService>().setLanguage(language);
    sl<StorageService>().setTranslations(translations);
    AppPreferences.setLanguage(language);
    AppPreferences.setTranslations(translations);
    _updateStatesForLanguages();
    FlushPopup.onInfo(message: '${'your_language'.recast} ${language.name ?? ''}');
    return translations;
  }

  Future<List<Club>> findClubs(Coordinates coordinates, {int distance = 50}) async {
    var userId = UserPreferences.user.id;
    // var params = '?latitude=56.3876239&longitude=9.7604105&user_id=$userId&distance=$distance';
    var params = '?latitude=${coordinates.lat}&longitude=${coordinates.lng}&user_id=$userId&distance=$distance';
    var endpoint = '${ApiUrl.public.findClub}$params';
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    var clubsApi = ClubsApi.fromJson(apiResponse.response);
    return clubsApi.clubs.haveList ? clubsApi.clubs! : [];
  }

  void _updateStatesForLanguages() {
    var context = navigatorKey.currentState!.context;
    Provider.of<SignInViewModel>(context, listen: false).updateUi();
    Provider.of<OtpViewModel>(context, listen: false).updateUi();
    Provider.of<SetProfileViewModel>(context, listen: false).updateUi();
    Provider.of<LandingViewModel>(context, listen: false).updateUi();
    Provider.of<HomeViewModel>(context, listen: false).updateUi();
    Provider.of<ClubViewModel>(context, listen: false).updateUi();
    Provider.of<FriendsViewModel>(context, listen: false).updateUi();
    Provider.of<DiscsViewModel>(context, listen: false).updateUi();
    Provider.of<MarketplaceViewModel>(context, listen: false).updateUi();
  }

  Future<bool> addInWaitlist(Map<String, dynamic> body) async {
    var endpoint = ApiUrl.public.addInWaitlist;
    var apiResponse = await sl<ApiInterceptor>().postRequest(endpoint: endpoint, body: body);
    if (apiResponse.status == 200) return true;
    FlushPopup.onInfo(message: 'we_already_have_your_request'.recast);
    return false;
  }

  Future<bool> storeAppLogError(Map<String, dynamic> body) async {
    var endpoint = ApiUrl.public.logError;
    var apiResponse = await sl<ApiInterceptor>().postRequest(endpoint: endpoint, body: body);
    return apiResponse.status == 200;
  }

  Future<AppStatistics?> fetchAppStatistics() async {
    var endpoint = ApiUrl.public.appStatistics;
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return null;
    return AppStatistics.fromJson(apiResponse.response['data']);
  }

  Future<List<MarketplaceCategory>> fetchSalesAdsByCountry(String params) async {
    var endpoint = '${ApiUrl.public.marketplaceDiscsByCountry}$params';
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    var marketplaceApi = MarketplaceApi.fromJson(apiResponse.response);
    return marketplaceApi.categories.haveList ? marketplaceApi.categories! : [];
  }

  Future<SalesAd?> fetchMarketplaceDetails(String params) async {
    var endpoint = '${ApiUrl.public.marketplaceDetails}$params';
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return null;
    return SalesAd.fromJson(apiResponse.response['data']);
  }

  Future<List<Brand>> fetchAllBrands() async {
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: ApiUrl.public.allBrands);
    if (apiResponse.status != 200) return [];
    var brandsApi = BrandsApi.fromJson(apiResponse.response);
    return brandsApi.brands ?? [];
  }

  Future<List<Tag>> fetchDiscTypes() async {
    var endpoint = '${ApiUrl.user.tagList}?is_vertical=1';
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    var tagsApi = TagsApi.fromJson(apiResponse.response);
    return tagsApi.tags.haveList ? tagsApi.tags! : [];
  }
}
