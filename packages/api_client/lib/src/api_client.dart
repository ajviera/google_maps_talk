import 'package:api_client/api_client.dart';

/// {@template api_client}
/// A client to communicate with google_maps_talk backend
/// {@endtemplate}
class ApiClient {
  /// {@macro api_client}
  ApiClient({
    required GoogleMapsApiClient client,
  }) : _client = client;

  final GoogleMapsApiClient _client;

  /// {@macro location_resource}
  LocationResource get locationResource {
    return LocationResource(
      client: _client,
    );
  }
}
