import 'dart:async';

import 'package:flutter/material.dart';

import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/constants/app_keys.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/libraries/flush_popup.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/core/pop_scope_navigator.dart';
import 'package:app/widgets/ui/character_counter.dart';

Future<void> postCommentSheet({required Function(String) onPost}) async {
  final context = navigatorKey.currentState!.context;
  await showModalBottomSheet(
    context: context,
    isDismissible: false,
    shape: BOTTOM_SHEET_SHAPE,
    isScrollControlled: true,
    clipBehavior: Clip.antiAlias,
    builder: (context) => Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: PopScopeNavigator(canPop: false, child: _BottomSheetView(onPost)),
    ),
  );
}

class _BottomSheetView extends StatefulWidget {
  final Function(String) onPost;
  const _BottomSheetView(this.onPost);

  @override
  State<_BottomSheetView> createState() => _BottomSheetViewState();
}

class _BottomSheetViewState extends State<_BottomSheetView> {
  var _focusNode = FocusNode();
  var _feedback = TextEditingController();

  @override
  void initState() {
    // sl<AppAnalytics>().screenView('post-comment-sheet');
    _focusNode.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    _feedback.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.width,
      padding: EdgeInsets.zero,
      child: _screenView(context),
      decoration: const BoxDecoration(color: primary, borderRadius: SHEET_RADIUS),
    );
  }

  Widget _screenView(BuildContext context) {
    final decoration = BoxDecoration(color: mediumBlue, borderRadius: BorderRadius.circular(2));
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
            Expanded(child: Text('post_your_comment'.recast, style: TextStyles.text18_600.copyWith(color: lightBlue))),
            const SizedBox(width: 10),
            InkWell(onTap: backToPrevious, child: const Icon(Icons.close, color: lightBlue, size: 22)),
            SizedBox(width: Dimensions.dialog_padding),
          ],
        ),
        const SizedBox(height: 14),
        const Divider(color: mediumBlue, height: 0.5, thickness: 0.5),
        const SizedBox(height: 24),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
          decoration: BoxDecoration(border: Border.all(color: mediumBlue, width: 0.5), borderRadius: BorderRadius.circular(06)),
          child: Column(
            children: [
              TextFormField(
                minLines: 4,
                maxLines: 15,
                maxLength: 150,
                cursorHeight: 14,
                cursorColor: lightBlue,
                controller: _feedback,
                focusNode: _focusNode,
                onChanged: (v) => setState(() {}),
                onSaved: (val) => _feedback.text = val!,
                textCapitalization: TextCapitalization.sentences,
                style: TextStyles.text14_400.copyWith(color: lightBlue),
                onEditingComplete: () => FocusScope.of(context).unfocus(),
                onTapOutside: (event) => FocusScope.of(context).unfocus(),
                decoration: _decoration,
              ),
              const SizedBox(height: 04),
              Align(
                alignment: Alignment.centerRight,
                child: ElevateButton(height: 40, radius: 06, padding: 20, label: 'post_comment'.recast.toUpper, onTap: _onPost),
              ),
            ],
          ),
        ),
        if (_feedback.text.length > 0)
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 06),
            child: CharacterCounter(count: _feedback.text.length, total: 150),
          ),
        SizedBox(height: BOTTOM_GAP + 10),
      ],
    );
  }

  InputDecoration get _decoration {
    return InputDecoration(
      counterText: '',
      filled: true,
      fillColor: primary,
      border: InputBorder.none,
      errorBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      focusedErrorBorder: InputBorder.none,
      labelStyle: TextStyles.text14_400.copyWith(color: lightBlue),
      hintStyle: TextStyles.text14_400.copyWith(color: skyBlue),
      hintText: 'write_your_comment_here'.recast,
    );
  }

  void _onPost() {
    minimizeKeyboard();
    if (_feedback.text.isEmpty) return FlushPopup.onWarning(message: 'please_write_your_comment'.recast);
    widget.onPost(_feedback.text);
    backToPrevious();
  }
}
