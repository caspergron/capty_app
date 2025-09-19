import 'dart:io';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/components/buttons/outline_button.dart';
import 'package:app/components/dialogs/change_language_dialog.dart';
import 'package:app/components/loaders/screen_loader.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/auth/view_models/sign_in_view_model.dart';
import 'package:app/libraries/flush_popup.dart';
import 'package:app/models/public/country.dart';
import 'package:app/preferences/app_preferences.dart';
import 'package:app/services/routes.dart';
import 'package:app/services/storage_service.dart';
import 'package:app/services/validators.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/core/input_field.dart';
import 'package:app/widgets/core/rectangle_check_box.dart';
import 'package:app/widgets/library/svg_image.dart';
import 'package:app/widgets/ui/nav_button_box.dart';
import 'package:app/widgets/ui/phone_prefix.dart';

class SignInScreen extends StatefulWidget {
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  var _viewModel = SignInViewModel();
  var _modelData = SignInViewModel();
  var _phone = TextEditingController();
  var _focusNode = FocusNode();

  @override
  void initState() {
    // sl<AppAnalytics>().screenView('sign-in-screen');
    _phone.text = sl<StorageService>().phoneNumber;
    _focusNode.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _viewModel.initViewModel());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _viewModel = Provider.of<SignInViewModel>(context, listen: false);
    _modelData = Provider.of<SignInViewModel>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _viewModel.disposeViewModel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.only(topLeft: Radius.circular(60));
    const decoration = BoxDecoration(color: primary, borderRadius: borderRadius);
    final style = TextStyles.text14_400.copyWith(color: lightBlue, decoration: TextDecoration.underline);
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
        loader: _modelData.loader,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 04),
          child: Text('terms_and_conditions'.recast, textAlign: TextAlign.center, style: style),
        ),
      ),
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
        SizedBox(height: 11.5.height),
        Text('sign_in'.recast, textAlign: TextAlign.center, style: TextStyles.text24_600.copyWith(color: lightBlue)),
        SizedBox(height: 5.height),
        Text('phone_number'.recast, style: TextStyles.text14_600.copyWith(color: lightBlue)),
        const SizedBox(height: 04),
        InputField(
          controller: _phone,
          hintText: 'XXX-XXX-XXXXX',
          focusNode: _focusNode,
          keyboardType: TextInputType.phone,
          prefixIcon: PhonePrefix(country: _modelData.country, onChanged: _onChangeCountry),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            RectangleCheckBox(
              size: 22,
              color: lightBlue,
              isChecked: _modelData.isPolicy,
              selectedColor: lightBlue,
              onTap: () => setState(() => _modelData.isPolicy = !_modelData.isPolicy),
            ),
            const SizedBox(width: 1),
            Expanded(
              child: Text.rich(
                maxLines: 1,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'agree_with'.recast,
                      style: TextStyles.text13_600.copyWith(color: lightBlue, height: 1),
                    ),
                    const TextSpan(text: ' '),
                    TextSpan(
                      text: 'terms_and_conditions'.recast,
                      style: TextStyles.text13_600.copyWith(color: lightBlue, decoration: TextDecoration.underline, height: 1),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.height),
        Center(
          child: ElevateButton(
            radius: 04,
            height: 42,
            padding: 40,
            width: 60.width,
            label: 'sign_in'.recast.toUpper,
            onTap: _onSignInWithEmail,
            textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
          ),
        ),
        const SizedBox(height: 20),
        Text('or'.recast.toUpper, textAlign: TextAlign.center, style: TextStyles.text14_400.copyWith(color: lightBlue)),
        const SizedBox(height: 20),
        Center(
          child: Platform.isIOS
              ? OutlineButton(
                  radius: 04,
                  height: 44,
                  padding: 16,
                  width: 60.width,
                  border: lightBlue,
                  background: transparent,
                  onTap: _viewModel.signInWithApple,
                  label: 'continue_with_aApple'.recast.toUpper,
                  icon: SvgImage(image: Assets.svg2.apple, height: 20, color: lightBlue),
                  textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
                )
              : OutlineButton(
                  radius: 04,
                  height: 44,
                  padding: 16,
                  width: 60.width,
                  border: lightBlue,
                  background: transparent,
                  onTap: _viewModel.signInWithGoogle,
                  label: 'continue_with_google'.recast.toUpper,
                  icon: SvgImage(image: Assets.svg_image.google, height: 16),
                  textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
                ),
        ),
        SizedBox(height: 8.height),
        Text('do_not_see_your_country'.recast, textAlign: TextAlign.center, style: TextStyles.text14_400.copyWith(color: lightBlue)),
        Text('join_our_waitlist'.recast, textAlign: TextAlign.center, style: TextStyles.text14_400.copyWith(color: lightBlue)),
        InkWell(
          onTap: Routes.public.waitlist().push,
          child: Text('join'.recast, textAlign: TextAlign.center, style: TextStyles.text14_700.copyWith(color: orange)),
        ),
        SizedBox(height: BOTTOM_GAP),
      ],
    );
  }

  void _onChangeCountry(Country item) {
    if (_modelData.country.id == item.id) return;
    setState(() => _modelData.country = item);
    final langKey = item.appLanguage.toKey;
    if (langKey.isEmpty || langKey == AppPreferences.language.code.toKey) return;
    changeLanguageDialog(country: item, onProceed: (languageItem) => _viewModel.onChangeLanguage(languageItem));
  }

  void _onSignInWithEmail() {
    minimizeKeyboard();
    final invalidPhone = sl<Validators>().phone(_phone.text, _modelData.country);
    if (invalidPhone != null) return FlushPopup.onWarning(message: invalidPhone);
    if (!_modelData.isPolicy) return FlushPopup.onWarning(message: 'please_accept_our_terms_and_conditions'.recast);
    _viewModel.onSignIn(_phone.text.trim());
  }
}
