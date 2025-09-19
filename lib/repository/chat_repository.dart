import 'package:provider/provider.dart';

import 'package:app/constants/app_keys.dart';
import 'package:app/di.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/buddies/buddies_view_model.dart';
import 'package:app/interfaces/api_interceptor.dart';
import 'package:app/libraries/toasts_popups.dart';
import 'package:app/models/chat/chat_buddy.dart';
import 'package:app/models/chat/chat_content.dart';
import 'package:app/models/chat/chat_message.dart';
import 'package:app/models/chat/chats_api.dart';
import 'package:app/models/chat/conversation_api.dart';
import 'package:app/utils/api_url.dart';

class ChatRepository {
  Future<bool> setOnlineStatus({required bool status}) async {
    final body = {'status': status};
    final endpoint = ApiUrl.user.setOnlineStatus;
    final apiResponse = await sl<ApiInterceptor>().putRequest(endpoint: endpoint, body: body);
    return apiResponse.status == 200;
  }

  Future<bool> checkOnlineStatus(int receiverId) async {
    final endpoint = '${ApiUrl.user.checkOnlineStatus}$receiverId';
    final apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return false;
    if (apiResponse.response['data'] == null) return false;
    if (apiResponse.response['data']['is_online'] == null) return false;
    return apiResponse.response['data']['is_online'] as bool;
  }

  Future<bool> checkDiscExistInChats(Map<String, dynamic> body) async {
    final endpoint = ApiUrl.user.isExistDiscInChat;
    final apiResponse = await sl<ApiInterceptor>().postRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) return false;
    if (apiResponse.response['data'] == null) return false;
    if (apiResponse.response['data']['is_exist'] == null) return false;
    return apiResponse.response['data']['is_exist'] as bool;
  }

  Future<bool> storeDiscInConversation(Map<String, dynamic> body) async {
    final endpoint = ApiUrl.user.storeDiscInConversation;
    final apiResponse = await sl<ApiInterceptor>().postRequest(endpoint: endpoint, body: body);
    return apiResponse.status == 200;
  }

  Future<List<ChatMessage>> fetchChats({int page = 1}) async {
    final endpoint = ApiUrl.user.chats;
    final apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    final chatsApi = ChatsApi.fromJson(apiResponse.response);
    final chats = chatsApi.chats ?? [];
    return chats;
  }

  Future<List<ChatMessage>> fetchConversations({required ChatBuddy buddy, int page = 1}) async {
    final endpoint = '${ApiUrl.user.conversations}?user_id=${buddy.id}';
    final apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    final messagesApi = ConversationApi.fromJson(apiResponse.response['data']);
    final messages = messagesApi.messages ?? [];
    if (messages.isEmpty) return [];
    messages.sort((item1, item2) => (item1.id ?? 0).compareTo(item2.id ?? 0));
    return messages;
  }

  Future<ChatMessage?> sendChatMessage(Map<String, dynamic> body, List<ChatContent> contents, ChatMessage chat) async {
    final endpoint = ApiUrl.user.sendMessage;
    final apiResponse = await sl<ApiInterceptor>().postRequest(endpoint: endpoint, body: body);
    if (apiResponse.status != 200) return null;
    final chatMessage = ChatMessage.fromJson(apiResponse.response['data']);
    chatMessage.chatStatus = 'sent';
    chatMessage.dateMilliSecond = chat.dateMilliSecond;
    final context = navigatorKey.currentState!.context;
    Provider.of<BuddiesViewModel>(context, listen: false).setLastMessage(chatMessage);
    return chatMessage;
  }

  Future<bool> deleteAllConversations(ChatBuddy buddy) async {
    final endpoint = '${ApiUrl.user.deleteConversation}?user_id=${buddy.id}';
    final apiResponse = await sl<ApiInterceptor>().deleteRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return false;
    ToastPopup.onToast(message: 'conversations_deleted_successfully'.recast);
    return true;
  }

/*Future<List<ChatMessage>> fetchMessages({int page = 1}) async {
    final endpoint = ApiUrl.user.messages;
    final apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    final messagesApi = ConversationApi.fromJson(apiResponse.response['data']);
    // if (messagesApi.messages.haveList) return [];
    return messagesApi.messages.haveList ? messagesApi.messages! : [];
}*/

/*Future<List<ChatMessage>> searchInConversations({required String searchKey}) async {
    final endpoint = '${ApiUrl.user.searchInChat}?keyword=$searchKey';
    final apiResponse = await sl<ApiInterceptor>().getRequest(endpoint: endpoint);
    if (apiResponse.status != 200) return [];
    final messagesApi = ConversationApi.fromJson(apiResponse.response['data']);
    return messagesApi.messages.haveList ? messagesApi.messages! : [];
}*/

/*List<ChatMessage> _modifyMessage(List<ChatMessage> messages) {
    final userId = UserPreferences.user.id;
    messages.forEach((item) {});
    return messages;
}*/
}
