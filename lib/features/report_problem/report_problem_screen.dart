import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/components/loaders/screen_loader.dart';
import 'package:app/components/menus/back_menu.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/report_problem/report_problem_view_model.dart';
import 'package:app/libraries/flush_popup.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/gradients.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/core/input_field.dart';
import 'package:app/widgets/ui/character_counter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReportProblemScreen extends StatefulWidget {
  @override
  State<ReportProblemScreen> createState() => _ReportProblemScreenState();
}

class _ReportProblemScreenState extends State<ReportProblemScreen> {
  var _viewModel = ReportProblemViewModel();
  var _modelData = ReportProblemViewModel();
  var _title = TextEditingController();
  var _description = TextEditingController();
  var _focusNodes = [FocusNode(), FocusNode()];

  @override
  void initState() {
    // sl<AppAnalytics>().screenView('report-problem-screen');
    _focusNodes.forEach((item) => item.addListener(() => setState(() {})));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _viewModel.initViewModel());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _viewModel = Provider.of<ReportProblemViewModel>(context, listen: false);
    _modelData = Provider.of<ReportProblemViewModel>(context);
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
        title: Text('report_a_problem'.recast),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        width: SizeConfig.width,
        height: SizeConfig.height,
        decoration: BoxDecoration(gradient: BACKGROUND_GRADIENT),
        child: Stack(children: [_screenView(context), if (_modelData.loader) const ScreenLoader()]),
      ),
    );
  }

  Widget _screenView(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      clipBehavior: Clip.antiAlias,
      padding: EdgeInsets.symmetric(horizontal: Dimensions.screen_padding),
      physics: const BouncingScrollPhysics(),
      children: [
        const SizedBox(height: 16),
        Text('report_title'.recast, style: TextStyles.text14_600.copyWith(color: primary)),
        const SizedBox(height: 06),
        InputField(
          controller: _title,
          focusNode: _focusNodes.first,
          hintText: 'type_here'.recast,
          textCapitalization: TextCapitalization.sentences,
          borderRadius: BorderRadius.circular(06),
          focusedBorder: primary.colorOpacity(0.6),
          enabledBorder: lightBlue,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (value) => FocusScope.of(context).requestFocus(_focusNodes.last),
        ),
        const SizedBox(height: 12),
        Text('report_description'.recast, style: TextStyles.text14_600.copyWith(color: primary)),
        const SizedBox(height: 06),
        InputField(
          minLines: 06,
          maxLines: 12,
          counterText: '',
          maxLength: 150,
          controller: _description,
          hintText: 'write_your_description_here'.recast,
          focusNode: _focusNodes.last,
          enabledBorder: lightBlue,
          focusedBorder: primary.colorOpacity(0.6),
          onChanged: (v) => setState(() {}),
          borderRadius: BorderRadius.circular(06),
        ),
        if (_description.text.isNotEmpty) const SizedBox(height: 06),
        if (_description.text.isNotEmpty) CharacterCounter(count: _description.text.length, total: 150, color: primary),
        const SizedBox(height: 20),
        ElevateButton(
          radius: 04,
          height: 42,
          width: double.infinity,
          onTap: _onReportProblem,
          label: 'send_report'.recast.toUpper,
          textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
          // onTap: () => Routes.user.club_settings(club: Provider.of<ClubViewModel>(context, listen: false).club).push(),
        ),
        SizedBox(height: BOTTOM_GAP),
      ],
    );
  }

  void _clearStates() {
    _description.clear();
    _title.clear();
    setState(() {});
  }

  Future<void> _onReportProblem() async {
    if (_title.text.isEmpty) return FlushPopup.onWarning(message: 'please_write_the_title_of_report'.recast);
    if (_description.text.isEmpty) return FlushPopup.onWarning(message: 'please_write_the_description_of_report'.recast);
    var response = await _viewModel.onSendReport(title: _title.text, description: _description.text);
    if (response) _clearStates();
  }
}
