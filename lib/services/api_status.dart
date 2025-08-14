class ApiStatus {
  ApiStatus._();
  static final instance = ApiStatus._();

  bool landing = false;
  bool home = false;
  bool club = false;
  bool discs = false;
  bool marketplace = false;
  bool profile = false;
  bool notification = false;
  bool betaPopup = false;
  bool releasePopup = false;

  void clearStates() {
    landing = false;
    home = false;
    club = false;
    discs = false;
    marketplace = false;
    profile = false;
    notification = false;
    betaPopup = false;
  }
}
