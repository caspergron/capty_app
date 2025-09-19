import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:device_marketing_names/device_marketing_names.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DeviceInfo {
  final _deviceInfo = DeviceInfoPlugin();
  final _marketingNames = DeviceMarketingNames();

  Future<String> get deviceId => FlutterUdid.consistentUdid;
  String get deviceOsVersion => Platform.operatingSystemVersion;
  Future<String> get deviceName => _marketingNames.getSingleName();
  Future<PackageInfo> get getPackageInfo => PackageInfo.fromPlatform();

  Future<String> get appVersion async {
    final packageInfo = await getPackageInfo;
    return packageInfo.version;
  }

  Future<String> get appBuildVersionCode async {
    final packageInfo = await getPackageInfo;
    return packageInfo.buildNumber;
  }

  Future<String> get deviceVersion async {
    if (Platform.isIOS) {
      final iosInfo = await _deviceInfo.iosInfo;
      return iosInfo.systemVersion;
    } else if (Platform.isAndroid) {
      final androidInfo = await _deviceInfo.androidInfo;
      // return androidInfo.model;
      return androidInfo.type;
    } else {
      return 'Unknown Platform';
    }
  }

  String get getOsType {
    if (Platform.isIOS) {
      return 'ios';
    } else if (Platform.isAndroid) {
      return 'android';
    } else if (Platform.isMacOS) {
      return 'mac';
    } else if (Platform.isFuchsia) {
      return 'fuchsia';
    } else if (Platform.isLinux) {
      return 'linux';
    } else if (Platform.isWindows) {
      return 'windows';
    } else {
      return 'ios';
    }
  }

  Future<String> get deviceIpAddress async {
    String ipAddress = '';
    for (final interface in await NetworkInterface.list()) {
      for (final address in interface.addresses) {
        ipAddress = address.address;
      }
    }
    return ipAddress;
  }

/*Future<IosDeviceInfo> getIOSInfo() => _deviceInfo.iosInfo;
  Future<AndroidDeviceInfo> getAndroidInfo() => _deviceInfo.androidInfo;
  Future<MacOsDeviceInfo> getMacOsInfo() => _deviceInfo.macOsInfo;
  Future<WindowsDeviceInfo> getWindowsInfo() => _deviceInfo.windowsInfo;
  Future<LinuxDeviceInfo> getLinuxInfo() => _deviceInfo.linuxInfo;
  Future<WebBrowserInfo> getWebBrowserInfo() => _deviceInfo.webBrowserInfo;*/
}
