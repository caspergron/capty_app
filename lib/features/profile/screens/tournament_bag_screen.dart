import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:app/components/loaders/screen_loader.dart';
import 'package:app/components/menus/back_menu.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/profile/units/tournament_disc_list.dart';
import 'package:app/features/profile/view_models/tournament_discs_view_model.dart';
import 'package:app/models/user/user.dart';
import 'package:app/themes/gradients.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/exception/no_disc_found.dart';

class TournamentBagScreen extends StatefulWidget {
  final User? player;
  const TournamentBagScreen({this.player});

  @override
  State<TournamentBagScreen> createState() => _TournamentBagScreenState();
}

class _TournamentBagScreenState extends State<TournamentBagScreen> {
  var _viewModel = TournamentDiscsViewModel();
  var _modelData = TournamentDiscsViewModel();

  @override
  void initState() {
    // sl<AppAnalytics>().screenView('tournament-discs-screen');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _viewModel.initViewModel(widget.player));
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _viewModel = Provider.of<TournamentDiscsViewModel>(context, listen: false);
    _modelData = Provider.of<TournamentDiscsViewModel>(context);
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
        title: Text('tournament_discs'.recast),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        width: SizeConfig.width,
        height: SizeConfig.height,
        decoration: BoxDecoration(gradient: BACKGROUND_GRADIENT),
        child: Stack(children: [_screenView, if (_modelData.loader.loader) const ScreenLoader()]),
      ),
    );
  }

  Widget get _screenView {
    if (_modelData.loader.initial) return const SizedBox.shrink();
    var description = widget.player == null
        ? 'you_have_no_disc_in_your_tournament_bag_please_add_your_disc'
        : 'this_player_has_no_disc_in_the_tournament_bag';
    if (_modelData.discs.isEmpty) return NoDiscFound(height: 10.height, description: description);
    return TournamentDiscList(discs: _modelData.discs);
    // onItem: (item, index) => _viewModel.onDiscItem(item, index),
  }
}
