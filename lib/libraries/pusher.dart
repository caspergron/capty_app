import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:provider/provider.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import 'package:app/constants/app_keys.dart';
import 'package:app/di.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/buddies/buddies_view_model.dart';
import 'package:app/features/chat/chat_view_model.dart';
import 'package:app/models/chat/chat_message.dart';
import 'package:app/services/storage_service.dart';
import '../constants/app_constants.dart';

class Pusher {
  final _pusher = PusherChannelsFlutter.getInstance();

  Future<void> onDisposePusher() async {
    final user = sl<StorageService>().user;
    final channel = 'message.${user.id}';
    try {
      final state = _pusher.connectionState;
      final isConnected = state.toUpper == 'CONNECTED';
      if (user.id != null && isConnected) await _pusher.unsubscribe(channelName: channel);
      if (isConnected) await _pusher.disconnect();
    } catch (e) {
      if (kDebugMode) print('ERROR: $e');
    }
  }

  Future<void> onInitPusher() async {
    final channel = '$PUSHER_CHANNEL${sl<StorageService>().user.id}';
    try {
      await _pusher.init(
        apiKey: PUSHER_APP_KEY,
        cluster: PUSHER_APP_CLUSTER,
        onError: _onError,
        onEvent: _onEvent,
        onMemberAdded: _onMemberAdded,
        onMemberRemoved: _onMemberRemoved,
        onSubscriptionCount: _onSubscriptionCount,
        onSubscriptionError: _onSubscriptionError,
        onDecryptionFailure: _onDecryptionFailure,
        onConnectionStateChange: _onConnectionStateChange,
        onSubscriptionSucceeded: _onSubscriptionSucceeded,
      );
      await _pusher.subscribe(channelName: channel);
      // await _pusher.subscribe(channelName: channel, onEvent: _onEvent);
      await _pusher.connect();
      if (kDebugMode) print('socket id: ${await _pusher.getSocketId()}');
    } catch (e) {
      if (kDebugMode) print('ERROR: $e');
    }
  }

  void _onConnectionStateChange(currentState, previousState) {
    if (kDebugMode) print('Connection: $currentState');
  }

  void _onError(String message, int? code, e) {
    if (kDebugMode) print('onError: $message code: $code exception: $e');
  }

  void _onEvent(PusherEvent event) {
    final context = navigatorKey.currentState?.context;
    // if (kDebugMode) print('onEvent: ${event.data}');
    if (context == null || event.data == null || event.data == {}) return;
    final chatMessage = ChatMessage.fromJson(json.decode(event.data));
    if (chatMessage.message == null) return;
    chatMessage.chatStatus = 'received';
    Provider.of<ChatViewModel>(context, listen: false).setReceivedMessage(chatMessage);
    Provider.of<BuddiesViewModel>(context, listen: false).setReceivedMessage(chatMessage);
  }

  void _onSubscriptionSucceeded(String channelName, data) {
    if (kDebugMode) print('onSubscriptionSucceeded: $channelName data: ${data.toString()}');
    final me = _pusher.getChannel(channelName)?.me;
    if (kDebugMode) print('Me: $me');
  }

  void _onSubscriptionError(String message, e) {
    if (kDebugMode) print('onSubscriptionError: $message Exception: $e');
  }

  void _onDecryptionFailure(String event, String reason) {
    if (kDebugMode) print('onDecryptionFailure: $event reason: $reason');
  }

  void _onMemberAdded(String channelName, PusherMember member) {
    if (kDebugMode) print('onMemberAdded: $channelName user: $member');
  }

  void _onMemberRemoved(String channelName, PusherMember member) {
    if (kDebugMode) print('onMemberRemoved: $channelName user: $member');
  }

  void _onSubscriptionCount(String channelName, int subscriptionCount) {
    if (kDebugMode) print('onSubscriptionCount: $channelName subscriptionCount: $subscriptionCount');
  }
}
