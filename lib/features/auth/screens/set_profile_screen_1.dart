import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/components/loaders/circle_loader.dart';
import 'package:app/components/loaders/screen_loader.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/auth/view_models/set_profile_view_model.dart';
import 'package:app/features/profile/units/profile_question_option.dart';
import 'package:app/libraries/flush_popup.dart';
import 'package:app/services/routes.dart';
import 'package:app/services/validators.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/core/input_field.dart';
import 'package:app/widgets/library/svg_image.dart';
import 'package:app/widgets/ui/nav_button_box.dart';
import 'package:app/widgets/ui/phone_prefix.dart';

// country, phone, medium, social_id, name, email
class SetProfileScreen1 extends StatefulWidget {
  final Map<String, dynamic> data;
  const SetProfileScreen1({required this.data});

  @override
  State<SetProfileScreen1> createState() => _SetProfileScreen1State();
}

class _SetProfileScreen1State extends State<SetProfileScreen1> {
  var _viewModel = SetProfileViewModel();
  var _modelData = SetProfileViewModel();
  var _name = TextEditingController();
  var _email = TextEditingController();
  var _phone = TextEditingController();
  var _pgdaNumber = TextEditingController();
  var _focusNodes = [FocusNode(), FocusNode(), FocusNode(), FocusNode()];

