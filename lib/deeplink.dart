class Deeplink {
  /*DeeplinkType executeDeeplinkRoute() {
    final deeplink = _getDeeplinkType();
    sl<LocalStorage>().removeData(key: DEEPLINK);
    if (deeplink == DeeplinkType.none) return DeeplinkType.none;
    final authStatus = sl<AuthService>().authStatus;
    final trackingId = sl<StorageService>().orderTrackingId;
    if (deeplink == DeeplinkType.invitation) {
      mixingInvitationDialog();
      return DeeplinkType.invitation;
    } else if (deeplink == DeeplinkType.coupon) {
      giftCouponDialog();
      return DeeplinkType.coupon;
    } else if (authStatus && deeplink == DeeplinkType.payment && trackingId != null) {
      sl<Routes>().thank_you(order: Order()).pushAndRemoveUntil();
      return DeeplinkType.payment;
    } else {
      return DeeplinkType.none;
    }
  }*/

  /*DeeplinkType _getDeeplinkType() {
    final deeplink = sl<StorageService>().deeplink;
    if (deeplink == null || deeplink.isEmpty) return DeeplinkType.none;
    Uri uri = Uri.parse(deeplink);
    List<String> segments = uri.pathSegments;
    if (segments.isEmpty) return DeeplinkType.none;
    final path = segments.last.toKey;
    if (path.contains('InvitedBag'.toKey)) {
      return DeeplinkType.invitation;
    } else if (path.contains('GiftCoupon'.toKey)) {
      return DeeplinkType.coupon;
    } else if (path.contains('payment'.toKey)) {
      return DeeplinkType.payment;
    } else {
      return DeeplinkType.none;
    }
  }*/
}
