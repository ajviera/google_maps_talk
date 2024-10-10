import 'package:location_repository/location_repository.dart';
import 'package:test/test.dart';

void main() {
  group('Coordinates', () {
    test('can be instantiated', () {
      const coordinates = Coordinates(
        latitude: 43.7183705,
        longitude: -79.5432082,
      );

      expect(coordinates, isNotNull);
      expect(coordinates, isA<Coordinates>());
    });

    test('can be converted to a string', () {
      const coordinates = Coordinates(
        latitude: 43.7183705,
        longitude: -79.5432082,
      );

      expect(coordinates.toString(), 'Coordinates(43.7183705, -79.5432082)');
    });

    test('can be compared', () {
      const coordinates1 = Coordinates(
        latitude: 43.7183705,
        longitude: -79.5432082,
      );

      const coordinates2 = Coordinates(
        latitude: 43.7183705,
        longitude: -79.5432082,
      );

      expect(coordinates1, equals(coordinates2));
    });

    test('fromJson', () {
      final json = <String, dynamic>{
        'latitude': 43.7183705,
        'longitude': -79.5432082,
      };

      final coordinates = Coordinates.fromJson(json);

      expect(coordinates, isA<Coordinates>());
      expect(coordinates.latitude, json['latitude']);
      expect(coordinates.longitude, json['longitude']);
    });

    test('toJson', () {
      final json = <String, dynamic>{
        'latitude': 43.7183705,
        'longitude': -79.5432082,
      };

      const coordinates = Coordinates(
        latitude: 43.7183705,
        longitude: -79.5432082,
      );

      expect(coordinates.toJson(), json);
    });

    test('props', () {
      const coordinates = Coordinates(
        latitude: 43.7183705,
        longitude: -79.5432082,
      );

      expect(coordinates.props, [43.7183705, -79.5432082]);
    });
  });
}
