import 'package:permission_handler/permission_handler.dart';

class Permissions {
  Future<bool> getLocationPermission() async {
    // print('1');
    var status = await Permission.location.status;
    // print('2');
    // print(status);
    if (status.isGranted) return true;
    // print('3');
    var result = await Permission.location.request();
    // print('4');
    return result.isGranted;
  }
}
