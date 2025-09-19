import 'dart:async';

import 'package:flutter/cupertino.dart';

import 'package:app/constants/data_constants.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/models/chat/chat_buddy.dart';
import 'package:app/models/club/club_comment.dart';
import 'package:app/models/club/event.dart';
import 'package:app/models/system/loader.dart';
import 'package:app/preferences/user_preferences.dart';
import 'package:app/repository/club_repo.dart';

class ClubEventViewModel with ChangeNotifier {
  var loader = DEFAULT_LOADER;
  var event = Event();
  var sender = ChatBuddy();
  var comments = <ClubComment>[];

  Future<void> initViewModel(Event item) async {
    event = item;
    notifyListeners();
    await _fetchClubComments();
    loader = Loader(initial: false, common: false);
    notifyListeners();
  }

  void disposeViewModel() {
    loader = DEFAULT_LOADER;
    comments.clear();
  }

  Future<void> _fetchClubComments() async {
    final response = await sl<ClubRepository>().fetchEventComments(event);
    if (response.isNotEmpty) comments = response;
    notifyListeners();
  }

  Future<void> onJoinEvent() async {
    loader.common = true;
    notifyListeners();
    final body = {'club_event_id': event.id, 'club_id': event.club?.id};
    await sl<ClubRepository>().joinEvent(body);
    loader.common = false;
    notifyListeners();
  }

  Future<void> onPostComment(String comment, ScrollController scrollControl) async {
    final dateMillisecond = currentDate.millisecondsSinceEpoch;
    final messageInfos = _commentInfo(dateMillisecond, comment);
    comments.add(messageInfos);
    notifyListeners();
    unawaited(scrollDown(scrollControl));
    final body = {'club_event_id': event.id, 'comment': comment};
    final response = await sl<ClubRepository>().addEventComment(body, messageInfos);
    if (response == null) return notifyListeners();
    final index = comments.indexWhere((item) => item.dateMS == dateMillisecond);
    if (index >= 0) comments[index] = response;
    notifyListeners();
  }

  ClubComment _commentInfo(int dateMS, String comment) {
    final user = UserPreferences.user;
    return ClubComment(clubEventId: event.id, userId: user.id, comment: comment, dateMS: dateMS);
  }

  Future<void> scrollDown(ScrollController scrollControl) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (!scrollControl.hasClients) return;
    const duration = Duration(milliseconds: 500);
    await scrollControl.animateTo(scrollControl.position.maxScrollExtent, duration: duration, curve: Curves.linear);
  }
}
