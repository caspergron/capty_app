import 'package:app/constants/app_keys.dart';
import 'package:app/models/system/dimension.dart';
import 'package:app/utils/size_config.dart';

class DimensionHelper {
  double dimensionSizer(Dimension dimension) {
    var context = navigatorKey.currentState?.context;
    if (context == null) return dimension.mobile;
    var screenWidth = SizeConfig.width;
    if (screenWidth < 1) return dimension.mobile;
    if (screenWidth <= 375) {
      return dimension.small ?? dimension.small ?? dimension.mobile;
    } else if (screenWidth > 375 && screenWidth < 601) {
      return dimension.mobile;
    } else if (screenWidth >= 601 && screenWidth < 1024) {
      return dimension.tab ?? dimension.mobile;
    } else {
      return dimension.tab ?? dimension.mobile;
    }
  }
}
