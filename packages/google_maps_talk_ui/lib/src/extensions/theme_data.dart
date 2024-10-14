import 'package:flutter/material.dart';
import 'package:google_maps_talk_ui/google_maps_talk_ui.dart';

///Extension on Themedata that must be added to return the correct asset
extension ThemeX on ThemeData {
  ///Returns the correct UIIcon based on the current theme
  UIIcon get icons {
    final isDarkMode = brightness == Brightness.dark;
    if (isDarkMode) {
      return UIIconsDark();
    } else {
      return  UIIconsLight();
    }
  }
}
