part of 'home_bloc.dart';

class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class HomeLocationRequest extends HomeEvent {
  const HomeLocationRequest();

  @override
  List<Object> get props => [];
}

class HomeRouteApiRequest extends HomeEvent {
  const HomeRouteApiRequest({
    this.startingLatitude = 0,
    this.startingLongitude = 0,
    this.endingLatitude = 0,
    this.endingLongitude = 0,
  });

  final double startingLatitude;
  final double startingLongitude;
  final double endingLatitude;
  final double endingLongitude;

  @override
  List<Object> get props => [
        startingLatitude,
        startingLongitude,
        endingLatitude,
        endingLongitude,
      ];
}

class HomeSaveMarker extends HomeEvent {
  const HomeSaveMarker({
    required this.marker,
  });

  final Marker marker;

  @override
  List<Object> get props => [marker];
}

class HomeClearMarker extends HomeEvent {
  const HomeClearMarker();

  @override
  List<Object> get props => [];
}

class HomeAvailableMapsAppLoaded extends HomeEvent {
  const HomeAvailableMapsAppLoaded();

  @override
  List<Object> get props => [];
}

class HomeCreateNavigationViewController extends HomeEvent {
  const HomeCreateNavigationViewController({
    required this.controller,
  });

  final GoogleNavigationViewController controller;

  @override
  List<Object> get props => [controller];
}

class HomeNavigationCalled extends HomeEvent {
  const HomeNavigationCalled({
    required this.destinationLatitude,
    required this.destinationLongitude,
    required this.destinationTitle,
    required this.mapApp,
  });

  final double destinationLatitude;
  final double destinationLongitude;
  final String destinationTitle;
  final AvailableMap mapApp;

  @override
  List<Object> get props => [
        destinationLatitude,
        destinationLongitude,
        destinationTitle,
        mapApp,
      ];
}
