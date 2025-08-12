import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/interfaces/api_interceptor.dart';
import 'package:app/libraries/flush_popup.dart';
import 'package:app/models/club/club.dart';
import 'package:app/models/club/club_comment.dart';
import 'package:app/models/club/club_comments_api.dart';
import 'package:app/models/club/clubs_api.dart';
import 'package:app/models/club/course.dart';
import 'package:app/models/club/courses_api.dart';
import 'package:app/models/club/event.dart';
import 'package:app/models/club/events_api.dart';
import 'package:app/models/map/coordinates.dart';
import 'package:app/utils/api_url.dart';

class ClubRepository {
  Future<Club?> createClub(Map<String, dynamic> body) async {
    var endpoint = ApiUrl.user.createClub;
    var apiResponse = await sl<ApiInterceptor>().postRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) return null;
    FlushPopup.onInfo(message: 'club_created_successfully'.recast);
    return Club.fromJson(apiResponse.response['data']);
  }

  Future<bool> createClubCourse(Map<String, dynamic> body) async {
    var endpoint = ApiUrl.user.createClubCourse;
    var apiResponse = await sl<ApiInterceptor>().postRequest(endpoint: endpoint, body: body);
    return apiResponse.status == 200;
  }

  Future<List<Club>> fetchUserClubs() async {
    var endpoint = ApiUrl.user.userClubs;
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    var clubsApi = ClubsApi.fromJson(apiResponse.response);
    return clubsApi.clubs.haveList ? clubsApi.clubs! : [];
  }

  Future<Club?> fetchDefaultClubInfo() async {
    var endpoint = ApiUrl.user.defaultClubInfo;
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return null;
    return Club.fromJson(apiResponse.response['data']);
  }

  Future<Club?> fetchClubDetails(Club club) async {
    var endpoint = '${ApiUrl.user.clubDetails}/${club.id}';
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return null;
    return Club.fromJson(apiResponse.response['data']);
  }

  Future<List<Club>> searchClubs(Map<String, dynamic> body, {int page = 1}) async {
    var endpoint = '${ApiUrl.user.searchClubs}$page';
    var apiResponse = await sl<ApiInterceptor>().postRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) return [];
    var clubsApi = ClubsApi.fromJson(apiResponse.response);
    return clubsApi.clubs.haveList ? clubsApi.clubs! : [];
  }

  Future<bool> joinClub(Map<String, dynamic> body) async {
    var endpoint = ApiUrl.user.joinClub;
    var apiResponse = await sl<ApiInterceptor>().postRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) return false;
    FlushPopup.onInfo(message: 'joined_successfully'.recast);
    return true;
  }

  Future<bool> leaveClub(Map<String, dynamic> body) async {
    var endpoint = ApiUrl.user.leaveClub;
    var apiResponse = await sl<ApiInterceptor>().postRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) return false;
    FlushPopup.onInfo(message: 'you_left_the_club'.recast);
    return true;
  }

  Future<Club?> markAsDefaultClub(Map<String, dynamic> body) async {
    var endpoint = ApiUrl.user.changeToDefault;
    var apiResponse = await sl<ApiInterceptor>().putRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) return null;
    FlushPopup.onInfo(message: 'default_club_updated_successfully'.recast);
    return Club.fromJson(apiResponse.response['data']);
  }

  Future<Map<String, dynamic>?> findNearbyCourses(Coordinates coordinates) async {
    // var endpoint = '${ApiUrl.user.findClubCourses}?latitude=91.548447"&longitude=50.969646';
    var endpoint = '${ApiUrl.user.findClubCourses}?latitude=${coordinates.lat}&longitude=${coordinates.lng}';
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status == 200) {
      var coursesApi = CoursesApi.fromJson(apiResponse.response);
      var courses = coursesApi.courses.haveList ? coursesApi.courses! : <Course>[];
      return {'is_course': true, 'is_club': false, 'data': courses};
    } else if (apiResponse.status == 300) {
      if (apiResponse.response['data'] == null) return {'is_club': true, 'is_course': false, 'data': <Club>[]};
      var clubsApi = ClubsApi.fromJson(apiResponse.response);
      var clubs = clubsApi.clubs.haveList ? clubsApi.clubs! : <Club>[];
      return {'is_club': true, 'is_course': false, 'data': clubs};
    } else {
      return null;
    }
  }

  Future<Event?> createClubEvent(Map<String, dynamic> body) async {
    var endpoint = ApiUrl.user.createClubEvent;
    var apiResponse = await sl<ApiInterceptor>().postRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) return null;
    FlushPopup.onInfo(message: 'event_created_successfully'.recast);
    return Event.fromJson(apiResponse.response['data']);
  }

  Future<List<Event>> findEvents(Coordinates coordinates) async {
    var endpoint = '${ApiUrl.user.findEvents}?latitude=${coordinates.lat}&longitude=${coordinates.lng}';
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    var eventsApi = EventsApi.fromJson(apiResponse.response);
    return eventsApi.events.haveList ? eventsApi.events! : [];
  }

  Future<Event?> fetchEventDetails(Event event) async {
    var endpoint = '${ApiUrl.user.eventDetails}/${event.id}';
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return null;
    return Event.fromJson(apiResponse.response['data']);
  }

  Future<bool> joinEvent(Map<String, dynamic> body) async {
    var endpoint = ApiUrl.user.joinEvent;
    var apiResponse = await sl<ApiInterceptor>().postRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) return false;
    FlushPopup.onInfo(message: 'joined_successfully'.recast);
    return true;
  }

  Future<ClubComment?> addEventComment(Map<String, dynamic> body, ClubComment comment) async {
    var endpoint = ApiUrl.user.addEventComment;
    var apiResponse = await sl<ApiInterceptor>().postRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) return null;
    return ClubComment.fromJson(apiResponse.response['data']);
  }

  Future<List<ClubComment>> fetchEventComments(Event event) async {
    var endpoint = '${ApiUrl.user.eventComments}${event.id}';
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    var commentsApi = ClubCommentsApi.fromJson(apiResponse.response);
    return commentsApi.comments.haveList ? commentsApi.comments! : [];
  }
}
