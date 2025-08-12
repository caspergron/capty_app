import 'package:flutter/material.dart';

import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/constants/app_keys.dart';
import 'package:app/constants/date_formats.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/libraries/flush_popup.dart';
import 'package:app/libraries/formatters.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/shadows.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/transitions.dart';
import 'package:app/widgets/core/input_field.dart';
import 'package:app/widgets/core/pop_scope_navigator.dart';
import 'package:app/widgets/library/circle_image.dart';
import 'package:app/widgets/library/svg_image.dart';
import 'package:app/widgets/ui/character_counter.dart';

Future<void> eventDetailsDialog({
  required String event,
  Function(Map<String, dynamic>)? onComment,
  Function(Map<String, dynamic>)? onJoin,
  Function(Map<String, dynamic>)? onShare,
}) async {
  var context = navigatorKey.currentState!.context;
  await showGeneralDialog(
    context: context,
    barrierLabel: 'Event Details Dialog',
    transitionDuration: DIALOG_DURATION,
    transitionBuilder: sl<Transitions>().bottomToTop,
    pageBuilder: (buildContext, anim1, anim2) => Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: PopScopeNavigator(canPop: false, child: Align(child: _DialogView(event, onJoin, onShare, onComment))),
    ),
  );
}

class _DialogView extends StatefulWidget {
  final String event;
  final Function(Map<String, dynamic>)? onComment;
  final Function(Map<String, dynamic>)? onJoin;
  final Function(Map<String, dynamic>)? onShare;
  const _DialogView(this.event, this.onShare, this.onJoin, this.onComment);

  @override
  State<_DialogView> createState() => _DialogViewState();
}

class _DialogViewState extends State<_DialogView> {
  var _comment = TextEditingController();
  var _focusNode = FocusNode();

  @override
  void initState() {
    // sl<AppAnalytics>().screenView('event-details-popup');
    _focusNode.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimensions.dialog_width,
      padding: EdgeInsets.symmetric(horizontal: Dimensions.dialog_padding, vertical: 16),
      decoration: BoxDecoration(color: primary, borderRadius: DIALOG_RADIUS, boxShadow: const [SHADOW_2]),
      child: Material(color: transparent, child: _screenView(context), shape: DIALOG_SHAPE),
    );
  }

  Widget _screenView(BuildContext context) {
    var time = Formatters.formatDate(TIME_FORMAT_1, '$currentDate');
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgImage(image: Assets.svg1.clock, height: 18, color: lightBlue),
            const SizedBox(width: 06),
            Expanded(child: Text(time, textAlign: TextAlign.start, style: TextStyles.text12_600.copyWith(color: lightBlue))),
            const SizedBox(width: 06),
            InkWell(onTap: backToPrevious, child: SvgImage(image: Assets.svg1.close_1, height: 16, color: lightBlue)),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            SvgImage(image: Assets.svg1.map_pin, height: 18, color: lightBlue),
            const SizedBox(width: 06),
            Expanded(child: Text('Riverside Disk Golf Course', style: TextStyles.text14_700.copyWith(color: lightBlue))),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ElevateButton(
                radius: 04,
                height: 30,
                onTap: backToPrevious,
                label: 'join_event'.recast.toUpper,
                textStyle: TextStyles.text12_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
              ),
            ),
            const SizedBox(width: 08),
            ElevateButton(
              radius: 04,
              height: 30,
              padding: 24,
              background: skyBlue,
              label: 'share'.recast.toUpper,
              icon: SvgImage(image: Assets.svg1.share, color: primary, height: 14),
              textStyle: TextStyles.text12_700.copyWith(color: primary, fontWeight: w600, height: 1.15),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Divider(color: lightBlue.colorOpacity(0.5)),
        const SizedBox(height: 16),
        Text('about_this_game'.recast.toUpper, style: TextStyles.text14_700.copyWith(color: lightBlue)),
        const SizedBox(height: 06),
        Text('Evening round with glow discs. Bring LED lights!', style: TextStyles.text12_600.copyWith(color: lightBlue, fontWeight: w400)),
        const SizedBox(height: 14),
        Divider(color: lightBlue.colorOpacity(0.5)),
        const SizedBox(height: 16),
        Text('about_this_game'.recast.toUpper, style: TextStyles.text14_700.copyWith(color: lightBlue)),
        const SizedBox(height: 14),
        Wrap(
          spacing: 06,
          runSpacing: 08,
          children: List.generate(13, _playerChip).toList(),
        ),
        const SizedBox(height: 16),
        Divider(color: lightBlue.colorOpacity(0.5)),
        const SizedBox(height: 16),
        Text('comments'.recast, style: TextStyles.text12_600.copyWith(color: lightBlue)),
        const SizedBox(height: 06),
        InputField(
          minLines: 4,
          maxLines: 12,
          fontSize: 13,
          maxLength: 150,
          counterText: '',
          controller: _comment,
          hintText: '${'type_here'.recast} ...',
          focusNode: _focusNode,
          enabledBorder: lightBlue,
          focusedBorder: lightBlue,
          onChanged: (v) => setState(() {}),
          borderRadius: BorderRadius.circular(04),
        ),
        if (_comment.text.isNotEmpty) const SizedBox(height: 06),
        if (_comment.text.isNotEmpty) CharacterCounter(count: _comment.text.length, total: 150),
        const SizedBox(height: 24),
        ElevateButton(
          radius: 04,
          height: 36,
          onTap: _onComment,
          width: double.infinity,
          label: 'post_comment'.recast.toUpper,
          textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
        ),
        const SizedBox(height: 04),
      ],
    );
  }

  Widget _playerChip(int index) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleImage(
          radius: 10,
          backgroundColor: lightBlue,
          // image: index.isEven ? null : DUMMY_PROFILE_IMAGE,
          placeholder: SvgImage(image: Assets.svg1.coach, color: primary, height: 15),
          errorWidget: SvgImage(image: Assets.svg1.coach, color: primary, height: 15),
        ),
        const SizedBox(width: 04),
        Text('Casper', style: TextStyles.text12_700.copyWith(color: lightBlue, height: 1)),
      ],
    );
  }

  void _onComment() {
    if (_comment.text.isEmpty) return FlushPopup.onWarning(message: 'please_write_your_comment'.recast);
    // var data = {'price': widget.price, 'sold_info': _soldInfo, 'channel': _channel.text};
    if (widget.onComment != null) widget.onComment!({});
    backToPrevious();
  }
}
