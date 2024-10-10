import 'package:api_client/api_client.dart';

/// {@template locations_exception}
/// A base class for [LocationResource] exceptions.
/// {@endtemplate}
abstract class LocationsException implements Exception {
  /// {@macro locations_exception}
  const LocationsException(this.message, this.stackTrace);

  /// The error which was caught.
  final String message;

  /// The error stack trace.
  final StackTrace stackTrace;
}

/// {@template locations_fetch_failure}
/// Exception thrown when fetching locations fails.
/// {@endtemplate}
class LocationsFetchFailure extends LocationsException {
  /// {@macro locations_fetch_failure}
  const LocationsFetchFailure(
    super.message,
    super.stackTrace,
  );
}
