import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/components/loaders/screen_loader.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/auth/view_models/otp_view_model.dart';
import 'package:app/libraries/flush_popup.dart';
import 'package:app/models/public/country.dart';
import 'package:app/services/validators.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/library/otp_field.dart';
import 'package:app/widgets/library/svg_image.dart';
import 'package:app/widgets/ui/nav_button_box.dart';

class OtpScreen extends StatefulWidget {
  // country, phone, phone_with_prefix
  final Map<String, dynamic> data;
  const OtpScreen({required this.data});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  var _focusNode = FocusNode();
  var _viewModel = OtpViewModel();
  var _modelData = OtpViewModel();
  var _otpCode = TextEditingController();

  @override
  void initState() {
    // sl<AppAnalytics>().screenView('verify-code-screen');
    _focusNode.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _viewModel.initViewModel());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _viewModel = Provider.of<OtpViewModel>(context, listen: false);
    _modelData = Provider.of<OtpViewModel>(context);
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
        childHeight: 110,
        loader: _modelData.loader,
        child: _navbarActions(context),
      ),
    );
  }

  Widget _navbarActions(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 08),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevateButton(
              radius: 04,
              height: 42,
              width: 33.width,
              background: skyBlue,
              onTap: backToPrevious,
              label: 'back'.recast.toUpper,
              textStyle: TextStyles.text14_700.copyWith(color: primary, fontWeight: w600, height: 1.15),
            ),
            const SizedBox(width: 08),
            ElevateButton(
              radius: 04,
              height: 42,
              width: 33.width,
              label: 'next'.recast.toUpper,
              onTap: _onConfirmOtp,
              textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Text(
          'terms_and_conditions'.recast,
          textAlign: TextAlign.center,
          style: TextStyles.text14_400.copyWith(color: lightBlue, decoration: TextDecoration.underline),
        ),
      ],
    );
  }

  Widget _screenView(BuildContext context) {
    var country = widget.data['country'] as Country?;
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
        Text('verify_your_phone'.recast, textAlign: TextAlign.center, style: TextStyles.text24_600.copyWith(color: lightBlue)),
        const SizedBox(height: 20),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'please_enter_the_4_digit_code_sent_as_a_text_message_to'.recast,
                style: TextStyles.text14_400.copyWith(color: lightBlue),
              ),
              const TextSpan(text: ' '),
              TextSpan(text: '${country?.phonePrefix ?? ''} ', style: TextStyles.text14_700.copyWith(color: lightBlue)),
              TextSpan(text: '${widget.data['phone']}'.formatted_phone_number, style: TextStyles.text14_700.copyWith(color: lightBlue)),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 48),
        OtpField(onChanged: print, otpController: _otpCode, focusNode: _focusNode),
        const SizedBox(height: 0),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: 'did_not_get_the_code'.recast, style: TextStyles.text14_400.copyWith(color: lightBlue)),
              const TextSpan(text: ' '),
              TextSpan(
                text: 'resend_code'.recast.toUpper,
                style: TextStyles.text14_700.copyWith(color: orange),
                recognizer: TapGestureRecognizer()..onTap = () => _viewModel.onResendCode(widget.data),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: BOTTOM_GAP),
      ],
    );
  }

  void _onConfirmOtp() {
    minimizeKeyboard();
    var invalidOtp = sl<Validators>().otpCode(_otpCode.text.toKey);
    if (invalidOtp != null) return FlushPopup.onWarning(message: invalidOtp);
    _viewModel.onVerifyOtp(widget.data, _otpCode.text.toKey);
  }
}
