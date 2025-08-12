import 'package:app/components/loaders/screen_loader.dart';
import 'package:app/components/menus/back_menu.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/address/components/shipping_update_info_dialog.dart';
import 'package:app/features/address/utils/address_list.dart';
import 'package:app/features/address/view_models/addresses_view_model.dart';
import 'package:app/models/address/address.dart';
import 'package:app/services/routes.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/gradients.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/core/flutter_switch.dart';
import 'package:app/widgets/library/svg_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddressesScreen extends StatefulWidget {
  final Function(Address)? onItem;

  const AddressesScreen({this.onItem});

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  var _viewModel = AddressesViewModel();
  var _modelData = AddressesViewModel();

  @override
  void initState() {
    // sl<AppAnalytics>().screenView('settings-screen');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _viewModel.initViewModel());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _viewModel = Provider.of<AddressesViewModel>(context, listen: false);
    _modelData = Provider.of<AddressesViewModel>(context);
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
        title: Text('addresses'.recast),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        width: SizeConfig.width,
        height: SizeConfig.height,
        decoration: BoxDecoration(gradient: BACKGROUND_GRADIENT),
        child: Stack(children: [_screenView(context), if (_modelData.loader.loader) const ScreenLoader()]),
      ),
    );
  }

  Widget _screenView(BuildContext context) {
    var addresses = _modelData.addresses;
    var homeAddress = addresses.isEmpty ? null : addresses.where((item) => item.is_home).toList().firstOrNull;
    var otherAddresses = addresses.isEmpty ? <Address>[] : addresses.where((item) => !item.is_home).toList();
    return ListView(
      shrinkWrap: true,
      clipBehavior: Clip.antiAlias,
      padding: EdgeInsets.symmetric(horizontal: Dimensions.screen_padding),
      physics: const BouncingScrollPhysics(),
      children: [
        const SizedBox(height: 10),
        Text('home_address'.recast, style: TextStyles.text16_600.copyWith(color: primary)),
        const SizedBox(height: 10),
        homeAddress == null
            ? _AddAddressOption(label: 'add_your_home_address', onTap: Routes.user.add_address(address: Address(label: 'home')).push)
            : AddressList(
                addressList: _modelData.addresses,
                onItem: (item, index) => widget.onItem == null ? null : _onSelect(item),
                onDelete: (item, index) => _viewModel.deleteAddress(item, index),
                onUpdate: (item, index) => Routes.user.add_address(address: item).push(),
              ),
        const SizedBox(height: 20),
        Text('pickup_points'.recast, style: TextStyles.text16_600.copyWith(color: primary)),
        const SizedBox(height: 10),
        if (otherAddresses.isNotEmpty)
          AddressList(
            addressList: _modelData.addresses,
            onItem: (item, index) => widget.onItem == null ? null : _onSelect(item),
            onDelete: (item, index) => _viewModel.deleteAddress(item, index),
            onUpdate: (item, index) => Routes.user.add_address(address: item).push(),
          ),
        if (otherAddresses.isNotEmpty) const SizedBox(height: 14),
        _AddAddressOption(
          onTap: Routes.user.add_address(address: Address(label: 'other')).push,
          label: otherAddresses.isEmpty ? 'add_your_pickup_points' : 'add_another_pickup_point',
        ),
        const SizedBox(height: 24),
        Text('shipping'.recast, style: TextStyles.text16_600.copyWith(color: primary)),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(08)),
          child: Row(
            children: [
              CircleAvatar(backgroundColor: lightBlue, radius: 13, child: SvgImage(image: Assets.svg1.truck, height: 19, color: primary)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'i_want_to_offer_shipping'.recast,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.text14_600.copyWith(color: lightBlue, height: 1),
                ),
              ),
              const SizedBox(width: 08),
              FlutterSwitch(
                width: 46,
                height: 24,
                inactiveColor: mediumBlue.colorOpacity(0.5),
                activeColor: mediumBlue,
                activeToggleColor: lightBlue,
                inactiveToggleColor: skyBlue,
                value: _modelData.isShipping,
                onToggle: (value) => !value
                    ? _viewModel.onUpdateShippingInfo(value)
                    : shippingUpdateInfoDialog(isShipping: value, onProceed: () => _viewModel.onUpdateShippingInfo(value)),
              ),
            ],
          ),
        ),
        SizedBox(height: BOTTOM_GAP),
      ],
    );
  }

  void _onSelect(Address item) {
    backToPrevious();
    widget.onItem!(item);
  }
}

class _AddAddressOption extends StatelessWidget {
  final String label;
  final Function() onTap;

  const _AddAddressOption({required this.onTap, this.label = ''});

  @override
  Widget build(BuildContext context) {
    var style = TextStyles.text14_600.copyWith(color: lightBlue, height: 1);
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
        decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(08)),
        child: Row(
          children: [
            SvgImage(image: Assets.svg1.plus, height: 17, color: white),
            const SizedBox(width: 12),
            Expanded(child: Text(label.recast, maxLines: 1, textAlign: TextAlign.start, overflow: TextOverflow.ellipsis, style: style)),
            const SizedBox(width: 12),
            SvgImage(image: Assets.svg1.arrow_right, height: 17, color: white),
          ],
        ),
      ),
    );
  }
}

/*Widget get _noAddressFound {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgImage(image: Assets.svg3.no_address, height: 34.width, color: primary),
          const SizedBox(height: 24),
          Text('no_address_found'.recast, textAlign: TextAlign.center, style: TextStyles.text16_600.copyWith(color: primary)),
          const SizedBox(height: 02),
          Text(
            'no_address_available_now_please_add_your_address_and_try_again'.recast,
            textAlign: TextAlign.center,
            style: TextStyles.text14_400.copyWith(color: primary),
          ),
          SizedBox(height: 12.height),
        ],
      ),
    );
  }*/
