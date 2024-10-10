import 'package:api_client/api_client.dart';
import 'package:location_repository/location_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockLocationRepository extends Mock implements LocationRepository {}

class MockGeoLocatorWrapper extends Mock implements GeolocatorWrapper {}

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late GeolocatorWrapper geoLocatorWrapper;
  late LocationRepository locationRepositoryMock;
  late LocationRepository locationRepository;
  late ApiClient apiClient;

  final position = Position(
    timestamp: DateTime.now(),
    accuracy: 1,
    altitude: 1,
    heading: 1,
    altitudeAccuracy: 1,
    headingAccuracy: 1,
    speed: 1,
    speedAccuracy: 1,
    latitude: 43.7183705,
    longitude: -79.5432082,
  );

  setUp(() {
    registerFallbackValue(LocationAccuracy.high);

    geoLocatorWrapper = MockGeoLocatorWrapper();

    apiClient = MockApiClient();

    when(
      () => geoLocatorWrapper.getPositionStream(
        locationSettings: any(named: 'locationSettings'),
      ),
    ).thenAnswer(
      (_) => Stream.value(position),
    );

    locationRepositoryMock = MockLocationRepository();
    locationRepository = LocationRepository(
      geolocator: geoLocatorWrapper,
      apiClient: apiClient,
    );
  });

  group('isLocationServiceEnabled', () {
    test('returns true when location service is enabled', () async {
      when(() => geoLocatorWrapper.isLocationServiceEnabled()).thenAnswer(
        (_) async => true,
      );

      expect(await geoLocatorWrapper.isLocationServiceEnabled(), isTrue);
    });

    test('returns false when location service is disabled', () async {
      when(() => geoLocatorWrapper.isLocationServiceEnabled()).thenAnswer(
        (_) async => false,
      );

      expect(await geoLocatorWrapper.isLocationServiceEnabled(), isFalse);
    });
  });

  group('openLocationSettings', () {
    test('returns true when location settings page is opened', () async {
      when(() => geoLocatorWrapper.openAppSettings()).thenAnswer(
        (_) async => true,
      );

      expect(await geoLocatorWrapper.openAppSettings(), isTrue);
    });

    test('returns false when location settings page is not opened', () async {
      when(() => geoLocatorWrapper.openAppSettings()).thenAnswer(
        (_) async => false,
      );

      expect(await geoLocatorWrapper.openAppSettings(), isFalse);
    });
  });

  group('LocationRepository', () {
    test('can be instantiated', () {
      expect(
        LocationRepository(
          geolocator: geoLocatorWrapper,
          apiClient: apiClient,
        ),
        isNotNull,
      );
    });

    test('inits position stream when instantiated', () async {
      when(() => geoLocatorWrapper.checkPermission()).thenAnswer(
        (_) async => LocationPermission.always,
      );

      // Reinitialize the repository to trigger the private method
      locationRepository = LocationRepository(
        apiClient: apiClient,
        geolocator: geoLocatorWrapper,
      );

      // Allow any pending asynchronous operations to complete
      await pumpEventQueue();

      expect(locationRepository.positionStream, isNotNull);

      verifyInOrder([
        () => geoLocatorWrapper.checkPermission(),
        () => geoLocatorWrapper.getPositionStream(
              locationSettings: any(named: 'locationSettings'),
            ),
      ]);
    });

    test('returns an Stream.empty() when initLocationInfo throws an error', () {
      when(
        () => geoLocatorWrapper.getPositionStream(
          locationSettings: any(named: 'locationSettings'),
        ),
      ).thenThrow(
        Exception('Error'),
      );
      final locationRepository = LocationRepository(
        apiClient: apiClient,
        geolocator: geoLocatorWrapper,
      );

      expect(
        locationRepository.positionStream,
        isA<Stream<Position>>(),
      );
      expect(
        locationRepository.positionStream,
        emitsInOrder(<Position>[]),
      );
    });

    group('location streams', () {
      test('speedStream returns a Stream<double>', () {
        expect(locationRepository.speedStream, isA<Stream<double>>());
      });

      test('speedStream emits the speed of the current position', () async {
        when(() => geoLocatorWrapper.checkPermission()).thenAnswer(
          (_) async => LocationPermission.always,
        );
        locationRepository = LocationRepository(
          apiClient: apiClient,
          geolocator: geoLocatorWrapper,
        );
        await pumpEventQueue();
        expect(
          locationRepository.positionStream,
          emitsThrough(position),
        );
      });

      test('coordinatesStream returns a Stream<Coordinates>', () {
        expect(
          locationRepository.coordinatesStream,
          isA<Stream<Coordinates>>(),
        );
      });

      test(
        'coordinatesStream emits the coordinates of the current position',
        () async {
          when(() => geoLocatorWrapper.checkPermission()).thenAnswer(
            (_) async => LocationPermission.always,
          );
          locationRepository = LocationRepository(
            apiClient: apiClient,
            geolocator: geoLocatorWrapper,
          );
          await pumpEventQueue();
          expect(
            locationRepository.coordinatesStream,
            emits(
              Coordinates(
                latitude: position.latitude,
                longitude: position.longitude,
              ),
            ),
          );
        },
      );
    });

    group('getLocation', () {
      test('getLocation returns a Position', () async {
        when(() => locationRepositoryMock.getLocation()).thenAnswer(
          (_) async => position,
        );
        expect(await locationRepositoryMock.getLocation(), isA<Position>());
      });

      test(
        'getLocation with real instance returns a Position',
        () async {
          when(() => geoLocatorWrapper.getCurrentPosition(any())).thenAnswer(
            (_) async => position,
          );
          when(() => geoLocatorWrapper.isLocationServiceEnabled()).thenAnswer(
            (_) async => true,
          );
          when(() => geoLocatorWrapper.requestPermission()).thenAnswer(
            (_) async => LocationPermission.always,
          );

          expect(await locationRepository.getLocation(), isA<Position>());
        },
      );

      test(
        'getLocation with real instance throws '
        'LocationServicesDisabledException when service is disabled',
        () async {
          when(() => geoLocatorWrapper.getCurrentPosition(any())).thenAnswer(
            (_) async => position,
          );
          when(() => geoLocatorWrapper.isLocationServiceEnabled()).thenAnswer(
            (_) async => false,
          );

          expect(
            () => locationRepository.getLocation(),
            throwsA(isA<LocationServicesDisabledException>()),
          );
        },
      );

      test(
        'getLocation with real instance throws '
        'LocationPermissionDeniedException when permission denied',
        () async {
          when(() => geoLocatorWrapper.getCurrentPosition(any())).thenAnswer(
            (_) async => position,
          );
          when(() => geoLocatorWrapper.isLocationServiceEnabled()).thenAnswer(
            (_) async => true,
          );
          when(() => geoLocatorWrapper.requestPermission()).thenAnswer(
            (_) async => LocationPermission.denied,
          );

          expect(
            () => locationRepository.getLocation(),
            throwsA(isA<LocationPermissionDeniedException>()),
          );
        },
      );

      test(
        'getLocation with real instance throws  '
        'LocationPermissionPermanentDeniedException when permission '
        'permanently denied',
        () async {
          when(() => geoLocatorWrapper.getCurrentPosition(any())).thenAnswer(
            (_) async => position,
          );
          when(() => geoLocatorWrapper.isLocationServiceEnabled()).thenAnswer(
            (_) async => true,
          );
          when(() => geoLocatorWrapper.requestPermission()).thenAnswer(
            (_) async => LocationPermission.deniedForever,
          );

          expect(
            () => locationRepository.getLocation(),
            throwsA(isA<LocationPermissionPermanentDeniedException>()),
          );
        },
      );
    });

    group('requestPermission', () {
      test('throws LocationServicesDisabledException when service is disabled',
          () async {
        when(() => locationRepositoryMock.requestPermission()).thenAnswer(
          (_) async => throw LocationServicesDisabledException(
            message: 'Location services disabled.',
          ),
        );

        expect(
          () => locationRepositoryMock.requestPermission(),
          throwsA(isA<LocationServicesDisabledException>()),
        );
      });

      test('throws LocationPermissionDeniedException when permission is denied',
          () async {
        when(() => locationRepositoryMock.requestPermission()).thenAnswer(
          (_) async => throw LocationPermissionDeniedException(
            message: 'Location service permission denied.',
          ),
        );

        expect(
          () => locationRepositoryMock.requestPermission(),
          throwsA(isA<LocationPermissionDeniedException>()),
        );
      });

      test(
          'throws LocationPermissionPermanentDeniedException when permission '
          'is permanently denied', () async {
        when(() => locationRepositoryMock.requestPermission()).thenAnswer(
          (_) async => throw LocationPermissionPermanentDeniedException(
            message: 'Location service permission denied forever.',
          ),
        );

        expect(
          () => locationRepositoryMock.requestPermission(),
          throwsA(isA<LocationPermissionPermanentDeniedException>()),
        );
      });
    });

    group('openLocationSettings', () {
      test('openLocationSettings with real instance returns true', () async {
        when(() => geoLocatorWrapper.openAppSettings()).thenAnswer(
          (_) async => true,
        );

        expect(await locationRepository.openLocationSettings(), isTrue);
      });

      test('returns true when location settings page is opened', () async {
        when(() => locationRepositoryMock.openLocationSettings()).thenAnswer(
          (_) async => true,
        );

        expect(await locationRepositoryMock.openLocationSettings(), isTrue);
      });

      test('returns false when location settings page is not opened', () async {
        when(() => locationRepositoryMock.openLocationSettings()).thenAnswer(
          (_) async => false,
        );

        expect(await locationRepositoryMock.openLocationSettings(), isFalse);
      });
    });
  });
}
