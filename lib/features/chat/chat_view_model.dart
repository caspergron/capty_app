import 'dart:async';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:app/constants/app_keys.dart';
import 'package:app/constants/data_constants.dart';
import 'package:app/constants/date_formats.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/buddies/buddies_view_model.dart';
import 'package:app/helpers/file_helper.dart';
import 'package:app/libraries/formatters.dart';
import 'package:app/libraries/image_pickers.dart';
import 'package:app/libraries/locations.dart';
import 'package:app/models/chat/chat_buddy.dart';
import 'package:app/models/chat/chat_content.dart';
import 'package:app/models/chat/chat_message.dart';
import 'package:app/models/marketplace/sales_ad.dart';
import 'package:app/models/system/doc_file.dart';
import 'package:app/models/system/loader.dart';
import 'package:app/models/system/paginate.dart';
import 'package:app/preferences/user_preferences.dart';
import 'package:app/repository/chat_repository.dart';
import 'package:app/repository/marketplace_repo.dart';

class ChatViewModel with ChangeNotifier {
  var loader = DEFAULT_LOADER;
  var fileLoader = 0;
  var imageLoader = 0;
  var isUploadType = false;
  var paginate = Paginate();
  var discList = <SalesAd>[];
  var documents = <DocFile>[];
  var images = <DocFile>[];
  var messages = <ChatMessage>[];
  var sender = ChatBuddy();
  var receiver = ChatBuddy();
  var chatMessage = TextEditingController();
  var scrollControl = ScrollController();

  void initViewModel(ChatBuddy buddy) {
    receiver = buddy;
    var user = UserPreferences.user;
    sender = ChatBuddy(id: user.id, name: user.name);
    notifyListeners();
    _fetchOnlineStatus();
    _fetchMoreDiscsBySeller();
    _storeDiscInfoInConversation();
    // _fetchAllMessages(isLoad: true);
    scrollControl.addListener(_onCheckPagination);
  }

  void disposeViewModel() {
    paginate = Paginate();
    documents.clear();
    images.clear();
    loader = DEFAULT_LOADER;
    imageLoader = 0;
    fileLoader = 0;
    isUploadType = false;
    messages.clear();
    chatMessage.clear();
    sender = ChatBuddy();
    receiver = ChatBuddy();
  }

  Future<void> _fetchOnlineStatus() async {
    var response = await sl<ChatRepository>().checkOnlineStatus(receiver.id!);
    receiver.isOnline = response;
    notifyListeners();
  }

  Future<void> _fetchMoreDiscsBySeller() async {
    var coordinates = await sl<Locations>().fetchLocationPermission();
    var locationParams = '&latitude=${coordinates.lat}&longitude=${coordinates.lng}';
    var params = '${receiver.id!}$locationParams';
    var response = await sl<MarketplaceRepository>().fetchMoreMarketplaceByUser(params);
    if (response.isNotEmpty) discList = response;
    notifyListeners();
  }

  Future<void> _storeDiscInfoInConversation() async {
    var salesAdId = receiver.salesAd?.id;
    if (salesAdId == null) return _fetchAllMessages(isLoad: true);
    var body = {'buyer_id': sender.id, 'seller_id': receiver.id, 'sales_ad_id': salesAdId};
    var isExist = await sl<ChatRepository>().checkDiscExistInChats(body);
    if (isExist) receiver.salesAd = null;
    // await sl<ChatRepository>().storeDiscInConversation(body);
    unawaited(_fetchAllMessages(isLoad: true));
  }

  Future<void> _fetchAllMessages({bool isLoad = false, bool isPaginate = false}) async {
    if (paginate.pageLoader) return;
    paginate.pageLoader = isPaginate;
    loader.common = isLoad;
    notifyListeners();
    var context = navigatorKey.currentState!.context;
    var response = await sl<ChatRepository>().fetchConversations(buddy: receiver, page: paginate.page);
    paginate.length = response.length;
    if (paginate.page == 1) messages.clear();
    if (paginate.length >= LENGTH_20) paginate.page++;
    if (response.isNotEmpty) messages.haveList ? messages.insertAll(0, response) : messages.addAll(response);
    if (response.haveList) Provider.of<BuddiesViewModel>(context, listen: false).setLastMessage(messages.last);
    loader = Loader(initial: false, common: false);
    paginate.pageLoader = false;
    notifyListeners();
    if (!isPaginate) unawaited(scrollDown());
  }

  void _onCheckPagination() {
    // var maxPosition = scrollControl.position.pixels == scrollControl.position.minScrollExtent;
    // if (maxPosition && paginate.length >= 20) _fetchAllMessages(isPaginate: true);
  }

  Future<void> scrollDown() async {
    await Future.delayed(const Duration(milliseconds: 200));
    var duration = const Duration(milliseconds: 500);
    if (!scrollControl.hasClients) return;
    await scrollControl.animateTo(scrollControl.position.maxScrollExtent, duration: duration, curve: Curves.linear);
  }

  Future<void> imageFromCamera() async {
    var imageFile = await sl<ImagePickers>().imageFromCamera();
    if (imageFile == null) return;
    imageLoader = 1;
    notifyListeners();
    var modifiedImage = await sl<FileHelper>().renderFilesInModel([imageFile]);
    if (modifiedImage.haveList) images.insertAll(0, modifiedImage);
    isUploadType = false;
    imageLoader = 0;
    notifyListeners();
  }

