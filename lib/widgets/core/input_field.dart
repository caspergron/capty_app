import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:app/extensions/flutter_ext.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/text_styles.dart';

class InputField extends StatelessWidget {
  final double padding;
  final double fontSize;
  final int minLines;
  final int maxLines;
  final bool obscureText;
  final Color fillColor;
  final bool readOnly;
  final bool showCursor;
  final bool autoFocus;
  final BorderRadius? borderRadius;
  final double cursorHeight;
  final EdgeInsetsGeometry contentPadding;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final String hintText;
  final Color hintColor;
  final Color textColor;
  final Color cursorColor;
  final Color enabledBorder;
  final Color focusedBorder;
  final int? maxLength;
  final FocusNode? focusNode;
  final String? counterText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? initialValue;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final Function()? onEditingComplete;
  final Function(PointerDownEvent)? onTapOutside;
  final Function()? onTap;
  final Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;

  const InputField({
    this.padding = 0,
    this.fontSize = 14,
    this.borderRadius,
    this.cursorHeight = 16,
    this.minLines = 1,
    this.maxLines = 1,
    this.obscureText = false,
    this.fillColor = lightBlue,
    this.readOnly = false,
    this.autoFocus = false,
    this.showCursor = true,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12.5),
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.textCapitalization = TextCapitalization.none,
    this.hintText = '',
    this.hintColor = text,
    this.textColor = text,
    this.cursorColor = dark,
    this.enabledBorder = primary,
    this.focusedBorder = primary,
    this.maxLength,
    this.focusNode,
    this.counterText,
    this.prefixIcon,
    this.suffixIcon,
    this.initialValue,
    this.controller,
    this.onChanged,
    this.onEditingComplete,
    this.onTapOutside,
    this.onTap,
    this.onFieldSubmitted,
    this.validator,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) => Padding(padding: EdgeInsets.symmetric(horizontal: padding), child: _textFormField(context));

  // return GestureDetector(onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
  Widget _textFormField(BuildContext context) {
    FocusNode _internalFocusNode = FocusNode();
    return Focus(
      focusNode: _internalFocusNode,
      child: TextFormField(
        validator: validator,
        maxLength: maxLength,
        controller: controller,
        initialValue: initialValue,
        readOnly: readOnly,
        autofocus: autoFocus,
        decoration: _inputDecoration,
        showCursor: showCursor,
        cursorWidth: 1.2,
        cursorHeight: cursorHeight,
        minLines: minLines,
        maxLines: maxLines,
        obscureText: obscureText,
        cursorColor: cursorColor,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        focusNode: focusNode ?? _internalFocusNode,
        textCapitalization: textCapitalization,
        onTap: onTap,
        onFieldSubmitted: onFieldSubmitted,
        onChanged: onChanged,
        inputFormatters: inputFormatters,
        onSaved: controller != null ? (val) => controller?.text = val! : null,
        style: TextStyles.text14_700.copyWith(color: textColor.colorOpacity(_is_disabled ? 0.7 : 1), height: 1.3, fontSize: fontSize),
        onEditingComplete: () => _onEditingComplete(context),
        onTapOutside: (event) => _onTapOutside(context, event),
        textAlignVertical: TextAlignVertical.top,
      ),
    );
  }

  void _onEditingComplete(BuildContext context) {
    FocusScope.of(context).unfocus();
    if (onEditingComplete != null) onEditingComplete!();
  }

  void _onTapOutside(BuildContext context, PointerDownEvent event) {
    FocusScope.of(context).unfocus();
    if (onTapOutside != null) onTapOutside!(event);
  }

  bool get _is_disabled => readOnly == true;

  InputDecoration get _inputDecoration {
    return InputDecoration(
      filled: true,
      isDense: true,
      enabled: !_is_disabled,
      errorMaxLines: 1,
      hintText: hintText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      counterText: counterText,
      fillColor: fillColor,
      // focusColor: primary,
      prefixIconConstraints: const BoxConstraints(minWidth: 24, minHeight: 24),
      suffixIconConstraints: const BoxConstraints(minWidth: 24, minHeight: 24),
      contentPadding: contentPadding,
      prefixIconColor: _is_disabled ? grey : WidgetStateColor.resolveWith((states) => states.contains(WidgetState.focused) ? dark : grey),
      suffixIconColor: _is_disabled ? grey : WidgetStateColor.resolveWith((states) => states.contains(WidgetState.focused) ? dark : grey),
      border: _outlinedOrEnabled,
      enabledBorder: _outlinedOrEnabled,
      disabledBorder: _outlinedDisabled,
      focusedBorder: _outlinedFocused,
      errorBorder: _outlinedError,
      focusedErrorBorder: _outlinedError,
      labelStyle: TextStyles.text14_500.copyWith(color: text.colorOpacity(_is_disabled ? 0.7 : 1), height: 1, fontSize: fontSize),
      hintStyle: TextStyles.text14_400.copyWith(color: hintColor.colorOpacity(_is_disabled ? 0.7 : 0.7), height: 1.3, fontSize: fontSize),
      errorStyle: TextStyles.text14_600.copyWith(color: error),
      alignLabelWithHint: true,
    );
  }

  get _radius => borderRadius ?? BorderRadius.circular(08);
  get _outlinedOrEnabled => OutlineInputBorder(borderRadius: _radius, borderSide: BorderSide(color: enabledBorder));
  get _outlinedFocused => OutlineInputBorder(borderRadius: _radius, borderSide: BorderSide(color: focusedBorder));
  get _outlinedDisabled => OutlineInputBorder(borderRadius: _radius, borderSide: BorderSide(color: enabledBorder));
  get _outlinedError => OutlineInputBorder(borderRadius: _radius, borderSide: const BorderSide(color: error));
}
