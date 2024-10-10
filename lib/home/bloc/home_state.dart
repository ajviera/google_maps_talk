part of 'home_bloc.dart';

enum HomeStatus {
  initial,
  completed,
  loading,
  routeLoading,
  error,
  permissionDenied,
  permissionPermanentlyDenied,
  timeout,
  routeError;

  bool get isLoading => this == HomeStatus.loading;
  bool get isRouteLoading => this == HomeStatus.routeLoading;
  bool get isCompleted => this == HomeStatus.completed;
  bool get isError => this == HomeStatus.error;
  bool get isRouteError => this == HomeStatus.routeError;
}

class HomeState extends Equatable {
  const HomeState({
    required this.status,
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.route = const {},
    this.errorMessage = '',
    this.markers = const <Marker>[],
    this.availableMapApps,
    this.navigationViewController,
  });

  const HomeState.initial()
      : this(
          status: HomeStatus.initial,
          route: const {},
          latitude: 0,
          longitude: 0,
          errorMessage: '',
          markers: const <Marker>[],
        );

  final HomeStatus status;
  final double latitude;
  final double longitude;
  final Map<String, dynamic> route;
  final String errorMessage;
  final List<Marker> markers;
  final List<AvailableMap>? availableMapApps;
  final GoogleNavigationViewController? navigationViewController;

  HomeState copyWith({
    HomeStatus? status,
    double? latitude,
    double? longitude,
    Map<String, dynamic>? route,
    String? errorMessage,
    List<Marker>? markers,
    List<AvailableMap>? availableMapApps,
    GoogleNavigationViewController? navigationViewController,
  }) {
    return HomeState(
      status: status ?? this.status,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      route: route ?? this.route,
      errorMessage: errorMessage ?? this.errorMessage,
      markers: markers ?? this.markers,
      availableMapApps: availableMapApps ?? this.availableMapApps,
      navigationViewController:
          navigationViewController ?? this.navigationViewController,
    );
  }

  @override
  List<Object?> get props => [
        status,
        latitude,
        longitude,
        route,
        errorMessage,
        markers,
        availableMapApps,
        navigationViewController,
      ];
}
