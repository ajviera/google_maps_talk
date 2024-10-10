import 'package:json_annotation/json_annotation.dart';

part 'route.g.dart';

/// {@template coordinates}
/// Class representing a route with distance and duration
/// {@endtemplate}
@JsonSerializable()
class Route {
  /// {@macro coordinates}
  /// Default constructor for the class.
  Route({
    this.distanceMeters,
    this.duration,
  });

  /// Method to serialize the data from a JSON
  factory Route.fromJson(Map<String, dynamic> json) {
    return _$RouteFromJson(json);
  }

  /// [distanceMeters] contains the distance of the route in meters.
  final int? distanceMeters;

  /// [duration] contains the duration of the route in seconds.
  final String? duration;
}
