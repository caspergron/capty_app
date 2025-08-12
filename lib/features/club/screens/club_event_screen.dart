import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/components/loaders/fading_circle.dart';
import 'package:app/components/loaders/screen_loader.dart';
import 'package:app/components/menus/back_menu.dart';
import 'package:app/constants/date_formats.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/club/components/post_comment_sheet.dart';
import 'package:app/features/club/units/comments_list.dart';
import 'package:app/features/club/view_models/club_event_view_model.dart';
import 'package:app/libraries/formatters.dart';
import 'package:app/models/club/event.dart';
import 'package:app/preferences/user_preferences.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/gradients.dart';
import 'package:app/themes/shadows.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/library/circle_image.dart';
import 'package:app/widgets/library/svg_image.dart';
import 'package:app/widgets/ui/nav_button_box.dart';
import 'package:app/widgets/ui/row_label_placeholder.dart';

class ClubEventScreen extends StatefulWidget {
  final Event event;
  const ClubEventScreen({required this.event});

  @override
  State<ClubEventScreen> createState() => _ClubEventScreenState();
}

class _ClubEventScreenState extends State<ClubEventScreen> {
  var _viewModel = ClubEventViewModel();
  var _modelData = ClubEventViewModel();
  var _scrollControl = ScrollController();

  @override
  void initState() {
    // sl<AppAnalytics>().screenView('club-event-screen');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _viewModel.initViewModel(widget.event));
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _viewModel = Provider.of<ClubEventViewModel>(context, listen: false);
    _modelData = Provider.of<ClubEventViewModel>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _viewModel.disposeViewModel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const BackMenu(),
        title: Text(widget.event.name ?? 'club_event'.recast),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        width: SizeConfig.width,
        height: SizeConfig.height,
        decoration: BoxDecoration(gradient: BACKGROUND_GRADIENT),
        child: Stack(children: [_screenView(context), if (_modelData.loader.loader) const ScreenLoader()]),
      ),
      bottomNavigationBar: NavButtonBox(
        childHeight: 42,
        loader: _modelData.loader.loader,
        child: ElevateButton(radius: 04, height: 42, label: 'post_your_comment'.recast.toUpper, onTap: _onPostComment),
      ),
    );
  }

  void _onPostComment() => postCommentSheet(onPost: (v) => _viewModel.onPostComment(v, _scrollControl));

  Widget _screenView(BuildContext context) {
    var event = _modelData.event;
    var initLoad = _modelData.loader.initial;
    var date = Formatters.formatDate(DATE_FORMAT_19, event.eventDate);
    var time = Formatters.formatDate(TIME_FORMAT_1, event.event_datetime);
    return ListView(
      shrinkWrap: true,
      controller: _scrollControl,
      clipBehavior: Clip.antiAlias,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: Dimensions.screen_padding),
      children: [
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(color: primary, boxShadow: const [SHADOW_1], borderRadius: BorderRadius.circular(08)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'club_event_details'.recast,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.text20_500.copyWith(color: lightBlue, fontWeight: w700),
                    ),
                  ),
                  const SizedBox(width: 08),
                  RowLabelPlaceholder(
                    height: 28,
                    label: 'share'.recast,
                    background: skyBlue,
                    icon: SvgImage(image: Assets.svg1.share, color: primary, height: 14),
                  )
                ],
              ),
              const SizedBox(height: 08),
              Row(
                children: [
                  SvgImage(image: Assets.svg1.calendar_check, height: 22, color: lightBlue),
                  const SizedBox(width: 08),
                  Expanded(child: Text(date, style: TextStyles.text14_400.copyWith(color: lightBlue))),
                ],
              ),
              const SizedBox(height: 08),
              Row(
                children: [
                  SvgImage(image: Assets.svg1.clock, height: 22, color: lightBlue),
                  const SizedBox(width: 08),
                  Expanded(child: Text(time, style: TextStyles.text14_400.copyWith(color: lightBlue))),
                ],
              ),
              const SizedBox(height: 08),
              Row(
                children: [
                  SvgImage(image: Assets.svg1.map_pin, height: 22, color: lightBlue),
                  const SizedBox(width: 08),
                  Expanded(child: Text(event.course?.name ?? '', style: TextStyles.text14_400.copyWith(color: lightBlue))),
                ],
              ),
              const SizedBox(height: 01),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(color: primary, boxShadow: const [SHADOW_1], borderRadius: BorderRadius.circular(08)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('about_this_game'.recast, style: TextStyles.text20_500.copyWith(color: lightBlue, fontWeight: w700)),
              const SizedBox(height: 08),
              Text(event.description ?? '', style: TextStyles.text14_400.copyWith(color: lightBlue)),
              const SizedBox(height: 01),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(color: primary, boxShadow: const [SHADOW_1], borderRadius: BorderRadius.circular(08)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'participants'.recast,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.text20_500.copyWith(color: lightBlue, fontWeight: w700),
                    ),
                  ),
                  if (!event.is_joined) const SizedBox(width: 08),
                  if (!event.is_joined)
                    RowLabelPlaceholder(
                      height: 24,
                      background: orange,
                      label: 'join_event'.recast,
                      onTap: _viewModel.onJoinEvent,
                      style: TextStyles.text12_600.copyWith(color: lightBlue, height: 1),
                    )
                ],
              ),
              const SizedBox(height: 14),
              Wrap(spacing: 08, runSpacing: 08, children: ['', '', ''].asMap().entries.map(_playerItemCard).toList()),
              const SizedBox(height: 01),
            ],
          ),
        ),
        if (!initLoad) const SizedBox(height: 16),
        if (!initLoad) Text('comments'.recast, style: TextStyles.text20_500.copyWith(color: primary, fontWeight: w700)),
        if (!initLoad) const SizedBox(height: 12),
        if (!initLoad) _commentSection,
        SizedBox(height: BOTTOM_GAP),
      ],
    );
  }

  Widget get _commentSection {
    if (_modelData.loader.initial) return const SizedBox.shrink();
    if (_modelData.comments.isEmpty) return _noComment;
    return CommentsList(sender: UserPreferences.user, messages: _modelData.comments);
  }

  Widget _playerItemCard(MapEntry<int, String> entry) {
    // var item = entry.value;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleImage(
          radius: 13,
          // image: entry.key.isEven ? DUMMY_PROFILE_IMAGE : null,
          color: popupBearer.colorOpacity(0.1),
          backgroundColor: primary,
          placeholder: const FadingCircle(size: 14, color: lightBlue),
          errorWidget: SvgImage(image: Assets.svg1.coach, height: 14, color: lightBlue),
        ),
        const SizedBox(width: 04),
        Text(
          entry.key.isEven ? 'Wesley' : 'Casper',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyles.text12_700.copyWith(color: lightBlue, height: 1),
        ),
      ],
    );
  }

  Widget get _noComment {
    return Column(
      children: [
        SizedBox(height: 4.height),
        SvgImage(image: Assets.svg3.no_message, height: 12.height, color: lightBlue),
        const SizedBox(height: 16),
        Text('no_comments_available_now'.recast, style: TextStyles.text14_600.copyWith(color: lightBlue, fontWeight: w500)),
      ],
    );
  }
}
