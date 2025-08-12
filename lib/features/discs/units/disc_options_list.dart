import 'package:flutter/material.dart';

import 'package:app/animations/tween_list_item.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/models/system/data_model.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/widgets/core/animated_radio.dart';

class DiscOptionsList extends StatelessWidget {
  final List<DataModel> discOptions;
  final DataModel? selectedItem;
  final Function(DataModel)? onSelect;

  const DiscOptionsList({this.discOptions = const [], this.onSelect, this.selectedItem});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      clipBehavior: Clip.antiAlias,
      itemCount: discOptions.length,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemBuilder: _discOptionItemCard,
    );
  }

  Widget _discOptionItemCard(BuildContext context, int index) {
    var item = discOptions[index];
    var selected = selectedItem != null && selectedItem!.value == item.value;
    return InkWell(
      onTap: onSelect == null ? null : () => onSelect!(item),
      child: TweenListItem(
        index: index,
        child: Container(
          width: double.infinity,
          key: Key('player-$index'),
          margin: EdgeInsets.only(bottom: index == discOptions.length - 1 ? 0 : 08),
          child: AnimatedRadio(
            value: selected,
            label: item.label.recast,
            style: TextStyles.text13_600.copyWith(color: primary, fontWeight: w400),
          ),
        ),
      ),
    );
  }
}
