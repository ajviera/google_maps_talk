import 'dart:io';

import 'package:google_maps_talk/main/main.dart';
import 'package:google_maps_talk/main/main_common.dart';

void main() {
  bootstrap(
    () {
      const apiUrl = 'https://routes.googleapis.com';

      final apiKey = Platform.isAndroid
          ? const String.fromEnvironment('GOOGLE_MAPS_ANDROID_API_KEY')
          : const String.fromEnvironment('GOOGLE_MAPS_IOS_API_KEY');

      return mainCommon(apiUrl: apiUrl, apiKey: apiKey);
    },
  );
}
