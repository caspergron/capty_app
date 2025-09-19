import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'package:app/extensions/string_ext.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/widgets/core/input_field.dart';

class TypeAheadInputField<T> extends StatelessWidget {
  final FocusNode? focusNode;
  final bool enabled;
  final TextEditingController controller;
  final String hint;
  final Color hintColor;
  final String notFoundText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? borderColor;
  final EdgeInsets contentPadding;
  final FutureOr<List<T>> Function(String) onSuggestion;
  final Widget Function(BuildContext, T?) itemBuilder;
  final Function(T) onSuggestionSelected;

  const TypeAheadInputField({
    required this.controller,
    required this.onSuggestion,
    required this.onSuggestionSelected,
    required this.itemBuilder,
    this.hintColor = text,
    this.prefixIcon,
    this.suffixIcon,
    this.borderColor,
    this.hint = '',
    this.enabled = true,
    this.focusNode,
    this.notFoundText = 'no_items_found',
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
  });

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<T>(
      focusNode: focusNode,
      controller: controller,
      suggestionsCallback: onSuggestion,
      hideKeyboardOnDrag: true,
      autoFlipMinHeight: 300,
      itemBuilder: itemBuilder,
      loadingBuilder: _typeAheadLoader,
      emptyBuilder: _notFoundBuilder,
      onSelected: onSuggestionSelected,
      transitionBuilder: (context, animation, child) {
        return FadeTransition(opacity: CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn), child: child);
      },
      builder: (context, controller, focusNode) => InputField(
        controller: controller,
        focusNode: focusNode,
        hintText: hint,
        hintColor: hintColor,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding: contentPadding,
        fillColor: transparent,
      ),
    );
  }

  Widget _notFoundBuilder(BuildContext context) {
    final child = Text(notFoundText.recast, style: TextStyles.text14_500.copyWith(color: dark));
    return Container(height: 50, alignment: Alignment.center, child: child);
  }

  Widget _typeAheadLoader(BuildContext context) {
    final radius = BorderRadius.circular(4);
    final loader = Container(height: 30, width: double.infinity, decoration: BoxDecoration(color: offWhite2, borderRadius: radius));
    return Container(
      height: 90,
      color: white,
      width: double.infinity,
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.all(10),
      child: Column(children: [loader, const SizedBox(height: 10), loader]),
    );
  }
}
