import 'package:go_router/go_router.dart';
import 'package:google_maps_talk/app/constants/constants.dart';
import 'package:google_maps_talk/app/constants/navigation_keys.dart';
import 'package:google_maps_talk/home/home.dart';
import 'package:google_maps_talk/maps/maps.dart';

class AppRouter {
  static GoRouter router() {
    return GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: HomePage.path,
      redirect: (context, state) {
        return null;
      },
      routes: [
        GoRoute(
          path: HomePage.path,
          pageBuilder: (context, state) {
            return const HomePage();
          },
        ),
        GoRoute(
          path: MapsPage.path,
          name: MapsPage.pageName,
          pageBuilder: (context, state) {
            final latitude = state.pathParameters[kLatitude];
            final longitude = state.pathParameters[kLongitude];

            return MapsPage(
              latitude: double.tryParse(latitude!) ?? 0.0,
              longitude: double.tryParse(longitude!) ?? 0.0,
            );
          },
        ),
      ],
    );
  }
}
