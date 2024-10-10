import 'dart:convert';
import 'dart:developer';

import 'package:api_client/api_client.dart';

/// {@template location_resource}
/// A client for the location resource.
/// {@endtemplate}
class LocationResource {
  /// {@macro location_resource}
  LocationResource({
    required GoogleMapsApiClient client,
  }) : _client = client;

  final GoogleMapsApiClient _client;
  final String _path = '/directions/v2:computeRoutes';

  /// The field mask for the response.
  static const kFieldMask =
      'routes.duration,routes.distanceMeters,routes.polyline.encodedPolyline';

  /// Fetch the facilities.
  ///
  /// Throws a [LocationsFetchFailure] if an error occurs.
  Future<Map<String, dynamic>> fetchRoutes({
    required String originLatitude,
    required String originLongitude,
    required String destinationLatitude,
    required String destinationLongitude,
  }) async {
    try {
      final requestBody = <String, dynamic>{
        'origin': {
          'location': {
            'latLng': {
              'latitude': originLatitude,
              'longitude': originLongitude,
            },
          },
        },
        'destination': {
          'location': {
            'latLng': {
              'latitude': destinationLatitude,
              'longitude': destinationLongitude,
            },
          },
        },
        'travelMode': 'DRIVE',
        'routingPreference': 'TRAFFIC_AWARE',
        'computeAlternativeRoutes': false,
        'routeModifiers': {
          'avoidTolls': false,
          'avoidHighways': false,
          'avoidFerries': false,
        },
        'languageCode': 'en-US',
        'units': 'IMPERIAL',
      };

      final response = await _client.getGoogleRoutes(
        _path,
        body: jsonEncode(requestBody),
        options: const ApiRequestOptions(
          headers: {
            'X-Goog-FieldMask': kFieldMask,
          },
        ),
      );

      final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
      if (responseBody.containsKey('error')) {
        _processError(responseBody);
      } else if (responseBody.isEmpty) {
        throw LocationsFetchFailure('No routes found', StackTrace.current);
      }
      return responseBody;
    } catch (e) {
      log('API CLIENT: Error fetching routes', error: e);
      throw LocationsFetchFailure(e.toString(), StackTrace.current);
    }
  }

  void _processError(Map<String, dynamic> responseBody) {
    final error = responseBody['error'] as Map<String, dynamic>;
    final message = error['message'] as String;
    final code = error['code'] as int;
    log('API CLIENT: Error fetching routes: Code: $code', error: message);
    throw LocationsFetchFailure(message, StackTrace.current);
  }
}
