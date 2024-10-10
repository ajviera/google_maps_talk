import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_talk_ui/google_maps_talk_ui.dart';

class TestUIIcon extends UIIcon {}

void main() {
  group('UIIcons Tests', () {
    test('Test Back icon', () {
      final appIcons = TestUIIcon();
      final svgPicture = appIcons.backIcon();

      expect(svgPicture, isA<SvgPicture>());
    });

    test('Test email logo icon', () {
      final appIcons = TestUIIcon();
      final svgPicture = appIcons.emailOutline();

      expect(svgPicture, isA<SvgPicture>());
    });
  });
}
