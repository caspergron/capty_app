import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/components/loaders/screen_loader.dart';
import 'package:app/components/menus/back_menu.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/address/utils/address_list.dart';
import 'package:app/features/address/view_models/addresses_view_model.dart';
import 'package:app/models/address/address.dart';
import 'package:app/services/routes.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/gradients.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/library/svg_image.dart';
import 'package:app/widgets/ui/nav_button_box.dart';

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
      bottomNavigationBar: NavButtonBox(
        loader: _modelData.loader.loader,
        childHeight: 42,
        child: _navbarButton(context),
      ),
    );
  }

  Widget _navbarButton(BuildContext context) {
    var style = TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15);
    return ElevateButton(radius: 04, height: 42, label: 'add_new_address'.recast.toUpper, textStyle: style, onTap: _onAddAddress);
  }

  void _onAddAddress() => Routes.user.add_address().push();

  Widget _screenView(BuildContext context) {
    if (_modelData.addresses.isEmpty) return Center(child: _noAddressFound);
    return ListView(
      shrinkWrap: true,
      clipBehavior: Clip.antiAlias,
      padding: EdgeInsets.symmetric(horizontal: Dimensions.screen_padding),
      physics: const BouncingScrollPhysics(),
      children: [
        const SizedBox(height: 16),
        AddressList(
          addressList: _modelData.addresses,
          onItem: (item, index) => widget.onItem == null ? null : _onSelect(item),
          onDelete: (item, index) => _viewModel.deleteAddress(item, index),
          onUpdate: (item, index) => Routes.user.add_address(address: item).push(),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  void _onSelect(Address item) {
    backToPrevious();
    widget.onItem!(item);
  }

  Widget get _noAddressFound {
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
  }
}
