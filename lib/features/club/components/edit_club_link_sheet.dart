import 'dart:async';

import 'package:flutter/material.dart';

import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/components/loaders/positioned_loader.dart';
import 'package:app/constants/app_keys.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/libraries/flush_popup.dart';
import 'package:app/models/club/club.dart';
import 'package:app/services/validators.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/core/input_field.dart';
import 'package:app/widgets/core/pop_scope_navigator.dart';

Future<void> editClubLinkSheet({required Club club, Function(Club)? onUpdate}) async {
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
  var _whatsappLink = TextEditingController();
  var _wechatLink = TextEditingController();
  var _facebookLink = TextEditingController();
  var _focusNodes = [FocusNode(), FocusNode(), FocusNode()];

  @override
  void initState() {
    // sl<AppAnalytics>().screenView('edit-club-link-sheet');
    _wechatLink.text = widget.club.wechat ?? '';
    _whatsappLink.text = widget.club.whatsapp ?? '';
    _facebookLink.text = widget.club.messenger ?? '';
    _focusNodes.forEach((item) => item.addListener(() => setState(() {})));
    super.initState();
  }

  @override
  void dispose() {
    _wechatLink.dispose();
    _whatsappLink.dispose();
    _facebookLink.dispose();
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
            Expanded(child: Text('edit_club_links'.recast, style: TextStyles.text18_600.copyWith(color: lightBlue))),
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
      Text('whatsapp_link'.recast.allFirstLetterCapital, style: TextStyles.text14_500.copyWith(color: lightBlue)),
      const SizedBox(height: 06),
      InputField(
        controller: _whatsappLink,
        hintText: '${'ex'.recast}: https://wa.me/1234567890',
        focusNode: _focusNodes[0],
        enabledBorder: skyBlue,
        focusedBorder: mediumBlue,
        keyboardType: TextInputType.url,
        onFieldSubmitted: (value) => FocusScope.of(context).requestFocus(_focusNodes[1]),
      ),
      const SizedBox(height: 16),
      Text('we_chat_link'.recast.allFirstLetterCapital, style: TextStyles.text14_500.copyWith(color: lightBlue)),
      const SizedBox(height: 06),
      InputField(
        controller: _wechatLink,
        hintText: '${'ex'.recast}: weixin://dl/chat?wxid=yourid',
        focusNode: _focusNodes[1],
        enabledBorder: skyBlue,
        focusedBorder: mediumBlue,
        keyboardType: TextInputType.url,
        onFieldSubmitted: (value) => FocusScope.of(context).requestFocus(_focusNodes[2]),
      ),
      const SizedBox(height: 16),
      Text('facebook_group_link'.recast.allFirstLetterCapital, style: TextStyles.text14_500.copyWith(color: lightBlue)),
      const SizedBox(height: 06),
      InputField(
        controller: _facebookLink,
        hintText: '${'ex'.recast}: https://facebook.com/groups/yourgroup',
        focusNode: _focusNodes[2],
        enabledBorder: skyBlue,
        focusedBorder: mediumBlue,
        keyboardType: TextInputType.url,
        onFieldSubmitted: (value) => FocusScope.of(context).requestFocus(_focusNodes[3]),
      ),
      const SizedBox(height: 32),
      ElevateButton(height: 40, radius: 06, onTap: _onUpdate, width: double.infinity, label: 'update_links'.recast.toUpper),
    ];
  }

  Future<void> _onUpdate() async {
    minimizeKeyboard();

    if (_whatsappLink.text.isNotEmpty) {
      var invalidWhatsApp = sl<Validators>().validateUrl(_whatsappLink.text, 'whatsapp');
      if (invalidWhatsApp != null) return FlushPopup.onWarning(message: invalidWhatsApp);
    }

    if (_wechatLink.text.isNotEmpty) {
      var invalidWechat = sl<Validators>().validateUrl(_wechatLink.text, 'wechat');
      if (invalidWechat != null) return FlushPopup.onWarning(message: invalidWechat);
    }

    if (_facebookLink.text.isNotEmpty) {
      var invalidFacebook = sl<Validators>().validateUrl(_facebookLink.text, 'facebook_group');
      if (invalidFacebook != null) return FlushPopup.onWarning(message: invalidFacebook);
    }

    setState(() => _loader = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _loader = false);
    if (widget.onUpdate != null) widget.onUpdate!(widget.club);
    backToPrevious();
    await Future.delayed(const Duration(milliseconds: 300));
    FlushPopup.onInfo(message: 'updated_successfully'.recast);
  }
}
