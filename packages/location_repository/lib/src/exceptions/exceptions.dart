/// {@template location_permission_exception}
/// Base class for all [Location Repository] failures.
/// {@endtemplate}
class LocationPermissionException implements Exception {
  /// {@macro location_permissions_exception}
  const LocationPermissionException({required this.message});

  /// Error message
  final String message;
}

/// {@template location_permission_denied_exception}
/// Thrown when fails to get location permission
/// {@endtemplate}
class LocationPermissionDeniedException extends LocationPermissionException {
  ///
  LocationPermissionDeniedException({required super.message});
}

/// {@template location_permission_permanent_denied_exception}
/// Thrown when fails to get location permission and is permanent
/// {@endtemplate}
class LocationPermissionPermanentDeniedException
    extends LocationPermissionException {
  ///
  LocationPermissionPermanentDeniedException({required super.message});
}

/// {@template location_services_disabled_exception}
/// Thrown when location services are disabled
/// {@endtemplate}
class LocationServicesDisabledException extends LocationPermissionException {
  ///
  LocationServicesDisabledException({required super.message});
}

/// {@template location_timeout_exception}
/// Thrown when location request times out
/// {@endtemplate}
class LocationTimeOutException extends LocationPermissionException {
  /// {@macro location_timeout_exception}
  LocationTimeOutException({required super.message});
}