  Future<void> imageFromGallery() async {
    var imageList = await sl<ImagePickers>().multiImageFromGallery(limit: 5);
    if (imageList.isEmpty) return;
    imageLoader = imageList.length;
    notifyListeners();
    var modifiedFiles = await sl<FileHelper>().renderFilesInModel(imageList);
    if (modifiedFiles.haveList) images.insertAll(0, modifiedFiles);
    isUploadType = false;
    imageLoader = 0;
    notifyListeners();
  }

  void removeFile(int index) {
    documents.removeAt(index);
    notifyListeners();
  }

  void removeImage(int index) {
    images.removeAt(index);
    notifyListeners();
  }

  Future<void> onDeleteMessages() async {
    loader.common = true;
    notifyListeners();
    var response = await sl<ChatRepository>().deleteAllConversations(receiver);
    if (!response) loader.common = false;
    if (!response) return notifyListeners();
    var context = navigatorKey.currentState!.context;
    Provider.of<BuddiesViewModel>(context, listen: false).removeMessage(receiver.id!);
    messages.clear();
    backToPrevious();
    loader.common = false;
    notifyListeners();
  }

  Future<void> addMessage() async {
    var dateMillisecond = currentDate.millisecondsSinceEpoch;
    var contents = <ChatContent>[];
    if (images.haveList) images.forEach((v) => contents.add(ChatContent(doc: v, type: 'image/png', path: v.file?.path)));
    if (documents.haveList) documents.forEach((v) => contents.add(ChatContent(doc: v, type: 'application/pdf', path: v.file?.path)));
    var messageInfos = _newMessageInfo(dateMillisecond, contents);
    messages.add(messageInfos['message']);
    receiver.salesAd = null;
    notifyListeners();
    chatMessage.clear();
    images.clear();
    documents.clear();
    unawaited(scrollDown());
    var response = await sl<ChatRepository>().sendChatMessage(messageInfos['body'], contents, messageInfos['message']);
    var index = messages.indexWhere((item) => item.dateMilliSecond == dateMillisecond);
    if (index < 0) return;
    response != null ? messages[index] = response : messages[index].chatStatus = 'error';
    // var context = navigatorKey.currentState!.context;
    // if (response != null) Provider.of<NotificationsViewModel>(context, listen: false).setLastMessage(messages[index]);
    notifyListeners();
  }

  Map<String, dynamic> _newMessageInfo(int dateMS, List<ChatContent> contents) {
    // 'time_millisecond': '$dateMS'
    var salesAdId = receiver.salesAd?.id;
    var messageType = receiver.salesAd != null ? 'sales_ad' : (contents.haveList ? 'mixed' : 'text');
    Map<String, dynamic> body = {
      'receiver_id': '${receiver.id}',
      'msg': chatMessage.text,
      'type': messageType,
      if (messageType.toKey == 'sales_ad'.toKey) 'buyer_id': sender.id,
      if (messageType.toKey == 'sales_ad'.toKey) 'seller_id': receiver.id,
      if (messageType.toKey == 'sales_ad'.toKey) 'sales_ad_id': salesAdId
    };
    var message = ChatMessage(
      id: messages.length,
      senderId: sender.id,
      receiverId: receiver.id,
      message: chatMessage.text,
      dateMilliSecond: dateMS,
      type: messageType,
      createdAt: Formatters.formatDate(DATE_FORMAT_4, '$currentDate'),
      // sendTime: Formatters.formatDate(DATE_FORMAT_4, '$currentDate'),
      salesAd: messageType.toKey == 'sales_ad'.toKey ? receiver.salesAd : null,
    );
    return {'body': body, 'message': message};
  }

  /* ----- Use For Other ViewModels ----- */

  void setReceivedMessage(ChatMessage message) {
    if (sender.id == null || receiver.id == null) return;
    if ((message.senderId ?? 0) != (receiver.id ?? 0)) return;
    messages.add(message);
    notifyListeners();
    unawaited(scrollDown());
  }
}

/*Future<Uint8List?> _modifyPickedImage(XFile image) async {
    io.File pickedFile = io.File(image.path);
    var compressedImage = await sl<FileCompressor>().compressImageFile(io.File(pickedFile.path));
    if (compressedImage == null) return null;
    var croppedImage = await sl<ImageCroppers>().cropImage(image: compressedImage);
    if (croppedImage == null) return null;
    var file = io.File(croppedImage.path);
    var unit8Image = await sl<ImageService>().fileToUnit8List(file);
    return unit8Image;
  }*/

/*Future<void> uploadFile() async {
    var fileList = await sl<FilePickers>().pickMultipleFile();
    if (fileList.isEmpty) return;
    fileLoader = fileList.length;
    notifyListeners();
    var modifiedFiles = await sl<FileHelper>().renderFilesInModel(fileList);
    if (modifiedFiles.haveList) documents.insertAll(0, modifiedFiles);
    isUploadType = false;
    fileLoader = 0;
    notifyListeners();
  }*/
