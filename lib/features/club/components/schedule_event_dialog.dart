import 'package:flutter/material.dart';

import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/components/sheets/calendar_sheet.dart';
import 'package:app/constants/app_keys.dart';
import 'package:app/constants/date_formats.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/libraries/flush_popup.dart';
import 'package:app/libraries/formatters.dart';
import 'package:app/models/club/club.dart';
import 'package:app/services/default_pickers.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/shadows.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/transitions.dart';
import 'package:app/widgets/core/flutter_switch.dart';
import 'package:app/widgets/core/input_field.dart';
import 'package:app/widgets/core/pop_scope_navigator.dart';
import 'package:app/widgets/library/svg_image.dart';
import 'package:app/widgets/ui/character_counter.dart';
import 'package:app/widgets/ui/label_placeholder.dart';

const _SPACE20 = '       ';

Future<void> scheduleEventDialog({required Club club, Function(Map<String, dynamic>)? onSchedule}) async {
  final context = navigatorKey.currentState!.context;
  await showGeneralDialog(
    context: context,
    barrierLabel: 'Schedule Event Dialog',
    transitionDuration: DIALOG_DURATION,
    transitionBuilder: sl<Transitions>().bottomToTop,
    pageBuilder: (buildContext, anim1, anim2) => Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: PopScopeNavigator(canPop: false, child: Align(child: _DialogView(club, onSchedule))),
    ),
  );
}

class _DialogView extends StatefulWidget {
  final Club club;
  final Function(Map<String, dynamic>)? onSchedule;
  const _DialogView(this.club, this.onSchedule);

  @override
  State<_DialogView> createState() => _DialogViewState();
}

class _DialogViewState extends State<_DialogView> {
  var _date = null as DateTime?;
  var _time = null as DateTime?;
  var _title = TextEditingController();
  var _course = TextEditingController();
  var _note = TextEditingController();
  var _isClubMember = false;
  var _focusNodes = [FocusNode(), FocusNode(), FocusNode()];

