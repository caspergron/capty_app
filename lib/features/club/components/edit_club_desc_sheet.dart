import 'dart:async';

import 'package:flutter/material.dart';

import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/components/loaders/positioned_loader.dart';
import 'package:app/constants/app_keys.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/libraries/flush_popup.dart';
import 'package:app/models/club/club.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/core/input_field.dart';
import 'package:app/widgets/core/pop_scope_navigator.dart';
import 'package:app/widgets/ui/character_counter.dart';

Future<void> editClubDescSheet({required Club club, Function(Club)? onUpdate}) async {
  var context = navigatorKey.currentState!.context;
  var padding = MediaQuery.of(context).viewInsets;
  var child = _BottomSheetView(club, onUpdate);
  await showModalBottomSheet(
    context: context,
    isDismissible: false,
    shape: BOTTOM_SHEET_SHAPE,
    isScrollControlled: true,
    clipBehavior: Clip.antiAlias,
    builder: (context) => Padding(padding: padding, child: PopScopeNavigator(canPop: false, child: child)),
  );
}

class _BottomSheetView extends StatefulWidget {
  final Club club;
  final Function(Club)? onUpdate;
  const _BottomSheetView(this.club, this.onUpdate);

  @override
  State<_BottomSheetView> createState() => _BottomSheetViewState();
}

class _BottomSheetViewState extends State<_BottomSheetView> {
  var _loader = false;
  var _focusNode = FocusNode();
  var _description = TextEditingController();

  @override
  void initState() {
    // sl<AppAnalytics>().screenView('edit-club-description-sheet');
    _description.text = widget.club.description ?? '';
    _focusNode.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.width,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(color: primary, borderRadius: SHEET_RADIUS),
      child: Stack(children: [_screenView(context), if (_loader) const PositionedLoader()]),
    );
  }

  Widget _screenView(BuildContext context) {
    var decoration = BoxDecoration(color: mediumBlue, borderRadius: BorderRadius.circular(2));
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 08),
        Center(child: Container(height: 4, width: 28.width, decoration: decoration)),
        const SizedBox(height: 14),
        Row(
          children: [
            const SizedBox(width: 24),
            Expanded(child: Text('edit_club_description'.recast, style: TextStyles.text18_600.copyWith(color: lightBlue))),
            const SizedBox(width: 10),
            InkWell(onTap: backToPrevious, child: const Icon(Icons.close, color: lightBlue, size: 22)),
            const SizedBox(width: 24),
          ],
        ),
        const SizedBox(height: 14),
        const Divider(color: mediumBlue, height: 0.5, thickness: 0.5),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: _screenContents),
        ),
        SizedBox(height: BOTTOM_GAP),
      ],
    );
  }

  List<Widget> get _screenContents {
    return [
      Text('club_description'.recast.allFirstLetterCapital, style: TextStyles.text14_500.copyWith(color: lightBlue)),
      const SizedBox(height: 06),
      InputField(
        minLines: 6,
        maxLines: 20,
        maxLength: 200,
        counterText: '',
        controller: _description,
        hintText: 'type_here'.recast,
        focusNode: _focusNode,
        enabledBorder: skyBlue,
        focusedBorder: mediumBlue,
        onChanged: (v) => setState(() {}),
      ),
      if (_description.text.isNotEmpty) const SizedBox(height: 06),
      if (_description.text.isNotEmpty) CharacterCounter(count: _description.text.length, total: 200),
      const SizedBox(height: 32),
      ElevateButton(
        height: 40,
        radius: 06,
        onTap: _onUpdate,
        width: double.infinity,
        label: 'update_description'.recast.toUpper,
      ),
    ];
  }

  Future<void> _onUpdate() async {
    minimizeKeyboard();
    if (_description.text.isEmpty) return FlushPopup.onWarning(message: 'please_write_your_club_description'.recast);
    setState(() => _loader = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _loader = false);
    if (widget.onUpdate != null) widget.onUpdate!(widget.club);
    backToPrevious();
    await Future.delayed(const Duration(milliseconds: 300));
    FlushPopup.onInfo(message: 'updated_successfully'.recast);
  }
}
