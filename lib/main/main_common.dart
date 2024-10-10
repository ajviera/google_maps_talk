import 'package:api_client/api_client.dart';
import 'package:google_maps_talk/app/app.dart';
import 'package:location_repository/location_repository.dart';

Future<App> mainCommon({
  required String apiUrl,
  required String apiKey,
}) async {
  final client = GoogleMapsApiClient(apiUrl: apiUrl, apiKey: apiKey);
  final apiClient = ApiClient(client: client);
  final locationRepository = LocationRepository(apiClient: apiClient);

  return App(
    locationRepository: locationRepository,
  );
}
