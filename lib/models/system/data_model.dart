import 'package:app/extensions/string_ext.dart';
import 'package:app/utils/assets.dart';

class DataModel {
  String label;
  String value;
  int valueInt;
  String icon;

  DataModel({this.label = '', this.value = '', this.valueInt = 0, this.icon = ''});

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['label'] = label;
    map['value'] = value;
    map['valueInt'] = valueInt;
    map['icon'] = icon;
    return map;
  }

  static DataModel handPreference(String value) {
    var index = HANDS_LIST.indexWhere((item) => item.value.toKey == value.toKey);
    return index < 0 ? HANDS_LIST.first : HANDS_LIST[index];
  }
}

List<DataModel> BOTTOM_NAV_ITEMS = [
  DataModel(label: 'home', icon: Assets.svg2.home, value: Assets.svg2.home),
  DataModel(label: 'club', icon: Assets.svg1.coach, value: Assets.svg1.coach),
  DataModel(icon: Assets.svg1.plus, value: Assets.svg1.plus),
  DataModel(label: 'discs', icon: Assets.svg1.disc_1, value: Assets.svg1.disc_1),
  DataModel(label: 'marketplace', icon: Assets.svg2.marketplace, value: Assets.svg2.marketplace),
];

List<DataModel> SPINNER_MENU_ITEMS = [
  DataModel(label: 'create_a_disc_newline_sales_ad', value: 'add_a_disc', icon: Assets.svg2.marketplace, valueInt: 1),
  DataModel(label: 'add_a_friend', value: 'add_a_friend', icon: Assets.svg1.coach_plus, valueInt: 2),
  DataModel(label: 'add_a_disc_newline_to_your_bag', value: 'start_a_round', icon: Assets.svg1.disc_plus, valueInt: 3),
];

var CAMERA = DataModel(label: 'take_a_photo', icon: Assets.svg1.camera, value: 'camera');
var GALLERY = DataModel(label: 'upload_from_gallery', icon: Assets.svg1.image_square, value: 'gallery');

var SHARE = DataModel(label: 'share', value: 'share');
var DELETE = DataModel(label: 'delete', value: 'delete');
List<DataModel> RECORD_MENU_LIST = [SHARE, DELETE];

List<DataModel> HANDS_LIST = [DataModel(label: 'Left', value: 'left'), DataModel(label: 'Right', value: 'right')];

List<DataModel> INTRODUCTION_LIST = [
  DataModel(icon: Assets.svg3.training, label: 'compete', value: 'onboarding_1'),
  DataModel(icon: Assets.svg3.circle_putting, label: 'compare', value: 'onboarding_2'),
  DataModel(icon: Assets.svg3.pgda_rating_2, label: 'connect', value: 'onboarding_3'),
];

List<DataModel> CHAT_SUGGESTIONS = [
  DataModel(label: 'Is this disc still for sale?', value: 'Is this disc still for sale?'),
  DataModel(label: 'Do you offer shipping?', value: 'Do you offer shipping?'),
  DataModel(label: 'Can you bring it for the next tournament?', value: 'Can you bring it for the next tournament?'),
  DataModel(label: 'Can you give me a price for 2 discs?', value: 'Can you give me a price for 2 discs?'),
];

List<DataModel> SORT_BY_LIST = [
  DataModel(label: 'newest', value: 'newest'),
  // DataModel( label: 'distance', value: 'distance'),
  DataModel(label: 'popularity', value: 'popularity'),
];

List<DataModel> LEADERBOARD_CATEGORY_LIST = [
  DataModel(label: 'pdga_rating', value: 'rating'),
  DataModel(label: 'pdga_improvement', value: 'improvement'),
  DataModel(label: 'yearly_improvement', value: 'yearly_improvement'),
];
