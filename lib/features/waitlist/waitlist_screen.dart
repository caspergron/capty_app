import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/components/loaders/screen_loader.dart';
import 'package:app/components/menus/back_menu.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/waitlist/components/default_country_sheet.dart';
import 'package:app/features/waitlist/waitlist_view_model.dart';
import 'package:app/libraries/flush_popup.dart';
import 'package:app/services/validators.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/gradients.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/core/input_field.dart';
import 'package:app/widgets/library/svg_image.dart';
import 'package:app/widgets/ui/label_placeholder.dart';
import 'package:app/widgets/ui/nav_button_box.dart';

class WaitlistScreen extends StatefulWidget {
  @override
  State<WaitlistScreen> createState() => _WaitlistScreenState();
}

class _WaitlistScreenState extends State<WaitlistScreen> {
  var _viewModel = WaitlistViewModel();
  var _modelData = WaitlistViewModel();
  var _name = TextEditingController();
  var _email = TextEditingController();
  var _focusNodes = [FocusNode(), FocusNode()];

  @override
  void initState() {
    // sl<AppAnalytics>().screenView('waitlist-screen');
    _focusNodes.forEach((item) => item.addListener(() => setState(() {})));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _viewModel.initViewModel());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _viewModel = Provider.of<WaitlistViewModel>(context, listen: false);
    _modelData = Provider.of<WaitlistViewModel>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _viewModel.disposeViewModel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const BackMenu(),
        title: Text('join_waitlist'.recast),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        width: SizeConfig.width,
        height: SizeConfig.height,
        decoration: BoxDecoration(gradient: BACKGROUND_GRADIENT),
        child: Stack(children: [_screenView(context), if (_modelData.loader) const ScreenLoader()]),
      ),
      bottomNavigationBar: NavButtonBox(childHeight: 42, loader: _modelData.loader, child: _submitButton),
    );
  }

  Widget get _submitButton {
    return ElevateButton(
      radius: 04,
      height: 42,
      onTap: _onSubmit,
      width: double.infinity,
      label: 'submit'.recast.toUpper,
      textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
    );
  }

  Widget _screenView(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      clipBehavior: Clip.antiAlias,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: Dimensions.screen_padding),
      children: [
        const SizedBox(height: 16),
        Text('please_join_our_waitlist'.recast, style: TextStyles.text20_500.copyWith(color: primary, fontWeight: w600, height: 1)),
        const SizedBox(height: 20),
        Text('${'your_name'.recast}*', style: TextStyles.text14_600.copyWith(color: primary)),
        const SizedBox(height: 04),
        InputField(
          controller: _name,
          focusNode: _focusNodes[0],
          hintText: '${'ex'.recast}. ${'john_doe'.recast}',
          keyboardType: TextInputType.name,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (value) => FocusScope.of(context).requestFocus(_focusNodes[1]),
        ),
        const SizedBox(height: 16),
        Text('${'your_email'.recast}*', style: TextStyles.text14_600.copyWith(color: primary)),
        const SizedBox(height: 04),
        InputField(
          controller: _email,
          focusNode: _focusNodes[1],
          hintText: '${'ex'.recast}. john@capty.com',
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        Text('${'which_country_are_you_from'.recast}*', style: TextStyles.text14_600.copyWith(color: primary)),
        const SizedBox(height: 04),
        LabelPlaceholder(
          radius: 08,
          height: 42,
          border: primary,
          hint: 'select_your_country',
          label: _modelData.country?.name ?? '',
          endIcon: SvgImage(image: Assets.svg1.caret_down_2, height: 16, color: primary),
          onTap: () => defaultCountriesSheet(country: _modelData.country, onChanged: (v) => setState(() => _modelData.country = v)),
        ),
      ],
    );
  }

  void _onSubmit() {
    minimizeKeyboard();
    var invalidName = sl<Validators>().name(_name.text);
    if (invalidName != null) return FlushPopup.onWarning(message: invalidName);
    var invalidEmail = sl<Validators>().email(_email.text);
    if (invalidEmail != null) return FlushPopup.onWarning(message: invalidEmail);
    if (_modelData.country == null) return FlushPopup.onWarning(message: 'please_select_your_country'.recast);
    _viewModel.onSubmit(_name.text.toKey, _email.text.toKey);
  }
}
