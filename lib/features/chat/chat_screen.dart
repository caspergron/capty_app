import 'dart:async';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:app/components/loaders/circle_loader.dart';
import 'package:app/components/loaders/fading_circle.dart';
import 'package:app/components/loaders/screen_loader.dart';
import 'package:app/components/menus/back_menu.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/chat/chat_view_model.dart';
import 'package:app/features/chat/units/chat_suggestions_list.dart';
import 'package:app/features/chat/units/disc_info_chat_box.dart';
import 'package:app/features/chat/units/document_selection.dart';
import 'package:app/features/chat/units/marketplace_disk_info.dart';
import 'package:app/features/chat/units/messages_list.dart';
import 'package:app/models/chat/chat_buddy.dart';
import 'package:app/models/system/data_model.dart';
import 'package:app/services/app_analytics.dart';
import 'package:app/services/routes.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/gradients.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/core/input_field.dart';
import 'package:app/widgets/library/circle_image.dart';
import 'package:app/widgets/library/svg_image.dart';

class ChatScreen extends StatefulWidget {
  final ChatBuddy buddy;
  const ChatScreen({required this.buddy});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var _focusNode = FocusNode();
  var _viewModel = ChatViewModel();
  var _modelData = ChatViewModel();

  @override
  void initState() {
    sl<AppAnalytics>().screenView('chat-screen');
    sl<AppAnalytics>().logEvent(name: 'chat_view');
    _focusNode.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _viewModel.initViewModel(widget.buddy));
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _viewModel = Provider.of<ChatViewModel>(context, listen: false);
    _modelData = Provider.of<ChatViewModel>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _viewModel.disposeViewModel();
    super.dispose();
  }

  // void _onDelete() => deleteConversationDialog(onDelete: _viewModel.onDeleteMessages);

  @override
  Widget build(BuildContext context) {
    // var isDelete = _modelData.messages.isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: _appbarSection,
        automaticallyImplyLeading: false,
        // actions: [if (isDelete) TrashMenu(onTap: _modelData.loader ? null : _onDelete), ACTION_SIZE],
      ),
      body: Container(
        width: SizeConfig.width,
        height: SizeConfig.height,
        decoration: BoxDecoration(gradient: BACKGROUND_GRADIENT),
        alignment: _modelData.messages.isNotEmpty ? Alignment.bottomCenter : Alignment.topCenter,
        child: Stack(children: [_screenView(context), if (_modelData.loader.loader) const ScreenLoader()]),
      ),
    );
  }

  Widget get _appbarSection {
    var name = widget.buddy.name ?? '';
    var isOnline = _modelData.receiver.is_online;
    var nameStyle = TextStyles.text14_500.copyWith(color: primary, fontSize: 15, fontWeight: w600);
    return Row(
      children: [
        const BackMenu(size: 20),
        const SizedBox(width: 16),
        Stack(
          children: [
            CircleImage(
              borderWidth: 1,
              borderColor: lightBlue,
              image: widget.buddy.media?.url,
              placeholder: const FadingCircle(size: 22),
              errorWidget: SvgImage(image: Assets.svg1.coach, height: 24, color: primary),
              onTap: () => widget.buddy.id == null ? null : Routes.user.player_profile(playerId: widget.buddy.id!).push(),
            ),
            if (isOnline) const Positioned(bottom: 2, right: 0, child: CircleAvatar(radius: 5, backgroundColor: success)),
          ],
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => widget.buddy.id == null ? null : Routes.user.player_profile(playerId: widget.buddy.id!).push(),
                child: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: nameStyle),
              ),
              Text(
                isOnline ? 'online_now'.recast : 'offline_now'.recast,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.text12_400.copyWith(color: primary, fontWeight: w400),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _screenView(BuildContext context) {
    var gap = Dimensions.screen_padding;
    // var user = sl<StorageService>().user;
    return Stack(
      clipBehavior: Clip.antiAlias,
      alignment: _modelData.messages.isNotEmpty ? Alignment.bottomCenter : Alignment.topCenter,
      children: [
        if (!_modelData.loader.loader)
          ListView(
            shrinkWrap: _modelData.messages.isEmpty ? false : true,
            clipBehavior: Clip.antiAlias,
            controller: _viewModel.scrollControl,
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: gap),
            children: [
              /*if (_modelData.messages.isEmpty) */ const SizedBox(height: 40),
              /*if (_modelData.messages.isEmpty) */ MarketplaceDiskInfo(buddy: widget.buddy, discs: _modelData.discList),
              const SizedBox(height: 24),
              if (_modelData.paginate.pageLoader) const Padding(padding: EdgeInsets.only(bottom: 24), child: CircleLoader()),
              if (_modelData.messages.isNotEmpty) MessagesList(messages: _modelData.messages, sender: _modelData.sender),
              if (_modelData.images.haveList) const SizedBox(height: 76 + 20),
              if (_modelData.documents.haveList) const SizedBox(height: 52 + 20),
              SizedBox(height: (_modelData.messages.isNotEmpty ? 48 : 90) + BOTTOM_GAP),
            ],
          ),
        Positioned(left: gap, right: gap, bottom: BOTTOM_GAP, child: _chatInputArea(context)),
      ],
    );
  }

  Widget _chatInputArea(BuildContext context) {
    var radius = const Radius.circular(08);
    var salesAd = _modelData.receiver.salesAd;
    var isContent = _modelData.isUploadType || _modelData.images.isNotEmpty;
    var top = isContent ? Radius.zero : radius;
    var borderRadius = BorderRadius.only(topLeft: top, topRight: top, bottomLeft: radius, bottomRight: radius);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (_modelData.messages.isEmpty) ChatSuggestionsList(suggestions: CHAT_SUGGESTIONS, onTap: _onSuggestion),
        const SizedBox(height: 12),
        if (!_modelData.loader.initial && salesAd != null)
          DiscInfoChatBox(salesAd: salesAd, onClose: () => setState(() => _modelData.receiver.salesAd = null)),
        if (!_modelData.loader.initial && salesAd != null) const SizedBox(height: 08),
        DocumentSelection(
          images: _modelData.images,
          imageLoadCount: _modelData.imageLoader,
          onImage: _viewModel.removeImage,
          isUploadType: _modelData.isUploadType,
          onCamera: _viewModel.imageFromCamera,
          onGallery: _viewModel.imageFromGallery,
        ),
        Container(
          width: double.infinity,
          alignment: Alignment.bottomRight,
          padding: EdgeInsets.only(top: isContent ? 02 : 0),
          decoration: BoxDecoration(borderRadius: borderRadius),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: InputField(
                  maxLines: 6,
                  cursorHeight: 14,
                  focusNode: _focusNode,
                  onTap: _onTapInputField,
                  enabledBorder: lightBlue,
                  focusedBorder: lightBlue,
                  onChanged: (v) =>setState(() {}),
                  controller: _modelData.chatMessage,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  hintText: '${'type_your_message_here'.recast}..',
                  borderRadius: !isContent ? null : BorderRadius.only(bottomLeft: radius, bottomRight: radius),
                  // suffixIcon: Container(padding: const EdgeInsets.symmetric(horizontal: 08), child: _sendButton),
                  // prefixIcon: PrefixMenu(icon: Assets.svg1.paperclip, isFocus: _focusNode.hasFocus, onTap: _onPrefix),
                ),
              ),
              const SizedBox(width: 08),
              _sendButton,
            ],
          ),
        ),
      ],
    );
  }

  // void _onPrefix() => setState(() => _modelData.isUploadType = !_modelData.isUploadType);
  void _onSuggestion(DataModel item) => setState(() => _viewModel.chatMessage.text = item.label);

  Future<void> _onTapInputField() async {
    await Future.delayed(const Duration(milliseconds: 400));
    unawaited(_viewModel.scrollDown());
  }

  Widget get _sendButton {
    var isDisabled = _modelData.chatMessage.text.isEmpty /*&& _modelData.images.isEmpty && _modelData.documents.isEmpty*/;
    var icon = SvgImage(image: Assets.svg1.paper_plane, color: white, height: 18);
    var circleAvatar = CircleAvatar(radius: 18, backgroundColor: primary, child: icon);
    return InkWell(onTap: isDisabled ? null : _viewModel.addMessage, child: Opacity(opacity: isDisabled ? 0.3 : 1, child: circleAvatar));
  }
}
