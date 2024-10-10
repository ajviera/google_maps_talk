import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'coordinates.g.dart';

/// {@template coordinates}
/// Coordinates model
/// {@endtemplate}
@JsonSerializable()
class Coordinates extends Equatable {
  /// {@macro coordinates}
  const Coordinates({
    required this.latitude,
    required this.longitude,
  });

  /// From JSON factory
  factory Coordinates.fromJson(Map<String, dynamic> json) =>
      _$CoordinatesFromJson(json);

  /// Latitude
  final double latitude;

  /// Longitude
  final double longitude;

  /// To JSON
  Map<String, dynamic> toJson() => _$CoordinatesToJson(this);

  @override
  List<Object?> get props => [latitude, longitude];
}