  @override
  void initState() {
    // sl<AppAnalytics>().screenView('set-profile-screen');
    _setInitialState();
    _focusNodes.forEach((item) => item.addListener(() => setState(() {})));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _viewModel.initViewModel(widget.data));
    super.initState();
  }

  void _setInitialState() {
    _name.text = widget.data['name'];
    _email.text = widget.data['email'];
    _phone.text = widget.data['phone'];
  }

  @override
  void didChangeDependencies() {
    _viewModel = Provider.of<SetProfileViewModel>(context, listen: false);
    _modelData = Provider.of<SetProfileViewModel>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _viewModel.disposeViewModel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var borderRadius = const BorderRadius.only(topLeft: Radius.circular(60));
    var decoration = BoxDecoration(color: primary, borderRadius: borderRadius);
    return Scaffold(
      backgroundColor: skyBlue,
      body: Container(
        width: SizeConfig.width,
        height: SizeConfig.height,
        padding: EdgeInsets.only(top: SizeConfig.statusBar),
        child: Stack(
          children: [
            Column(children: [SizedBox(height: 13.height), Expanded(child: Container(decoration: decoration))]),
            SizedBox(width: SizeConfig.width, height: SizeConfig.height, child: _screenView(context)),
            if (_modelData.loader) const ScreenLoader(),
          ],
        ),
      ),
      bottomNavigationBar: NavButtonBox(
        childHeight: 42,
        loader: _modelData.loader,
        child: _navButtonActions(context),
      ),
    );
  }

  Widget _navButtonActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: ElevateButton(
            radius: 04,
            height: 42,
            background: skyBlue,
            onTap: backToPrevious,
            label: 'back'.recast.toUpper,
            textStyle: TextStyles.text14_700.copyWith(color: primary, fontWeight: w600, height: 1.15),
          ),
        ),
        const SizedBox(width: 08),
        Expanded(
          child: ElevateButton(
            radius: 04,
            height: 42,
            onTap: _onNext,
            label: 'next'.recast.toUpper,
            textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
          ),
        ),
      ],
    );
  }

  Widget _screenView(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      clipBehavior: Clip.antiAlias,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: Dimensions.screen_padding),
      children: [
        SizedBox(height: 4.3.height),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgImage(image: Assets.app.capty, height: 32.5, color: primary),
            const SizedBox(width: 10),
            SvgImage(image: Assets.app.capty_name, height: 32, color: primary),
          ],
        ),
        SizedBox(height: 10.height),
        Text('set_profile'.recast, textAlign: TextAlign.center, style: TextStyles.text24_600.copyWith(color: lightBlue)),
        const SizedBox(height: 20),
        Text(
          'fill_in_your_information_below'.recast,
          textAlign: TextAlign.center,
          style: TextStyles.text14_400.copyWith(color: lightBlue),
        ),
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
        const SizedBox(height: 20),
        Text('${'email'.recast}*', style: TextStyles.text14_600.copyWith(color: lightBlue)),
        const SizedBox(height: 04),
        InputField(
          controller: _email,
          focusNode: _focusNodes[1],
          hintText: '${'ex'.recast}. john_doe@gmail.com',
          keyboardType: TextInputType.emailAddress,
          onChanged: (v) => _viewModel.checkUniqueEmail(v),
          suffixIcon: _loaderSuffixBox(_modelData.emailCheck),
        ),
        const SizedBox(height: 20),
        if (widget.data['medium'] != 0)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('phone_number'.recast, style: TextStyles.text14_600.copyWith(color: lightBlue)),
              const SizedBox(height: 04),
              InputField(
                controller: _phone,
                hintText: 'XXX-XXX-XXXXX',
                focusNode: _focusNodes[2],
                keyboardType: TextInputType.phone,
                onChanged: (v) => _viewModel.checkUniquePhoneNumber(v),
                suffixIcon: _loaderSuffixBox(_modelData.phoneCheck),
                prefixIcon: PhonePrefix(country: _modelData.country, onChanged: (v) => setState(() => _modelData.country = v)),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ProfileQuestionOption(
          label: 'are_you_a_registered_pdga_member'.recast,
          value: _modelData.isPGDANumber,
          onToggle: (v) => setState(() => _modelData.isPGDANumber = v),
        ),
        const SizedBox(height: 08),
        if (_modelData.isPGDANumber) Text('pdga_number'.recast, style: TextStyles.text14_600.copyWith(color: lightBlue)),
        if (_modelData.isPGDANumber) const SizedBox(height: 04),
        if (_modelData.isPGDANumber)
          InputField(
            controller: _pgdaNumber,
            focusNode: _focusNodes[3],
            hintText: '${'ex'.recast}. 549867',
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
          ),
        SizedBox(height: BOTTOM_GAP),
      ],
    );
  }

  Widget _loaderSuffixBox(String value) {
    return Container(
      color: transparent,
      padding: const EdgeInsets.only(right: 12, left: 12),
      child: Builder(builder: (context) {
        if (value.toKey == '') {
          return const SizedBox.shrink();
        } else if (value.toKey == 'loader') {
          return const CircleLoader(radius: 12, color: primary);
        } else if (value.toKey == 'success') {
          return SvgImage(image: Assets.svg2.check_circle, height: 24, color: primary);
        } else if (value.toKey == 'failed') {
          return SvgImage(image: Assets.svg2.danger, height: 24, color: error);
        } else {
          return const SizedBox.shrink();
        }
      }),
    );
  }

  void _onNext() {
    minimizeKeyboard();
    var invalidName = sl<Validators>().name(_name.text);
    if (invalidName != null) return FlushPopup.onWarning(message: invalidName);
    var invalidEmail = sl<Validators>().email(_email.text);
    if (invalidEmail != null) return FlushPopup.onWarning(message: invalidEmail);
    var isUniqueEmail = _modelData.emailCheck.toKey == 'success'.toKey;
    if (!isUniqueEmail) return FlushPopup.onWarning(message: 'this_email_already_exist_please_try_with_another_email'.recast);
    if (widget.data['medium'] != 0) {
      var invalidPhone = sl<Validators>().phone(_phone.text, _modelData.country);
      if (invalidPhone != null) return FlushPopup.onWarning(message: invalidPhone);
      var isUnique = _modelData.phoneCheck.toKey == 'success'.toKey;
      if (!isUnique) return FlushPopup.onWarning(message: 'this_phone_number_already_exist_please_try_with_another_phone_number'.recast);
    }
    var invalidPGDANumber = _modelData.isPGDANumber && _pgdaNumber.text.isEmpty;
    if (invalidPGDANumber) return FlushPopup.onWarning(message: 'please_write_your_pdga_number'.recast);
    var parameters = {
      'country': _modelData.country,
      'phone': _phone.text,
      'medium': widget.data['medium'],
      'social_id': widget.data['social_id'],
      'name': _name.text.trim(),
      'email': _email.text,
      'pgda_number': _pgdaNumber.text.trim(),
    };
    Routes.auth.set_profile_2(data: parameters).push();
    /*var invalidClubName = _modelData.isClubName && _clubName.text.isEmpty;
    if (invalidClubName) return FlushPopup.onWarning(message: 'please_write_your_club_name'.recast);
    var invalidUDiscUsername = _modelData.isDiscUsername && _discUsername.text.isEmpty;
    if (invalidUDiscUsername) return FlushPopup.onWarning(message: 'please_write_your_udisc_username'.recast);*/
  }
}

/*class _QuestionOption extends StatelessWidget {
  final String label;
  final bool value;
  final Function(bool) onToggle;

  const _QuestionOption({required this.onToggle, this.label = '', this.value = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(text: label, style: TextStyles.text14_600.copyWith(color: lightBlue, height: 1)),
                TextSpan(text: ' ', style: TextStyles.text14_600.copyWith(color: lightBlue, height: 1)),
                WidgetSpan(child: SvgImage(image: Assets.svg1.question, height: 18, color: lightBlue)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        FlutterSwitch(
          height: 24,
          value: value,
          onToggle: onToggle,
          inactiveColor: grey,
          activeColor: mediumBlue,
          activeToggleColor: lightBlue,
          inactiveToggleColor: lightBlue,
        ),
      ],
    );
  }
}*/
