import 'package:flutter/services.dart';

class TwoWordInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.trim().isEmpty) return newValue;
    final words = newValue.text.trim().split(RegExp(r'\s+'));
    if (words.length <= 2) return newValue;
    return oldValue;
  }
}

class PriceInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.trim();
    if (text.isEmpty) return newValue;
    final regex = RegExp(r'^\d*\.?\d*$');
    if (!regex.hasMatch(text)) return oldValue;
    final parsed = double.tryParse(text);
    if (parsed == null) return oldValue;
    if (parsed <= 0) return oldValue;
    return newValue;
  }
}
