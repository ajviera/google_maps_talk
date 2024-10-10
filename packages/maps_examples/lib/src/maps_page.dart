// DISCLAIMER: This is a modified version of the original code
// from the Google Maps Flutter plugin.
// This example demonstrates how to use the Google Maps Navigation SDK plugin
// The use of this example is for educational purposes only.

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_navigation_flutter/google_navigation_flutter.dart';
import 'package:maps_examples/src/pages/markers.dart';
import 'package:maps_examples/src/pages/pages.dart';
import 'package:maps_examples/src/widgets/page.dart';
import 'package:permission_handler/permission_handler.dart';

class MapsView extends StatefulWidget {
  const MapsView({
    required this.longitude,
    required this.latitude,
    super.key,
  });
  final double longitude;
  final double latitude;

  @override
  State<StatefulWidget> createState() => __MapsViewState();
}

class __MapsViewState extends State<MapsView> {
  __MapsViewState();

  /// The list of pages to show in the Google Maps Navigation demo.
  List<ExamplePage> _allPages = <ExamplePage>[];

  bool _locationPermitted = false;
  bool _notificationsPermitted = false;
  String _navSDKVersion = '';

  @override
  void initState() {
    _loadPages();
    _requestPermissions();
    unawaited(_checkSDKVersion());
    super.initState();
  }

  void _loadPages() {
    _allPages = <ExamplePage>[
      const NavigationPage(),
      MapPage(latitude: widget.latitude, longitude: widget.longitude),
      MarkersPage(latitude: widget.latitude, longitude: widget.longitude),
      const WidgetInitializationPage(),
    ];
    setState(() {});
  }

  Future<void> _checkSDKVersion() async {
    // Get the Navigation SDK version.
    _navSDKVersion = await GoogleMapsNavigator.getNavSDKVersion();
  }

  Future<void> _pushPage(BuildContext context, ExamplePage page) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => page,
      ),
    );
  }

  /// Request permission for accessing the device's location and notifications.
  ///
  /// Android: Fine and Coarse Location
  /// iOS: CoreLocation (Always and WhenInUse), Notification
  Future<void> _requestPermissions() async {
    final locationPermission = await Permission.location.request();

    var notificationPermission = PermissionStatus.denied;
    if (Platform.isIOS) {
      notificationPermission = await Permission.notification.request();
    }
    setState(() {
      _locationPermitted = locationPermission == PermissionStatus.granted;
      _notificationsPermitted =
          notificationPermission == PermissionStatus.granted;
    });
  }

  @override
  Widget build(BuildContext context) {
    final permissionStatus =
        'Location ${_locationPermitted ? 'granted' : 'denied'}';

    final permissionNotificationStatus =
        'Notifications ${_notificationsPermitted ? 'granted' : 'denied'}';

    final locationPermissionText = Platform.isIOS
        ? 'Location $permissionStatus • '
            'Notifications $permissionNotificationStatus'
        : 'Location $permissionStatus ';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Navigation Flutter examples'),
        leading: BackButton(
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        top: false,
        minimum: const EdgeInsets.all(8),
        child: _allPages.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: _allPages.length + 1,
                itemBuilder: (_, int index) {
                  if (index == 0) {
                    return Card(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        alignment: Alignment.center,
                        child: Column(
                          children: <Widget>[
                            Text(locationPermissionText),
                            Text('Navigation SDK version: $_navSDKVersion'),
                          ],
                        ),
                      ),
                    );
                  }
                  return ListTile(
                    leading: _allPages[index - 1].leading,
                    title: Text(_allPages[index - 1].title),
                    onTap: () => _pushPage(context, _allPages[index - 1]),
                  );
                },
              ),
      ),
    );
  }
}
