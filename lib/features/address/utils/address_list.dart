import 'package:flutter/material.dart';

import 'package:app/extensions/string_ext.dart';
import 'package:app/features/address/components/delete_address_dialog.dart';
import 'package:app/libraries/flush_popup.dart';
import 'package:app/models/address/address.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/widgets/library/svg_image.dart';

class AddressList extends StatelessWidget {
  final bool isSelectable;
  final List<Address> addressList;
  final Function(Address, int)? onItem;
  final Function(Address, int)? onDelete;
  final Function(Address, int)? onUpdate;

  const AddressList({this.isSelectable = false, this.onUpdate, this.onItem, this.onDelete, this.addressList = const []});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      itemCount: addressList.length,
      itemBuilder: _addressCard,
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  Widget _addressCard(BuildContext context, int index) {
    var item = addressList[index];
    var editIcon = SvgImage(image: Assets.svg1.edit, color: warning, height: 20);
    var deleteIcon = SvgImage(image: Assets.svg1.trash, color: error, height: 20);
    // print(item.latitude);
    // print(item.longitude);
    return InkWell(
      onTap: () => _onSelect(item, index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        margin: EdgeInsets.only(bottom: index == addressList.length - 1 ? 0 : 12),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(08), border: Border.all(color: primary)),
        child: Row(
          children: [
            CircleAvatar(
              radius: 15,
              backgroundColor: mediumBlue,
              child: SvgImage(image: item.address_label_icon, height: 17, color: white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.formatted_address,
                    maxLines: 1,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.text14_600.copyWith(color: primary),
                  ),
                  Text(
                    item.formatted_state_country,
                    maxLines: 2,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.text12_400.copyWith(color: primary, fontSize: 12.5),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            if (onUpdate != null || onDelete != null)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (onUpdate != null) InkWell(child: editIcon, onTap: () => onUpdate == null ? null : onUpdate!(item, index)),
                  if (!item.is_home) const SizedBox(width: 12),
                  if (onDelete != null && !item.is_home) InkWell(child: deleteIcon, onTap: () => _onDelete(item, index)),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void _onDelete(Address item, int index) => deleteAddressDialog(onDelete: () => onDelete!(item, index));

  void _onSelect(Address item, int index) {
    if (onItem == null || !isSelectable) return;
    if (!item.is_home) return FlushPopup.onInfo(message: 'please_select_your_home_address'.recast);
    onItem!(item, index);
  }
}
