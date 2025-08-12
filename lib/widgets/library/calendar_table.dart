import 'package:flutter/material.dart';

import 'package:table_calendar/table_calendar.dart';

import 'package:app/constants/date_formats.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/libraries/formatters.dart';
import 'package:app/preferences/app_preferences.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/widgets/library/svg_image.dart';

class CalendarTable extends StatefulWidget {
  final double padding;
  final DateTime firstDay;
  final DateTime lastDay;
  final DateTime? selectedDay;
  final DateTimeRange? dateRange;
  final CalendarFormat calendarFormat;
  final RangeSelectionMode rangeSelectionMode;
  final List<dynamic> Function(DateTime day)? eventLoader;
  final Function(DateTime)? onPageChanged;
  final Function(DateTime)? onDaySelected;
  final Function(DateTimeRange)? onRangeSelected;

  const CalendarTable({
    required this.firstDay,
    required this.lastDay,
    this.padding = 0,
    this.selectedDay,
    this.onDaySelected,
    this.dateRange,
    this.onRangeSelected,
    this.onPageChanged,
    this.eventLoader,
    this.calendarFormat = CalendarFormat.month,
    this.rangeSelectionMode = RangeSelectionMode.toggledOff,
  });

  @override
  State<CalendarTable> createState() => _CalendarTableState();
}

class _CalendarTableState extends State<CalendarTable> {
  DateTime? _selectedDay;
  DateTimeRange? _selectedRange;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    if (widget.dateRange != null) _rangeStart = widget.dateRange!.start;
    if (widget.dateRange != null) _rangeEnd = widget.dateRange!.end;
    _selectedDay = widget.selectedDay;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.padding),
      child: TableCalendar(
        rowHeight: 40,
        locale: AppPreferences.language.code ?? 'en',
        daysOfWeekHeight: 30,
        firstDay: widget.firstDay,
        lastDay: widget.lastDay,
        currentDay: widget.selectedDay,
        focusedDay: _rangeStart ?? _focusedDay,
        calendarFormat: widget.calendarFormat,
        rangeSelectionMode: widget.rangeSelectionMode,
        rangeStartDay: _rangeStart,
        rangeEndDay: _rangeEnd,
        selectedDayPredicate: (day) => isSameDay(widget.selectedDay, day),
        onDaySelected: _onDaySelected,
        onRangeSelected: _onRangeSelected,
        onPageChanged: (focusedDay) => _focusedDay = focusedDay,
        // onPageChanged: (focusedDay) => _focusedDay = _rangeStart ?? focusedDay,
        headerStyle: _headerStyle,
        availableGestures: AvailableGestures.horizontalSwipe,
        calendarStyle: _calendarStyle,
        eventLoader: widget.eventLoader,
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyles.text14_700.copyWith(color: lightBlue),
          weekendStyle: TextStyles.text14_700.copyWith(color: lightBlue.colorOpacity(0.4)),
        ),
      ),
    );
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    var isRangeMode = widget.rangeSelectionMode == RangeSelectionMode.toggledOn;
    if (isRangeMode) return;
    _selectedDay = selectedDay;
    _focusedDay = focusedDay;
    setState(() {});
    if (_selectedDay != null && widget.onDaySelected != null) widget.onDaySelected!(_selectedDay!);
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    _rangeStart = start;
    _rangeEnd = end;
    _focusedDay = focusedDay;
    _selectedRange = start != null && end != null ? DateTimeRange(start: start, end: end) : null;
    setState(() {});
    if (_selectedRange != null && widget.onRangeSelected != null) widget.onRangeSelected!(_selectedRange!);
  }

  HeaderStyle get _headerStyle {
    return HeaderStyle(
      titleCentered: true,
      formatButtonVisible: false,
      formatButtonShowsNext: false,
      headerPadding: EdgeInsets.zero,
      leftChevronMargin: EdgeInsets.zero,
      rightChevronMargin: EdgeInsets.zero,
      leftChevronPadding: EdgeInsets.zero,
      rightChevronPadding: EdgeInsets.zero,
      formatButtonPadding: EdgeInsets.zero,
      titleTextStyle: TextStyles.text16_700.copyWith(color: lightBlue),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(06)),
      headerMargin: const EdgeInsets.only(top: 12, bottom: 08),
      formatButtonDecoration: BoxDecoration(borderRadius: BorderRadius.circular(04), color: white),
      leftChevronIcon: _leftChevron,
      rightChevronIcon: _rightChevron,
      titleTextFormatter: (date, locale) => Formatters.formatDate(DATE_FORMAT_11, '$date').firstLetterCapital,
    );
  }

  Widget get _leftChevron {
    return Container(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(color: lightBlue, borderRadius: BorderRadius.circular(04)),
      child: SvgImage(image: Assets.svg1.caret_left, height: 20, color: primary),
    );
  }

  Widget get _rightChevron {
    return Container(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(color: lightBlue, borderRadius: BorderRadius.circular(04)),
      child: SvgImage(image: Assets.svg1.caret_right, height: 20, color: primary),
    );
  }

  CalendarStyle get _calendarStyle {
    return CalendarStyle(
      cellMargin: const EdgeInsets.symmetric(horizontal: 5),
      // markersAutoAligned: false,
      markerMargin: const EdgeInsets.symmetric(horizontal: 0.5),
      markerSize: 5,
      canMarkersOverflow: false,
      markersAnchor: 1.5,
      markerSizeScale: 5,
      markersMaxCount: 5,

      markerDecoration: const BoxDecoration(color: lightBlue, shape: BoxShape.circle),
      holidayTextStyle: TextStyles.text14_700.copyWith(color: lightBlue.colorOpacity(0.4)),
      defaultTextStyle: TextStyles.text14_700.copyWith(color: lightBlue),
      selectedTextStyle: TextStyles.text14_700.copyWith(color: primary),
      outsideTextStyle: TextStyles.text14_700.copyWith(color: lightBlue.colorOpacity(0.4)),
      disabledTextStyle: TextStyles.text14_700.copyWith(color: lightBlue.colorOpacity(0.4)),
      weekendTextStyle: TextStyles.text14_700.copyWith(color: lightBlue.colorOpacity(0.4)),
      weekNumberTextStyle: TextStyles.text14_700.copyWith(color: lightBlue),
      // weekNumberTextStyle: sl<TextStyles>().text14_400(error),
      isTodayHighlighted: false,
      // isTodayHighlighted: isSelectedDay == null ? true : false,
      selectedDecoration: BoxDecoration(color: lightBlue, borderRadius: BorderRadius.circular(04)),
      rangeEndDecoration: BoxDecoration(color: lightBlue, borderRadius: BorderRadius.circular(04)),
      rangeStartDecoration: BoxDecoration(color: lightBlue, borderRadius: BorderRadius.circular(04)),
      withinRangeDecoration: BoxDecoration(color: skyBlue, borderRadius: BorderRadius.circular(04)),
      defaultDecoration: BoxDecoration(borderRadius: BorderRadius.circular(04)),
      todayDecoration: BoxDecoration(borderRadius: BorderRadius.circular(04)),
      disabledDecoration: BoxDecoration(borderRadius: BorderRadius.circular(04)),
      rowDecoration: BoxDecoration(borderRadius: BorderRadius.circular(04)),
      outsideDecoration: BoxDecoration(borderRadius: BorderRadius.circular(04)),
      holidayDecoration: BoxDecoration(borderRadius: BorderRadius.circular(04)),
      weekendDecoration: BoxDecoration(borderRadius: BorderRadius.circular(04)),
    );
  }
}
