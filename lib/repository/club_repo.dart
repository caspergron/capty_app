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
import 'package:app/models/user/user.dart';
import 'package:app/models/user/users_api.dart';
import 'package:app/utils/api_url.dart';

class ClubRepository {
  Future<Club?> createClub(Map<String, dynamic> body) async {
    final endpoint = ApiUrl.user.createClub;
    final apiResponse = await sl<ApiInterceptor>().postRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) return null;
    FlushPopup.onInfo(message: 'club_created_successfully'.recast);
    return Club.fromJson(apiResponse.response['data']);
  }

  Future<bool> createClubCourse(Map<String, dynamic> body) async {
    final endpoint = ApiUrl.user.createClubCourse;
    final apiResponse = await sl<ApiInterceptor>().postRequest(endpoint: endpoint, body: body);
    return apiResponse.status == 200;
  }

  Future<List<Club>> fetchUserClubs() async {
    final endpoint = ApiUrl.user.userClubs;
    final apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    final clubsApi = ClubsApi.fromJson(apiResponse.response);
    return clubsApi.clubs.haveList ? clubsApi.clubs! : [];
  }

  Future<Club?> fetchDefaultClubInfo() async {
    final endpoint = ApiUrl.user.defaultClubInfo;
    final apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return null;
    return Club.fromJson(apiResponse.response['data']);
  }

  Future<Club?> fetchClubDetails(Club club) async {
    final endpoint = '${ApiUrl.user.clubDetails}/${club.id}';
    final apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return null;
    return Club.fromJson(apiResponse.response['data']);
  }

  Future<List<Club>> searchClubs(Map<String, dynamic> body, {int page = 1}) async {
    final endpoint = '${ApiUrl.user.searchClubs}$page';
    final apiResponse = await sl<ApiInterceptor>().postRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) return [];
    final clubsApi = ClubsApi.fromJson(apiResponse.response);
    return clubsApi.clubs.haveList ? clubsApi.clubs! : [];
  }

  Future<bool> joinClub(Map<String, dynamic> body) async {
    final endpoint = ApiUrl.user.joinClub;
    final apiResponse = await sl<ApiInterceptor>().postRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) return false;
    FlushPopup.onInfo(message: 'joined_successfully'.recast);
    return true;
  }

  Future<bool> leaveClub(Map<String, dynamic> body) async {
    final endpoint = ApiUrl.user.leaveClub;
    final apiResponse = await sl<ApiInterceptor>().postRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) return false;
    FlushPopup.onInfo(message: 'you_left_the_club'.recast);
    return true;
  }

  Future<Club?> markAsDefaultClub(Map<String, dynamic> body) async {
    final endpoint = ApiUrl.user.changeToDefault;
    final apiResponse = await sl<ApiInterceptor>().putRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) return null;
    FlushPopup.onInfo(message: 'default_club_updated_successfully'.recast);
    return Club.fromJson(apiResponse.response['data']);
  }

  Future<List<User>> fetchClubMembers(int clubId) async {
    final endpoint = '${ApiUrl.user.clubMembers}$clubId';
    final apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    final usersApi = UsersApi.fromJson(apiResponse.response);
    return usersApi.users ?? [];
  }

  Future<Map<String, dynamic>?> findNearbyCourses(Coordinates coordinates) async {
    // final endpoint = '${ApiUrl.user.findClubCourses}?latitude=91.548447"&longitude=50.969646';
    final endpoint = '${ApiUrl.user.findClubCourses}?latitude=${coordinates.lat}&longitude=${coordinates.lng}';
    final apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status == 200) {
      final coursesApi = CoursesApi.fromJson(apiResponse.response);
      final courses = coursesApi.courses.haveList ? coursesApi.courses! : <Course>[];
      return {'is_course': true, 'is_club': false, 'data': courses};
    } else if (apiResponse.status == 300) {
      if (apiResponse.response['data'] == null) return {'is_club': true, 'is_course': false, 'data': <Club>[]};
      final clubsApi = ClubsApi.fromJson(apiResponse.response);
      final clubs = clubsApi.clubs.haveList ? clubsApi.clubs! : <Club>[];
      return {'is_club': true, 'is_course': false, 'data': clubs};
    } else {
      return null;
    }
  }

  Future<Event?> createClubEvent(Map<String, dynamic> body) async {
    final endpoint = ApiUrl.user.createClubEvent;
    final apiResponse = await sl<ApiInterceptor>().postRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) return null;
    FlushPopup.onInfo(message: 'event_created_successfully'.recast);
    return Event.fromJson(apiResponse.response['data']);
  }

  Future<List<Event>> findEvents(Coordinates coordinates) async {
    final endpoint = '${ApiUrl.user.findEvents}?latitude=${coordinates.lat}&longitude=${coordinates.lng}';
    final apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    final eventsApi = EventsApi.fromJson(apiResponse.response);
    return eventsApi.events.haveList ? eventsApi.events! : [];
  }

  Future<Event?> fetchEventDetails(Event event) async {
    final endpoint = '${ApiUrl.user.eventDetails}/${event.id}';
    final apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return null;
    return Event.fromJson(apiResponse.response['data']);
  }

  Future<bool> joinEvent(Map<String, dynamic> body) async {
    final endpoint = ApiUrl.user.joinEvent;
    final apiResponse = await sl<ApiInterceptor>().postRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) return false;
    FlushPopup.onInfo(message: 'joined_successfully'.recast);
    return true;
  }

  Future<ClubComment?> addEventComment(Map<String, dynamic> body, ClubComment comment) async {
    final endpoint = ApiUrl.user.addEventComment;
    final apiResponse = await sl<ApiInterceptor>().postRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) return null;
    return ClubComment.fromJson(apiResponse.response['data']);
  }

  Future<List<ClubComment>> fetchEventComments(Event event) async {
    final endpoint = '${ApiUrl.user.eventComments}${event.id}';
    final apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    final commentsApi = ClubCommentsApi.fromJson(apiResponse.response);
    return commentsApi.comments.haveList ? commentsApi.comments! : [];
  }
}
