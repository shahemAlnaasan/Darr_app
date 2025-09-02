import 'dart:io';

import 'package:dio/dio.dart';
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

class MapsLinkHelper {
  static final Dio _dio = Dio(
    BaseOptions(
      followRedirects: false, // don't auto-follow, so we can read headers
      validateStatus: (status) => status != null && status < 400,
    ),
  );

  static Future<String> normalizeGoogleMapsLink(String shortUrl) async {
    try {
      final response = await _dio.get(shortUrl);

      final resolvedUrl = response.headers['location']?.first ?? response.realUri.toString();

      final regex = RegExp(r'@(-?\d+\.\d+),(-?\d+\.\d+)');
      final match = regex.firstMatch(resolvedUrl);

      if (match != null) {
        final lat = match.group(1);
        final lng = match.group(2);
        return "https://www.google.com/maps/search/?api=1&query=$lat,$lng";
      }

      final placeIdRegex = RegExp(r'placeid=([^&]+)');
      final placeMatch = placeIdRegex.firstMatch(resolvedUrl);
      if (placeMatch != null) {
        final placeId = placeMatch.group(1);
        return "https://www.google.com/maps/search/?api=1&query=place_id:$placeId";
      }

      return resolvedUrl;
    } catch (e) {
      return shortUrl;
    }
  }
}