  @override
  void initState() {
    // sl<AppAnalytics>().screenView('schedule-event-popup');
    final homeCourse = widget.club.homeCourse;
    _course.text = homeCourse?.id == null ? 'no_course_available_in_this_club'.recast : homeCourse!.name!;
    _focusNodes.forEach((item) => item.addListener(() => setState(() {})));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimensions.dialog_width,
      padding: EdgeInsets.only(top: 14, bottom: Dimensions.dialog_padding),
      decoration: BoxDecoration(color: primary, borderRadius: DIALOG_RADIUS, boxShadow: const [SHADOW_2]),
      child: Material(color: transparent, child: _screenView(context), shape: DIALOG_SHAPE),
    );
  }

  Widget _screenView(BuildContext context) {
    final padGap = EdgeInsets.symmetric(horizontal: Dimensions.dialog_padding);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(width: Dimensions.dialog_padding),
            Expanded(child: Text('schedule_an_event'.recast, style: TextStyles.text16_700.copyWith(color: lightBlue))),
            InkWell(onTap: backToPrevious, child: SvgImage(image: Assets.svg1.close_1, height: 18, color: lightBlue)),
            SizedBox(width: Dimensions.dialog_padding),
          ],
        ),
        const SizedBox(height: 16),
        Divider(color: lightBlue.colorOpacity(0.5)),
        const SizedBox(height: 24),
        Text('$_SPACE20${'event_title'.recast}', style: TextStyles.text12_600.copyWith(color: lightBlue, fontWeight: w500)),
        const SizedBox(height: 06),
        InputField(
          fontSize: 13,
          controller: _title,
          enabledBorder: lightBlue,
          focusedBorder: lightBlue,
          padding: Dimensions.dialog_padding,
          hintText: '${'ex'.recast}: ${'disc_golf_championship'.recast}',
          focusNode: _focusNodes[0],
          borderRadius: BorderRadius.circular(04),
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 12),
        Text('$_SPACE20${'date'.recast}', style: TextStyles.text12_600.copyWith(color: lightBlue, fontWeight: w500)),
        const SizedBox(height: 06),
        LabelPlaceholder(
          height: 40,
          fontSize: 13,
          hint: 'dd-mm-yyyy',
          label: _date == null ? '' : Formatters.formatDate(DATE_FORMAT_14, '$_date'),
          margin: Dimensions.dialog_padding,
          endIcon: SvgImage(image: Assets.svg1.calendar, height: 20, color: primary),
          onTap: () => calendarSheet(
            selectedDate: _date,
            firstDate: currentDate,
            onConfirm: (v) => setState(() => _date = v),
            lastDate: currentDate.add(const Duration(days: 365)),
          ),
        ),
        const SizedBox(height: 12),
        Text('$_SPACE20${'time'.recast}', style: TextStyles.text12_600.copyWith(color: lightBlue, fontWeight: w500)),
        const SizedBox(height: 06),
        LabelPlaceholder(
          height: 40,
          fontSize: 13,
          hint: 'hh:mm',
          margin: Dimensions.dialog_padding,
          label: _time == null ? '' : Formatters.formatDate(TIME_FORMAT_1, '$_time'),
          endIcon: SvgImage(image: Assets.svg1.clock, height: 20, color: primary),
          onTap: () => defaultTimePicker(context: context, onChanged: (v) => setState(() => _time = v)),
        ),
        const SizedBox(height: 12),
        Text('$_SPACE20${'course'.recast}', style: TextStyles.text12_600.copyWith(color: lightBlue, fontWeight: w500)),
        const SizedBox(height: 06),
        InputField(
          fontSize: 13,
          readOnly: true,
          showCursor: false,
          controller: _course,
          enabledBorder: lightBlue,
          focusedBorder: lightBlue,
          padding: Dimensions.dialog_padding,
          hintText: '${'ex'.recast}: ${'mastering_disc_golf'.recast}',
          focusNode: _focusNodes[1],
          borderRadius: BorderRadius.circular(04),
          textCapitalization: TextCapitalization.words,
          onFieldSubmitted: (value) => FocusScope.of(context).requestFocus(_focusNodes[2]),
        ),
        const SizedBox(height: 12),
        Text('$_SPACE20${'note'.recast}', style: TextStyles.text12_600.copyWith(color: lightBlue, fontWeight: w500)),
        const SizedBox(height: 06),
        InputField(
          minLines: 4,
          maxLines: 12,
          fontSize: 13,
          maxLength: 150,
          counterText: '',
          controller: _note,
          padding: Dimensions.dialog_padding,
          hintText: 'type_here'.recast,
          focusNode: _focusNodes[2],
          enabledBorder: lightBlue,
          focusedBorder: lightBlue,
          onChanged: (v) => setState(() {}),
          borderRadius: BorderRadius.circular(04),
        ),
        if (_note.text.isNotEmpty) const SizedBox(height: 06),
        if (_note.text.isNotEmpty) Padding(padding: padGap, child: CharacterCounter(count: _note.text.length, total: 150)),
        const SizedBox(height: 12),
        Row(
          children: [
            SizedBox(width: Dimensions.dialog_padding),
            FlutterSwitch(
              width: 40,
              height: 20,
              inactiveColor: mediumBlue.colorOpacity(0.5),
              activeColor: mediumBlue,
              activeToggleColor: lightBlue,
              inactiveToggleColor: skyBlue,
              value: _isClubMember,
              onToggle: (v) => setState(() => _isClubMember = v),
            ),
            const SizedBox(width: 06),
            Expanded(child: Text('this_event_is_only_for_club_members'.recast, style: TextStyles.text14_500.copyWith(color: lightBlue))),
          ],
        ),
        const SizedBox(height: 28),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.dialog_padding),
          child: ElevateButton(
            radius: 04,
            height: 36,
            onTap: _onSave,
            width: double.infinity,
            label: 'schedule_event'.recast.toUpper,
            textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
          ),
        ),
        SizedBox(height: Dimensions.dialog_padding),
      ],
    );
  }

  void _onSave() {
    if (_title.text.isEmpty) return FlushPopup.onWarning(message: 'please_write_the_title_of_the_event'.recast);
    if (_date == null) return FlushPopup.onWarning(message: 'please_write_the_date_of_the_event'.recast);
    if (_time == null) return FlushPopup.onWarning(message: 'please_write_the_time_of_the_event'.recast);
    if (widget.club.homeCourse?.id == null) return FlushPopup.onWarning(message: 'no_course_available_in_this_club'.recast);
    if (_note.text.isEmpty) return FlushPopup.onWarning(message: 'please_write_a_note_for_this_event'.recast);
    final data = {
      'name': _title.text,
      'description': _note.text,
      'club_id': widget.club.id,
      'course_id': widget.club.homeCourse?.id,
      'event_time': Formatters.formatDate(TIME_FORMAT_2, '$_time'),
      'event_date': Formatters.formatDate(DATE_FORMAT_4, '$_date'),
      'is_open_for_all': !_isClubMember,
      'is_active': true
    };
    if (widget.onSchedule != null) widget.onSchedule!(data);
    backToPrevious();
  }
}
