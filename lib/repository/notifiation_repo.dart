import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/interfaces/api_interceptor.dart';
import 'package:app/models/user/notification.dart';
import 'package:app/models/user/notification_api.dart';
import 'package:app/utils/api_url.dart';

class NotificationRepository {
  Future<List<Notification>> fetchNotifications({int page = 1}) async {
    final endpoint = '${ApiUrl.user.notifications}&page=$page';
    final apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    final notificationApi = NotificationApi.fromJson(apiResponse.response);
    return notificationApi.notifications.haveList ? notificationApi.notifications! : [];
  }

  Future<Notification?> readNotification(int notificationId) async {
    final body = {'is_read': 1};
    final endpoint = '${ApiUrl.user.readNotification}$notificationId';
    final apiResponse = await sl<ApiInterceptor>().putRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) return null;
    return Notification.fromJson(apiResponse.response['data']);
  }
}
