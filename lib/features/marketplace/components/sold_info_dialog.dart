import 'package:flutter/material.dart';

import 'package:app/animations/tween_list_item.dart';
import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/constants/app_keys.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/libraries/flush_popup.dart';
import 'package:app/models/marketplace/sales_ad.dart';
import 'package:app/models/system/data_model.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/shadows.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/transitions.dart';
import 'package:app/widgets/core/animated_radio.dart';
import 'package:app/widgets/core/input_field.dart';
import 'package:app/widgets/core/pop_scope_navigator.dart';
import 'package:app/widgets/library/svg_image.dart';
import 'package:app/widgets/ui/character_counter.dart';

List<DataModel> _SOLD_INFO_LIST = [
  DataModel(label: 'Through Capty', value: 'capty'),
  DataModel(label: 'Through Contacts', value: 'contacts'),
  DataModel(label: 'Through other channel', value: 'other channel'),
];

Future<void> soldInfoDialog({required SalesAd marketplace, Function(Map<String, dynamic>)? onSave}) async {
  var context = navigatorKey.currentState!.context;
  var padding = MediaQuery.of(context).viewInsets;
  var child = Align(child: _DialogView(marketplace, onSave));
  await showGeneralDialog(
    context: context,
    barrierLabel: 'Sold Info Dialog',
    transitionDuration: DIALOG_DURATION,
    transitionBuilder: sl<Transitions>().bottomToTop,
    pageBuilder: (buildContext, anim1, anim2) => Padding(padding: padding, child: PopScopeNavigator(canPop: false, child: child)),
  );
}

class _DialogView extends StatefulWidget {
  final SalesAd marketplace;
  final Function(Map<String, dynamic>)? onSave;
  const _DialogView(this.marketplace, this.onSave);

  @override
  State<_DialogView> createState() => _DialogViewState();
}

class _DialogViewState extends State<_DialogView> {
  var _soldInfo = DataModel();
  var _focusNode = FocusNode();
  var _channel = TextEditingController();

  @override
  void initState() {
    // sl<AppAnalytics>().screenView('sold-info-popup');
    _focusNode.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimensions.dialog_width,
      padding: EdgeInsets.symmetric(horizontal: Dimensions.dialog_padding, vertical: Dimensions.dialog_padding),
      decoration: BoxDecoration(color: primary, borderRadius: DIALOG_RADIUS, boxShadow: const [SHADOW_2]),
      child: Material(color: transparent, child: _screenView(context), shape: DIALOG_SHAPE),
    );
  }

  Widget _screenView(BuildContext context) {
    var isInputField = _soldInfo.value == 'other channel';
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('mvp_trail'.recast, style: TextStyles.text16_600.copyWith(color: lightBlue)),
            InkWell(onTap: backToPrevious, child: SvgImage(image: Assets.svg1.close_1, height: 18, color: lightBlue)),
          ],
        ),
        const SizedBox(height: 40),
        Text('how_did_you_sell_the_disc'.recast, style: TextStyles.text20_500.copyWith(color: white, fontWeight: w700)),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          clipBehavior: Clip.antiAlias,
          itemCount: _SOLD_INFO_LIST.length,
          padding: EdgeInsets.zero,
          itemBuilder: _soldInfoItemCard,
        ),
        if (isInputField) const SizedBox(height: 12),
        if (isInputField)
          TweenListItem(
            child: InputField(
              minLines: 4,
              maxLines: 12,
              fontSize: 12,
              maxLength: 150,
              counterText: '',
              controller: _channel,
              focusNode: _focusNode,
              enabledBorder: lightBlue,
              focusedBorder: lightBlue,
              onChanged: (v) => setState(() {}),
              borderRadius: BorderRadius.circular(04),
              hintText: 'tell_us_something_about_the_channel'.recast,
            ),
          ),
        if (isInputField && _channel.text.isNotEmpty) const SizedBox(height: 06),
        if (isInputField && _channel.text.isNotEmpty) CharacterCounter(count: _channel.text.length, total: 150),
        const SizedBox(height: 40),
        ElevateButton(
          radius: 04,
          height: 36,
          onTap: _onSave,
          width: double.infinity,
          label: 'save_details'.recast.toUpper,
          textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
        ),
      ],
    );
  }

  void _onSave() {
    if (_soldInfo.value.isEmpty) return FlushPopup.onWarning(message: 'please_select_an_option'.recast);
    var invalidChannelInfo = _soldInfo.value == 'other channel' && _channel.text.isEmpty;
    if (invalidChannelInfo) return FlushPopup.onWarning(message: 'please_write_something_about_your_channel'.recast);
    var isOtherChannel = _soldInfo.value == 'other channel';
    var data = {'is_sold': true, 'sold_through': _soldInfo.value, if (isOtherChannel) 'sold_through_details': _channel.text};
    if (widget.onSave != null) widget.onSave!(data);
    backToPrevious();
  }

  Widget _soldInfoItemCard(BuildContext context, int index) {
    var item = _SOLD_INFO_LIST[index];
    var selected = _soldInfo.value.isNotEmpty && _soldInfo.value == item.value;
    var style = TextStyles.text14_400.copyWith(color: lightBlue, fontSize: 15);
    return InkWell(
      onTap: () => setState(() => _soldInfo = item),
      child: Container(
        width: double.infinity,
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(bottom: index == _SOLD_INFO_LIST.length - 1 ? 0 : 06),
        child: AnimatedRadio(label: item.label, value: selected, color: skyBlue, style: style),
      ),
    );
  }
}
