import 'package:flutter/material.dart';

import 'package:app/constants/date_formats.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/libraries/flush_popup.dart';
import 'package:app/libraries/formatters.dart';
import 'package:app/preferences/app_preferences.dart';

Future<void> defaultTimePicker({
  required BuildContext context,
  DateTime? startTime,
  DateTime? time,
  Function(DateTime)? onChanged,
}) async {
  final dateTime = time == null ? TimeOfDay.now() : time.dateTimeToTimeOfDay;
  final picked = await showTimePicker(context: context, initialTime: dateTime);
  if (picked == null) return;
  final pickedTime = picked.timeOfDayToDateTime;
  if (startTime == null && onChanged != null) return onChanged(pickedTime);
  final isAfter = pickedTime.isAfter(startTime!);
  final isSameMoment = pickedTime.isAtSameMomentAs(startTime);
  if (!isAfter && !isSameMoment) return FlushPopup.onWarning(message: 'end_time_should_be_after_start_time'.recast);
  final difference = pickedTime.difference(startTime);
  if (difference.inMinutes < 30) return FlushPopup.onWarning(message: 'duration_must_be_at_least_30_minutes'.recast);
  if (onChanged != null) onChanged(pickedTime);
}

Future<void> defaultDatePicker({
  required BuildContext context,
  required DateTime firstDate,
  required DateTime lastDate,
  DateTime? startDay,
  DateTime? initialDate,
  Function(DateTime)? onChanged,
}) async {
  final initDate = initialDate ?? currentDate;
  final picked = await showDatePicker(
    context: context,
    lastDate: lastDate,
    firstDate: firstDate,
    currentDate: currentDate,
    initialDate: initDate,
    confirmText: 'confirm'.recast.toUpper,
    cancelText: 'cancel'.recast.toUpper,
    // helpText: 'Select',
    locale: Locale(AppPreferences.language.code ?? 'en'),
  );

  if (picked == null) return;
  final isInvalid = startDay != null && (picked.isBefore(startDay) || picked.isAtSameMomentAs(startDay));
  if (isInvalid) {
    final date = Formatters.formatDate(DATE_FORMAT_14, '$startDay');
    final message = '${'please_select_the_day_after'.recast} $date';
    return FlushPopup.onWarning(message: message);
  }
  if (onChanged != null) onChanged(picked);
}
