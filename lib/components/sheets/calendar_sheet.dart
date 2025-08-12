import 'package:flutter/material.dart';

import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/constants/app_keys.dart';
import 'package:app/constants/date_formats.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/libraries/flush_popup.dart';
import 'package:app/libraries/formatters.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/core/pop_scope_navigator.dart';
import 'package:app/widgets/library/calendar_table.dart';

// parameters: first_date, last_date, selected_date?, start_date?, disabled_dates
Future<void> calendarSheet({
  required DateTime firstDate,
  required DateTime lastDate,
  required Function(DateTime) onConfirm,
  DateTime? startDate,
  DateTime? selectedDate,
}) async {
  var context = navigatorKey.currentState!.context;
  await showModalBottomSheet(
    context: context,
    isDismissible: false,
    enableDrag: false,
    isScrollControlled: true,
    shape: BOTTOM_SHEET_SHAPE,
    clipBehavior: Clip.antiAlias,
    builder: (builder) {
      var sheetView = _BottomSheetView(firstDate, lastDate, selectedDate, startDate, onConfirm);
      return PopScopeNavigator(canPop: false, child: sheetView);
    },
  );
}

class _BottomSheetView extends StatefulWidget {
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime? selectedDate;
  final DateTime? startDate;
  final Function(DateTime) onConfirm;
  const _BottomSheetView(this.firstDate, this.lastDate, this.selectedDate, this.startDate, this.onConfirm);

  @override
  State<_BottomSheetView> createState() => _BottomSheetViewState();
}

class _BottomSheetViewState extends State<_BottomSheetView> {
  var _selectedDate = null as DateTime?;

  @override
  void initState() {
    // sl<AppAnalytics>().screenView('calender-sheet');
    if (widget.selectedDate != null) _selectedDate = widget.selectedDate;
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var decoration = BoxDecoration(color: primary, borderRadius: SHEET_RADIUS);
    return Container(width: SizeConfig.width, child: _screenView(context), decoration: decoration);
  }

  Widget _screenView(BuildContext context) {
    var decoration = BoxDecoration(color: mediumBlue, borderRadius: BorderRadius.circular(2));
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 06),
        Center(child: Container(height: 4, width: 28.width, decoration: decoration)),
        const SizedBox(height: 14),
        Row(
          children: [
            SizedBox(width: Dimensions.dialog_padding),
            Expanded(child: Text('select_a_date'.recast, style: TextStyles.text18_600.copyWith(color: lightBlue))),
            const SizedBox(width: 10),
            InkWell(onTap: backToPrevious, child: const Icon(Icons.close, color: lightBlue, size: 22)),
            SizedBox(width: Dimensions.dialog_padding),
          ],
        ),
        const SizedBox(height: 14),
        const Divider(color: mediumBlue, height: 0.5, thickness: 0.5),
        const SizedBox(height: 12),
        CalendarTable(
          padding: 10,
          firstDay: widget.firstDate,
          lastDay: widget.lastDate,
          selectedDay: _selectedDate,
          onDaySelected: _onSelect,
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ElevateButton(height: 44, width: double.infinity, label: 'confirm'.recast.toUpper, onTap: _onConfirm),
        ),
        SizedBox(height: BOTTOM_GAP),
      ],
    );
  }

  void _onSelect(DateTime day) {
    var isInvalid = widget.startDate != null && (day.isBefore(widget.startDate!) || day.isAtSameMomentAs(widget.startDate!));
    if (!isInvalid) return setState(() => _selectedDate = day);
    var datetime = Formatters.formatDate(DATE_FORMAT_2, '${widget.startDate}');
    var message = '${'Please_select_the_day_after'.recast} $datetime';
    return FlushPopup.onWarning(message: message);
  }

  void _onConfirm() {
    if (_selectedDate == null) return;
    widget.onConfirm(_selectedDate!);
    backToPrevious();
  }
}
