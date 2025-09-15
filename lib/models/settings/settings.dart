class Settings {
  int? enableNotification;
  int? tournamentNotification;
  int? clubNotification;
  int? clubEventNotification;
  int? enableLocation;
  dynamic timezone;
  // Currency? currency;
  dynamic measurementUnit;

  bool get enable_notification => enableNotification != null && enableNotification == 1;
  // bool get enable_background => enableAppRunningBackground != null && enableAppRunningBackground == 1;
  bool get tournament_notification => tournamentNotification != null && tournamentNotification == 1;
  bool get club_notification => clubNotification != null && clubNotification == 1;
  bool get club_event_notification => clubEventNotification != null && clubEventNotification == 1;

  bool get enable_location => enableLocation != null && enableLocation == 1;

  Settings({
    this.enableNotification,
    this.tournamentNotification,
    this.clubNotification,
    this.clubEventNotification,
    this.enableLocation,
    this.timezone,
    /*this.currency,*/
    this.measurementUnit,
  });

  Settings.fromJson(json) {
    enableNotification = json['enable_notifications'];
    tournamentNotification = json['enable_tournament_notification'];
    clubNotification = json['enable_club_notification'];
    clubEventNotification = json['enable_club_event_notification'];
    enableLocation = json['enable_location_tracking'];
    timezone = json['timezone'];
    /*currencyId = json['currency_id'];
    currency = json['currency'] != null ? Currency.fromJson(json['currency']) : null;*/
    measurementUnit = json['measurement_unit'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['enable_notifications'] = enableNotification;
    map['enable_tournament_notification'] = tournamentNotification;
    map['enable_club_notification'] = clubNotification;
    map['enable_club_event_notification'] = clubEventNotification;
    map['enable_location_tracking'] = enableLocation;
    map['timezone'] = timezone;
    // map['currency_id'] = currencyId;
    // if (currency != null) map['currency'] = currency?.toJson();
    map['measurement_unit'] = measurementUnit;
    return map;
  }
}
