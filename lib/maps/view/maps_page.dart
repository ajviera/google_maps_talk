import 'package:flutter/material.dart';
import 'package:maps_examples/maps_examples.dart';

class MapsPage extends Page<void> {
  const MapsPage({this.latitude = 0.0, this.longitude = 0.0});
  static const path = '/maps/:latitude/:longitude';
  static const pageName = 'maps-page';

  final double latitude;
  final double longitude;

  @override
  Route<void> createRoute(BuildContext context) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      settings: this,
      builder: (_) {
        return MapsView(latitude: latitude, longitude: longitude);
      },
    );
  }
}
