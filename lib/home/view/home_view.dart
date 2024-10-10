import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_talk/app/app.dart';
import 'package:google_maps_talk/app/constants/constants.dart';
import 'package:google_maps_talk/home/home.dart';
import 'package:google_maps_talk/l10n/l10n.dart';
import 'package:google_maps_talk/maps/maps.dart';
import 'package:google_navigation_flutter/google_navigation_flutter.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.appTitle),
      ),
      body: _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final status = state.status;

        if (status.isLoading) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }

        final errorMessage = state.errorMessage;
        if (status.isError) {
          return Center(
            child: Text(
              errorMessage.isEmpty ? context.l10n.unknownError : errorMessage,
            ),
          );
        }

        final latitude = state.latitude;
        final longitude = state.longitude;
        final route = state.route;
        final markers = state.markers;
        final navigationViewController = state.navigationViewController;

        return Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: GoogleMapsNavigationView(
                  onViewCreated: (navigationViewController) =>
                      onViewCreated(navigationViewController, context),
                  onMapLongClicked: (latLng) => addMarkerToMap(
                    context,
                    navigationViewController,
                    latLng: latLng,
                  ),
                  onMapClicked: (latLng) => addMarkerToMap(
                    context,
                    navigationViewController,
                    latLng: latLng,
                  ),
                  initialNavigationUIEnabledPreference:
                      NavigationUIEnabledPreference.disabled,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      latitude: latitude,
                      longitude: longitude,
                    ),
                    zoom: 12,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OutlinedButton(
                    onPressed: () => addMarkerToMap(
                      context,
                      navigationViewController,
                    ),
                    child: Text(context.l10n.add),
                  ),
                  const SizedBox(width: 16),
                  OutlinedButton(
                    onPressed: () async {
                      await navigationViewController?.clearMarkers();
                      if (!context.mounted) return;
                      context.homeBloc.add(const HomeClearMarker());
                    },
                    child: Text(context.l10n.clear),
                  ),
                ],
              ),
              Card(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.12,
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          final endingLatitude =
                              markers.firstOrNull?.options.position.latitude ??
                                  0;
                          final endingLongitude =
                              markers.firstOrNull?.options.position.longitude ??
                                  0;
                          context.homeBloc.add(
                            HomeRouteApiRequest(
                              startingLatitude: latitude,
                              startingLongitude: longitude,
                              endingLatitude: endingLatitude,
                              endingLongitude: endingLongitude,
                            ),
                          );
                        },
                        child: Text(context.l10n.calculateRoute),
                      ),
                      const SizedBox(height: 8),
                      if (status.isRouteLoading) ...[
                        const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      ],
                      if (!status.isRouteLoading) ...[
                        Text(
                          route.isEmpty
                              ? context.l10n.noRoute
                              : route.toString(),
                        ),
                        if (status.isError) ...[
                          Center(child: Text(errorMessage)),
                        ],
                        const SizedBox(height: 8),
                      ],
                    ],
                  ),
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  final destinationLatitude =
                      markers.firstOrNull?.options.position.latitude ?? 0;
                  final destinationLongitude =
                      markers.firstOrNull?.options.position.longitude ?? 0;
                  MapsSheet.show(
                    context,
                    startingLatitude: latitude,
                    startingLongitude: longitude,
                    destinationLatitude: destinationLatitude,
                    destinationLongitude: destinationLongitude,
                    destinationTitle:
                        '$destinationLatitude - $destinationLongitude',
                  );
                },
                child: Text(context.l10n.availableMapAppsMenu),
              ),
              OutlinedButton(
                onPressed: () => context.pushNamed(
                  MapsPage.pageName,
                  pathParameters: {
                    kLatitude: '$latitude',
                    kLongitude: '$longitude',
                  },
                ),
                child: Text(context.l10n.goToMaps),
              ),
            ],
          ),
        );
      },
    );
  }

  void onViewCreated(
    GoogleNavigationViewController controller,
    BuildContext context,
  ) {
    context.homeBloc.add(
      HomeCreateNavigationViewController(
        controller: controller,
      ),
    );
  }

  Future<void> addMarkerToMap(
    BuildContext context,
    GoogleNavigationViewController? navigationViewController, {
    LatLng? latLng,
  }) async {
    if (navigationViewController == null) return;
    late LatLng position;
    if (latLng != null) {
      position = latLng;
    } else {
      // Add a marker to the current camera position.
      final cameraPosition = await navigationViewController.getCameraPosition();
      position = cameraPosition.target;
    }
    final options = MarkerOptions(
      position: position,
      infoWindow: const InfoWindow(title: '', snippet: ''),
    );
    await navigationViewController.clearMarkers();
    final addedMarkers =
        await navigationViewController.addMarkers(<MarkerOptions>[options]);

    if (!context.mounted) return;
    context.homeBloc.add(HomeSaveMarker(marker: addedMarkers.first!));
  }
}
