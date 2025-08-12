import 'package:flutter/material.dart';

import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/constants/app_keys.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/profile/units/profile_question_option.dart';
import 'package:app/libraries/flush_popup.dart';
import 'package:app/models/user/user.dart';
import 'package:app/preferences/user_preferences.dart';
import 'package:app/services/validators.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/shadows.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/transitions.dart';
import 'package:app/widgets/core/input_field.dart';
import 'package:app/widgets/core/pop_scope_navigator.dart';

Future<void> editProfileDialog({required User person, Function(Map<String, dynamic>)? onEdit}) async {
  var context = navigatorKey.currentState!.context;
  await showGeneralDialog(
    context: context,
    barrierLabel: 'Edit Profile Dialog',
    transitionDuration: DIALOG_DURATION,
    transitionBuilder: sl<Transitions>().bottomToTop,
    pageBuilder: (buildContext, anim1, anim2) => Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: PopScopeNavigator(canPop: false, child: Align(child: _DialogView(onEdit))),
    ),
  );
}

class _DialogView extends StatefulWidget {
  final Function(Map<String, dynamic>)? onEdit;
  const _DialogView(this.onEdit);

  @override
  State<_DialogView> createState() => _DialogViewState();
}

class _DialogViewState extends State<_DialogView> {
  // var _isDiscUsername = false;
  var _isPGDANumber = false;
  // var _selectedHand = DataModel();
  var _name = TextEditingController();
  var _discUsername = TextEditingController();
  var _pgdaNumber = TextEditingController();
  var _focusNodes = [FocusNode(), FocusNode(), FocusNode()];

  @override
  void initState() {
    _setInitialStates();
    // sl<AppAnalytics>().screenView('edit-profile-popup');
    _focusNodes.forEach((item) => item.addListener(() => setState(() {})));
    super.initState();
  }

  void _setInitialStates() {
    var user = UserPreferences.user;
    _name.text = user.name ?? '';
    _discUsername.text = user.uDiscUsername ?? '';
    _pgdaNumber.text = user.pdgaNumber ?? '';
    // if (user.uDiscUsername != null) _isDiscUsername = true;
    if (user.pdgaNumber != null) _isPGDANumber = true;
    // if (user.handPref != null) _selectedHand = DataModel.handPreference(user.handPref!);
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(child: Text('edit_profile'.recast, style: TextStyles.text20_500.copyWith(color: lightBlue, fontSize: 22))),
        const SizedBox(height: 20),
        Text('${'name'.recast}*', style: TextStyles.text14_600.copyWith(color: lightBlue)),
        const SizedBox(height: 04),
        InputField(
          controller: _name,
          focusNode: _focusNodes[0],
          hintText: '${'ex'.recast}. ${'john_doe'.recast}',
          keyboardType: TextInputType.name,
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 16),
        /*ProfileQuestionOption(
          value: _isDiscUsername,
          label: 'are_you_a_disc_member'.recast,
          onToggle: (v) => setState(() => _isDiscUsername = v),
        ),
        if (_isDiscUsername) const SizedBox(height: 06),
        if (_isDiscUsername) Text('udisc_username'.recast, style: TextStyles.text14_600.copyWith(color: lightBlue)),
        if (_isDiscUsername) const SizedBox(height: 04),
        if (_isDiscUsername)
          InputField(
            controller: _discUsername,
            focusNode: _focusNodes[1],
            hintText: '${'ex'.recast}. ${'tree_line_tossers'.recast}',
          ),
        const SizedBox(height: 16),*/
        ProfileQuestionOption(
          label: 'are_you_a_registered_pdga_member'.recast,
          value: _isPGDANumber,
          onToggle: (v) => setState(() => _isPGDANumber = v),
        ),
        if (_isPGDANumber) const SizedBox(height: 06),
        if (_isPGDANumber) Text('pdga_number'.recast, style: TextStyles.text14_600.copyWith(color: lightBlue)),
        if (_isPGDANumber) const SizedBox(height: 04),
        if (_isPGDANumber)
          InputField(
            controller: _pgdaNumber,
            focusNode: _focusNodes[2],
            hintText: '${'ex'.recast}. 549867',
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
          ),
        /*const SizedBox(height: 16),
        Text('are_you_a_left_handed_or_right_handed'.recast, style: TextStyles.text14_600.copyWith(color: lightBlue)),
        const SizedBox(height: 10),
        ListView.separated(
          shrinkWrap: true,
          clipBehavior: Clip.antiAlias,
          itemCount: HANDS_LIST.length,
          padding: const EdgeInsets.only(bottom: 12),
          itemBuilder: _handListItemCard,
          separatorBuilder: (context, index) => SizedBox(height: index == HANDS_LIST.length - 1 ? 0 : 10),
        ),*/
        // const SizedBox(height: 16),
        const SizedBox(height: 26),
        Row(
          children: [
            Expanded(
              child: ElevateButton(
                radius: 04,
                height: 36,
                background: skyBlue,
                onTap: backToPrevious,
                width: double.infinity,
                label: 'undo_changes'.recast.toUpper,
                textStyle: TextStyles.text14_700.copyWith(color: primary, fontWeight: w600, height: 1.15),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevateButton(
                radius: 04,
                height: 36,
                onTap: _onSaveProfile,
                width: double.infinity,
                label: 'update_profile'.recast.toUpper,
                textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
              ),
            ),
          ],
        ),
        const SizedBox(height: 04),
      ],
    );
  }

  /*Widget _handListItemCard(BuildContext context, int index) {
    var item = HANDS_LIST[index];
    var selected = _selectedHand.value == item.value;
    return InkWell(
      onTap: () => setState(() => _selectedHand = item),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedRadio(value: selected, color: lightBlue),
          const SizedBox(width: 08),
          Text(item.label, style: TextStyles.text14_400.copyWith(color: lightBlue, height: 1)),
        ],
      ),
    );
  }*/

  void _onSaveProfile() {
    var invalidName = sl<Validators>().name(_name.text);
    if (invalidName != null) return FlushPopup.onWarning(message: invalidName);
    // var invalidUDiscUsername = _isDiscUsername && _discUsername.text.isEmpty;
    // if (invalidUDiscUsername) return FlushPopup.onWarning(message: 'please_write_your_udisc_username'.recast);
    var invalidPGDANumber = _isPGDANumber && _pgdaNumber.text.isEmpty;
    if (invalidPGDANumber) return FlushPopup.onWarning(message: 'please_write_your_pdga_number'.recast);
    // if (_selectedHand.value.isEmpty) return FlushPopup.onWarning(message: 'please_select_an_option_of_your_hand'.recast);
    var body = {
      'name': _name.text,
      // if (_isDiscUsername) 'udisc_username': _discUsername.text,
      if (_isPGDANumber) 'pdga_number': _pgdaNumber.text,
      'hand_preference': null, //  _selectedHand.value
    };
    if (widget.onEdit != null) widget.onEdit!(body);
    backToPrevious();
  }
}
