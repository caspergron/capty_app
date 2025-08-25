import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/models/common/tag.dart';
import 'package:app/preferences/user_preferences.dart';

class MarketplaceHelper {
  String generateMarketplaceApiParams(Tag tag, int pageNumber, String locationParams, String filterParams) {
    if (tag.id == null) {
      return '&page=$pageNumber$locationParams$filterParams'.trim();
    } else if (tag.name.toKey == 'country'.toKey) {
      var countryId = UserPreferences.user.countryId;
      return '&page=$pageNumber&sort_by=${tag.name.toKey}&country_id=$countryId$locationParams$filterParams'.trim();
    } else if (tag.name?.toKey == 'all'.toKey) {
      return '&page=$pageNumber$locationParams$filterParams'.trim();
    } else if (tag.name.toKey == 'club'.toKey || tag.name.toKey == 'tournament'.toKey) {
      return '&page=$pageNumber&sort_by=${tag.name.toKey}$locationParams$filterParams'.trim();
    } else if (tag.name.toKey == 'distance'.toKey) {
      return '&page=$pageNumber&sort_by=${tag.name.toKey}&distance=${tag.value.nullToInt}$locationParams$filterParams'.trim();
    } else {
      return '&page=$pageNumber$locationParams$filterParams'.trim();
    }
  }
}
