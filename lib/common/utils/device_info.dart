import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class DeviceInfo {
  static Future<String> deviceType() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
      return androidInfo.model;
    }

    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
      return iosInfo.model;
    }

    if (Platform.isWindows) {
      WebBrowserInfo webBrowserInfo = await deviceInfoPlugin.webBrowserInfo;
      return webBrowserInfo.browserName.name;
    }

    if (Platform.isMacOS) return 'macOS';
    if (Platform.isLinux) return 'Linux';
    return "unknown";
  }

  static Future<String?> getDeviceIp() async {
    try {
      final response = await http.get(Uri.parse('https://api.ipify.org'));
      if (response.statusCode == 200) {
        return response.body;
      }
    } catch (_) {
      return null;
    }
    return null;
  }
}
