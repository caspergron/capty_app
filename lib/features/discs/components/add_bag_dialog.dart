import 'dart:async';

import 'package:flutter/material.dart';

import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/components/loaders/positioned_loader.dart';
import 'package:app/constants/app_keys.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/libraries/flush_popup.dart';
import 'package:app/models/disc_bag/disc_bag.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/shadows.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/transitions.dart';
import 'package:app/widgets/core/input_field.dart';
import 'package:app/widgets/library/svg_image.dart';
import 'package:app/widgets/ui/character_counter.dart';

Future<void> addDiscBagDialog({DiscBag? discBag, Function(Map<String, dynamic>)? onSave}) async {
  var context = navigatorKey.currentState!.context;
  var padding = MediaQuery.of(context).viewInsets;
  var child = Align(child: _DialogView(discBag, onSave));
  await showGeneralDialog(
    context: context,
    barrierLabel: 'Edit Disc Dialog',
    transitionDuration: DIALOG_DURATION,
    transitionBuilder: sl<Transitions>().bottomToTop,
    pageBuilder: (buildContext, anim1, anim2) => Padding(padding: padding, child: child),
  );
}

class _DialogView extends StatefulWidget {
  final DiscBag? discBag;
  final Function(Map<String, dynamic>)? onSave;

  const _DialogView(this.discBag, this.onSave);

  @override
  State<_DialogView> createState() => _DialogViewState();
}

class _DialogViewState extends State<_DialogView> {
  var _loader = false;
  var _name = TextEditingController();
  var _description = TextEditingController();
  var _focusNodes = [FocusNode(), FocusNode()];

  @override
  void initState() {
    // sl<AppAnalytics>().screenView('add-disc-bag-popup');
    _name.text = widget.discBag?.name ?? '';
    _description.text = widget.discBag?.name ?? '';
    _focusNodes.forEach((item) => item.addListener(() => setState(() {})));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var stackList = [_screenView(context), if (_loader) const PositionedLoader()];
    return Container(
      width: Dimensions.dialog_width,
      padding: EdgeInsets.symmetric(horizontal: Dimensions.dialog_padding, vertical: Dimensions.dialog_padding),
      decoration: BoxDecoration(color: primary, borderRadius: DIALOG_RADIUS, boxShadow: const [SHADOW_2]),
      child: Material(color: transparent, shape: DIALOG_SHAPE, child: Stack(children: stackList)),
    );
  }

  Widget _screenView(BuildContext context) {
    var label = widget.discBag?.id == null ? 'add_bag'.recast : 'update_bag'.recast;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyles.text16_600.copyWith(color: lightBlue)),
            InkWell(onTap: backToPrevious, child: SvgImage(image: Assets.svg1.close_1, height: 18, color: lightBlue)),
          ],
        ),
        const SizedBox(height: 24),
        Text('name'.recast, style: TextStyles.text12_600.copyWith(color: lightBlue)),
        const SizedBox(height: 06),
        InputField(
          cursorHeight: 12,
          controller: _name,
          hintText: '${'ex'.recast}: ${'tournament'.recast}',
          fillColor: skyBlue,
          enabledBorder: skyBlue,
          focusedBorder: skyBlue,
          focusNode: _focusNodes.first,
          borderRadius: BorderRadius.circular(04),
          contentPadding: const EdgeInsets.fromLTRB(08, 7.5, 04, 7.5),
        ),
        const SizedBox(height: 14),
        Text('description'.recast, style: TextStyles.text12_600.copyWith(color: lightBlue)),
        const SizedBox(height: 06),
        InputField(
          fontSize: 12,
          minLines: 06,
          maxLines: 12,
          counterText: '',
          maxLength: 150,
          controller: _description,
          hintText: 'write_description_here'.recast,
          focusNode: _focusNodes.last,
          fillColor: skyBlue,
          enabledBorder: skyBlue,
          focusedBorder: skyBlue,
          borderRadius: BorderRadius.circular(04),
        ),
        if (_description.text.isNotEmpty) const SizedBox(height: 06),
        if (_description.text.isNotEmpty) CharacterCounter(count: _description.text.length, total: 150),
        const SizedBox(height: 28),
        ElevateButton(
          radius: 04,
          height: 36,
          onTap: _onSave,
          width: double.infinity,
          label: widget.discBag?.id == null ? 'add_bag'.recast.toUpper : 'update_bag'.recast.toUpper,
          textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
        ),
        const SizedBox(height: 08),
      ],
    );
  }

  void _onSave() {
    if (_name.text.isEmpty) return FlushPopup.onWarning(message: 'please_write_your_bag_name'.recast);
    if (_description.text.isEmpty) return FlushPopup.onWarning(message: 'please_write_your_bag_description'.recast);
    var body = {'name': _name.text, 'description': _description.text};
    if (widget.onSave != null) widget.onSave!(body);
    backToPrevious();
  }
}
