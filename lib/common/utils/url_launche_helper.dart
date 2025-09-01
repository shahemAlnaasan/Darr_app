import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLaucncheHelper {
  static Future<void> openStorePage({required bool isAndroid}) async {
    final Uri url = Uri.parse(
      isAndroid
          ? 'https://play.google.com/store/apps/details?id=com.google.android.apps.authenticator2'
          : 'https://apps.apple.com/app/google-authenticator/id388497605',
    );

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not open $url';
    }
  }

  static Future<void> launchWhatsApp(String phoneNumber) async {
    var androidUrl = "whatsapp://send?phone=$phoneNumber";
    var iosUrl = "https://wa.me/$phoneNumber";

    try {
      if (Platform.isIOS) {
        await launchUrl(Uri.parse(iosUrl));
      } else {
        await launchUrl(Uri.parse(androidUrl));
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<void> launchWebUrl(String url) async {
    final Uri uri = Uri.parse(url.startsWith("http") ? url : "https://$url");

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      return;
    }
  }
}
