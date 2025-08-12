import 'package:app/constants/app_keys.dart';
import 'package:app/di.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/notification/notifications_view_model.dart';
import 'package:app/interfaces/api_interceptor.dart';
import 'package:app/libraries/toasts_popups.dart';
import 'package:app/models/chat/chat_buddy.dart';
import 'package:app/models/chat/chat_content.dart';
import 'package:app/models/chat/chat_message.dart';
import 'package:app/models/chat/chats_api.dart';
import 'package:app/models/chat/conversation_api.dart';
import 'package:app/utils/api_url.dart';
import 'package:provider/provider.dart';

class ChatRepository {
  Future<bool> setOnlineStatus({required bool status}) async {
    var body = {'status': status};
    var endpoint = ApiUrl.user.setOnlineStatus;
    var apiResponse = await sl<ApiInterceptor>().putRequest(endpoint: endpoint, body: body);
    return apiResponse.status == 200;
  }

  Future<bool> checkOnlineStatus(int receiverId) async {
    var endpoint = '${ApiUrl.user.checkOnlineStatus}$receiverId';
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return false;
    if (apiResponse.response['data'] == null) return false;
    if (apiResponse.response['data']['is_online'] == null) return false;
    return apiResponse.response['data']['is_online'] as bool;
  }

  Future<bool> checkDiscExistInChats(Map<String, dynamic> body) async {
    var endpoint = ApiUrl.user.isExistDiscInChat;
    var apiResponse = await sl<ApiInterceptor>().postRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) return false;
    if (apiResponse.response['data'] == null) return false;
    if (apiResponse.response['data']['is_exist'] == null) return false;
    return apiResponse.response['data']['is_exist'] as bool;
  }

  Future<bool> storeDiscInConversation(Map<String, dynamic> body) async {
    var endpoint = ApiUrl.user.storeDiscInConversation;
    var apiResponse = await sl<ApiInterceptor>().postRequest(endpoint: endpoint, body: body);
    return apiResponse.status == 200;
  }

  Future<List<ChatMessage>> fetchChats({int page = 1}) async {
    var endpoint = ApiUrl.user.chats;
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    var chatsApi = ChatsApi.fromJson(apiResponse.response);
    var chats = chatsApi.chats ?? [];
    return chats;
  }

  Future<List<ChatMessage>> fetchConversations({required ChatBuddy buddy, int page = 1}) async {
    var endpoint = '${ApiUrl.user.conversations}?user_id=${buddy.id}';
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    var messagesApi = ConversationApi.fromJson(apiResponse.response['data']);
    var messages = messagesApi.messages ?? [];
    if (messages.isEmpty) return [];
    messages.sort((item1, item2) => (item1.id ?? 0).compareTo(item2.id ?? 0));
    return messages;
  }

  Future<ChatMessage?> sendChatMessage(Map<String, String> body, List<ChatContent> contents, ChatMessage chat) async {
    var endpoint = ApiUrl.user.sendMessage;
    await Future.delayed(const Duration(seconds: 2));
    var apiResponse = await sl<ApiInterceptor>().postRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) return null;
    var chatMessage = ChatMessage.fromJson(apiResponse.response['data']);
    chatMessage.chatStatus = 'sent';
    chatMessage.dateMilliSecond = chat.dateMilliSecond;
    var context = navigatorKey.currentState!.context;
    Provider.of<NotificationsViewModel>(context, listen: false).setLastMessage(chatMessage);
    return chatMessage;
  }

  Future<bool> deleteAllConversations(ChatBuddy buddy) async {
    var endpoint = '${ApiUrl.user.deleteConversation}?user_id=${buddy.id}';
    var apiResponse = await sl<ApiInterceptor>().deleteRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return false;
    ToastPopup.onToast(message: 'conversations_deleted_successfully'.recast);
    return true;
  }

/*Future<List<ChatMessage>> fetchMessages({int page = 1}) async {
    var endpoint = ApiUrl.user.messages;
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    var messagesApi = ConversationApi.fromJson(apiResponse.response['data']);
    // if (messagesApi.messages.haveList) return [];
    return messagesApi.messages.haveList ? messagesApi.messages! : [];
}*/

/*Future<List<ChatMessage>> searchInConversations({required String searchKey}) async {
    var endpoint = '${ApiUrl.user.searchInChat}?keyword=$searchKey';
    var apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    var messagesApi = ConversationApi.fromJson(apiResponse.response['data']);
    return messagesApi.messages.haveList ? messagesApi.messages! : [];
}*/

/*List<ChatMessage> _modifyMessage(List<ChatMessage> messages) {
    var userId = UserPreferences.user.id;
    messages.forEach((item) {});
    return messages;
}*/
}
