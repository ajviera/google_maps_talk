import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_navigation_flutter/google_navigation_flutter.dart';
import 'package:location_repository/location_repository.dart';
import 'package:map_launcher/map_launcher.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required LocationRepository locationRepository,
  })  : _locationRepository = locationRepository,
        super(const HomeState.initial()) {
    on<HomeLocationRequest>(_onHomeLocationRequest);
    on<HomeRouteApiRequest>(_onHomeRoutesApiRequest);
    on<HomeSaveMarker>(_onHomeSaveMarker);
    on<HomeClearMarker>(_onHomeClearMarker);
    on<HomeAvailableMapsAppLoaded>(_onHomeAvailableMapsAppLoaded);
    on<HomeNavigationCalled>(_onHomeNavigationCalled);
    on<HomeCreateNavigationViewController>(
      _onHomeCreateNavigationViewController,
    );
  }

  final LocationRepository _locationRepository;
  final List<Marker> _markers = [];

  FutureOr<void> _onHomeLocationRequest(
    HomeLocationRequest event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      final location = await _locationRepository.getLocation();
      emit(
        state.copyWith(
          status: HomeStatus.initial,
          latitude: location.latitude,
          longitude: location.longitude,
        ),
      );
    } on Exception {
      emit(state.copyWith(status: HomeStatus.error));
    }
  }

  FutureOr<void> _onHomeRoutesApiRequest(
    HomeRouteApiRequest event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: HomeStatus.routeLoading));
    try {
      late Map<String, dynamic>? route;

      if (event.startingLatitude == 0 &&
          event.startingLongitude == 0 &&
          event.endingLatitude == 0 &&
          event.endingLongitude == 0) {
        final currentLocation = await _locationRepository.getLocation();

        // using the haversine formula to calculate the distance
        // between two points
        // 1 degree of latitude is approximately 111320 meters
        const meters = 1000;
        const coef = meters / 111320.0;

        // calculate the ending latitude and longitude
        final endingLatitude = currentLocation.latitude + coef;
        final endingLongitude = currentLocation.longitude +
            coef / math.cos(endingLatitude * 0.01745);

        route = await _locationRepository.calculateRoute(
          startingLatitude: currentLocation.latitude,
          startingLongitude: currentLocation.longitude,
          endingLatitude: endingLatitude,
          endingLongitude: endingLongitude,
        );
      } else {
        route = await _locationRepository.calculateRoute(
          startingLatitude: event.startingLatitude,
          startingLongitude: event.startingLongitude,
          endingLatitude: event.endingLatitude,
          endingLongitude: event.endingLongitude,
        );
      }

      emit(
        state.copyWith(
          status: HomeStatus.completed,
          route: route,
        ),
      );
    } catch (e) {
      log('HomeBloc: Error fetching routes', error: e);
      emit(
        state.copyWith(
          status: HomeStatus.routeError,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  FutureOr<void> _onHomeSaveMarker(
    HomeSaveMarker event,
    Emitter<HomeState> emit,
  ) async {
    _markers.add(event.marker);

    emit(
      state.copyWith(
        markers: _markers,
      ),
    );
  }

  FutureOr<void> _onHomeClearMarker(
    HomeClearMarker event,
    Emitter<HomeState> emit,
  ) async {
    _markers.clear();
    emit(
      state.copyWith(
        markers: _markers,
      ),
    );
  }

  FutureOr<void> _onHomeAvailableMapsAppLoaded(
    HomeAvailableMapsAppLoaded event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final availableMapApps = await MapLauncher.installedMaps;
      emit(
        state.copyWith(availableMapApps: availableMapApps),
      );
    } catch (e) {
      emit(state.copyWith(status: HomeStatus.error));
    }
  }

  FutureOr<void> _onHomeCreateNavigationViewController(
    HomeCreateNavigationViewController event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final navigationViewController = event.controller;
      await navigationViewController.setMyLocationEnabled(true);
      emit(
        state.copyWith(navigationViewController: navigationViewController),
      );
    } catch (e) {
      emit(state.copyWith(status: HomeStatus.error));
    }
  }

  FutureOr<void> _onHomeNavigationCalled(
    HomeNavigationCalled event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final userLocation = await _locationRepository.getLocation();
      await event.mapApp.showDirections(
        destination: Coords(
          event.destinationLatitude,
          event.destinationLongitude,
        ),
        destinationTitle: event.destinationTitle,
        origin: Coords(userLocation.latitude, userLocation.longitude),
      );
    } on LocationPermissionDeniedException {
      emit(state.copyWith(status: HomeStatus.permissionDenied));
    } on LocationPermissionPermanentDeniedException {
      emit(
        state.copyWith(status: HomeStatus.permissionPermanentlyDenied),
      );
    } on LocationTimeOutException {
      emit(state.copyWith(status: HomeStatus.timeout));
    } catch (e) {
      emit(state.copyWith(status: HomeStatus.error));
    }
  }
}
