import 'package:app/utils/size_config.dart';

extension NumberExt on num {
  double get height => this * (SizeConfig.height / 100);
  double get width => this * (SizeConfig.width / 100);
  double get _min_size => SizeConfig.isPortrait ? SizeConfig.width : SizeConfig.height;
  double get sp => this * ((_min_size / 3) / 100);
  double get widthRatio => this * (_min_size / 100);
}

extension ParseNullableInt on int? {
  int get nullToInt => this ?? 0;
  double get parseDouble => this == null ? 0 : this!.toDouble();
  double get intToDouble => this == null ? 0 : this!.toDouble();
  String get formatInt => this == null ? '0' : (this! < 9 ? '0$this' : '$this');
}

extension ParseNullableDouble on double? {
  String get formatDouble => this == null ? '0' : (this == this!.toInt() ? this!.toInt().toString() : this!.toStringAsFixed(1));
}
