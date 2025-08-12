import 'package:flutter/material.dart';

import 'package:pin_code_fields/pin_code_fields.dart';

import 'package:app/extensions/number_ext.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/text_styles.dart';

class OtpField extends StatelessWidget {
  final FocusNode? focusNode;
  final TextEditingController otpController;
  final Function(String) onChanged;
  const OtpField({required this.otpController, required this.onChanged, this.focusNode});

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      length: 4,
      cursorHeight: 26,
      appContext: context,
      cursorColor: dark,
      onChanged: onChanged,
      focusNode: focusNode,
      enableActiveFill: true,
      backgroundColor: transparent,
      controller: otpController,
      pinTheme: _pinThemeData,
      animationType: AnimationType.fade,
      keyboardType: TextInputType.number,
      mainAxisAlignment: MainAxisAlignment.center,
      animationDuration: const Duration(milliseconds: 300),
      textStyle: TextStyles.text24_700.copyWith(color: dark),
    );
  }

  PinTheme get _pinThemeData {
    return PinTheme(
      fieldWidth: 15.width,
      fieldHeight: 17.width,
      activeColor: offWhite4,
      selectedColor: primary,
      inactiveColor: offWhite2,
      disabledColor: offWhite1,
      activeFillColor: offWhite2,
      inactiveFillColor: offWhite2,
      selectedFillColor: white,
      errorBorderColor: error,
      shape: PinCodeFieldShape.box,
      activeBorderWidth: 1,
      selectedBorderWidth: 1,
      borderWidth: 1,
      inactiveBorderWidth: 1,
      disabledBorderWidth: 1,
      errorBorderWidth: 1,
      fieldOuterPadding: const EdgeInsets.symmetric(horizontal: 06),
      borderRadius: BorderRadius.circular(06),
    );
  }
}
