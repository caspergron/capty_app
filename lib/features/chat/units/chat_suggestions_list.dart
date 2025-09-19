import 'package:flutter/material.dart';

import 'package:app/models/system/data_model.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/text_styles.dart';

class ChatSuggestionsList extends StatelessWidget {
  final List<DataModel> suggestions;
  final Function(DataModel) onTap;

  const ChatSuggestionsList({required this.suggestions, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Wrap(spacing: 06, runSpacing: 06, children: List.generate(suggestions.length, _suggestionItemCard).toList());
  }

  Widget _suggestionItemCard(int index) {
    final suggestion = suggestions[index];
    final border = Border.all(color: lightBlue, width: 0.5);
    return InkWell(
      onTap: () => onTap(suggestion),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 08, vertical: 8.5),
        decoration: BoxDecoration(color: transparent, border: border, borderRadius: BorderRadius.circular(04)),
        child: Text(suggestion.label, style: TextStyles.text14_400.copyWith(color: lightBlue, height: 1)),
      ),
    );
  }
}
