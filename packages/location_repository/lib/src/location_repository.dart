import 'dart:core';
import 'dart:developer';

import 'package:api_client/api_client.dart';
import 'package:location_repository/location_repository.dart';
import 'package:location_repository/src/models/route.dart';

/// {@template geolocator_wrapper}
/// Wrapper for the Geolocator package.
/// {@endtemplate}
class GeolocatorWrapper {
  /// Returns the current position of the device.
  Future<Position> getCurrentPosition(LocationAccuracy accuracy) async {
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: accuracy,
        timeLimit: const Duration(seconds: 10),
      );
    } catch (e) {
      throw LocationTimeOutException(
        message: 'Error getting location: $e',
      );
    }
  }

  /// Returns the distance between two coordinates.
  Future<double> getDistanceBetween(
    Position startingPosition,
    Position endingPosition,
  ) async {
    return Geolocator.distanceBetween(
      startingPosition.latitude,
      startingPosition.longitude,
      endingPosition.latitude,
      endingPosition.longitude,
    );
  }

  /// Returns a [Stream] of the current position of the device.
  Stream<Position> getPositionStream({
    LocationSettings? locationSettings,
  }) {
    return Geolocator.getPositionStream(
      locationSettings: locationSettings,
    );
  }

  /// Returns a [Future] indicating if the user allows the app to access the
  /// location.
  Future<LocationPermission> checkPermission() async {
    return Geolocator.checkPermission();
  }

  /// Requests the user's permission to access the location.
  Future<LocationPermission> requestPermission() async {
    return Geolocator.requestPermission();
  }

  /// Returns a [Future] containing a [bool] value indicating whether location
  /// services are enabled on the device.
  Future<bool> isLocationServiceEnabled() async {
    return Geolocator.isLocationServiceEnabled();
  }

  /// Opens the App settings page.
  /// Returns `true` if the location settings page could be opened, otherwise
  /// `false` is returned.
  Future<bool> openAppSettings() async {
    return Geolocator.openAppSettings();
  }
}

/// {@template location_repository}
/// Repository for handling location data.
/// {@endtemplate}
class LocationRepository {
  /// {@macro location_repository}
  LocationRepository({
    required ApiClient apiClient,
    GeolocatorWrapper? geolocator,
  })  : _apiClient = apiClient,
        _geolocator = geolocator ?? GeolocatorWrapper() {
    _initLocationInfo();
  }

  final ApiClient _apiClient;

  final GeolocatorWrapper _geolocator;

  /// Stream for getting the current position and current speed
  late final Stream<Position> positionStream;

  /// Stream for getting the current speed
  Stream<double> get speedStream =>
      positionStream.map((position) => position.speed);

  /// Stream for getting the current coordinates
  Stream<Coordinates> get coordinatesStream => positionStream.map(
        (position) => Coordinates(
          latitude: position.latitude,
          longitude: position.longitude,
        ),
      );

  /// Initializes coordinates for the current position and speed
  Future<void> _initLocationInfo() async {
    try {
      final currentPermission = await _geolocator.checkPermission();
      if (currentPermission == LocationPermission.denied ||
          currentPermission == LocationPermission.deniedForever ||
          currentPermission == LocationPermission.unableToDetermine) {
        await _geolocator.requestPermission();
      }
      positionStream = _geolocator
          .getPositionStream(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.high,
              distanceFilter: 30,
            ),
          )
          .asBroadcastStream();
    } catch (error) {
      positionStream = const Stream.empty();
      log('[Diagnostics | _initLocationInfo]: $error');
    }
  }

  /// Determine the current location of the device.
  ///
  /// {@macro request_permission}
  Future<Position> getLocation() async {
    await requestPermission();
    try {
      return _geolocator.getCurrentPosition(
        LocationAccuracy.bestForNavigation,
      );
    } catch (e) {
      throw LocationTimeOutException(
        message: 'Error getting location: $e',
      );
    }
  }

  /// {@template request_permission}
  /// Check if the location permission is granted. If not, request it.
  ///
  /// Throws a [LocationPermissionException] if the permission is denied or
  /// permanently denied.
  /// {@endtemplate}
  Future<void> requestPermission() async {
    LocationPermission permission;
    final serviceEnabled = await _geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw LocationServicesDisabledException(
        message: 'Location services disabled.',
      );
    }

    permission = await _geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      permission = await _geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw LocationPermissionDeniedException(
          message: 'Location service permission denied.',
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw LocationPermissionPermanentDeniedException(
        message: 'Location service permission denied forever.',
      );
    }
  }

  /// Open the location settings on the device. Returns `true` if the location
  /// settings page is opened. Otherwise, returns `false`.
  Future<bool> openLocationSettings() async {
    return _geolocator.openAppSettings();
  }

  /// Calculate the distance between two coordinates.
  Future<double> calculateDistanceBetween({
    required Position startingPosition,
    required Position endingPosition,
  }) async {
    return _geolocator.getDistanceBetween(startingPosition, endingPosition);
  }

  /// Calculate the eta between two coordinates.
  /// Throws a [LocationTimeOutException] if the location service times out.
  Future<Map<String, dynamic>> calculateRoute({
    required double startingLatitude,
    required double startingLongitude,
    required double endingLatitude,
    required double endingLongitude,
  }) async {
    final response = await _apiClient.locationResource.fetchRoutes(
      originLatitude: startingLatitude.toString(),
      originLongitude: startingLongitude.toString(),
      destinationLatitude: endingLatitude.toString(),
      destinationLongitude: endingLongitude.toString(),
    );

    if (response.isNotEmpty) {
      final listOfRoutes = response['routes'] as List<dynamic>;

      final routes = listOfRoutes
          .map((route) => Route.fromJson(route as Map<String, dynamic>))
          .toList();
      final map = {
        'distanceMeters': routes.first.distanceMeters,
        'duration': routes.first.duration,
      };
      return map;
    } else {
      return {};
    }
  }
}
