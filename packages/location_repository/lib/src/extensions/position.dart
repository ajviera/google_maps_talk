import 'package:location_repository/location_repository.dart';

/// Extension on [Position]
extension PositionX on Position {
  /// Converts a [Position] to [Coordinates]
  Coordinates get toCoordinates => Coordinates(
        latitude: latitude,
        longitude: longitude,
      );
}
