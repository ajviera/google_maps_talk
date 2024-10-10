import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_talk_ui/google_maps_talk_ui.dart';

/// Icons to be used with dark theme.
class UIIconsDark extends UIIcon {
  @override
  SvgPicture backIcon({double? size, Color? color}) {
    return super.backIcon(
      color: color ?? UIColors.white,
      size: size ?? 14,
    );
  }

  @override
  SvgPicture emailOutline({double? size, Color? color}) {
    return super.emailOutline(
      color: color ?? UIColors.white,
      size: size ?? 14,
    );
  }
}
