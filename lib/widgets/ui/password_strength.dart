import 'package:flutter/material.dart';

import 'package:app/di.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/reg_exps.dart';

class PasswordStrength extends StatelessWidget {
  final String password;
  const PasswordStrength({required this.password});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('password_strength'.recast, style: TextStyles.text12_700.copyWith(color: dark)),
        const SizedBox(width: 4),
        SizedBox(
          height: 2,
          child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            clipBehavior: Clip.antiAlias,
            scrollDirection: Axis.horizontal,
            itemCount: _strength_list.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => _strengthCard(context, _strength_list[index]),
          ),
        ),
      ],
    );
  }

  Widget _strengthCard(BuildContext context, bool status) {
    var margin = const EdgeInsets.only(right: 4);
    var color = status ? success : grey;
    var radius = BorderRadius.circular(2);
    return Container(height: 2, width: 20, margin: margin, decoration: BoxDecoration(color: color, borderRadius: radius));
  }

  List<bool> get _strength_list {
    var uppercase = password.contains(sl<RegExps>().uppercase);
    var lowercase = password.contains(sl<RegExps>().lowercase);
    var specialCharacter = password.contains(sl<RegExps>().specialCharacter);
    var numberAndPasswordLength = password.contains(sl<RegExps>().number) && password.length >= 6;
    var statusList = [uppercase, lowercase, specialCharacter, numberAndPasswordLength];
    statusList.sort((strengthA, strengthB) => strengthB ? 1 : -1);
    return statusList;
  }
}
