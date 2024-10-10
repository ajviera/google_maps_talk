import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_talk/app/app.dart';
import 'package:google_maps_talk/home/home.dart';

class HomePage extends Page<void> {
  const HomePage();
  static const path = '/home';

  @override
  Route<void> createRoute(BuildContext context) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      settings: this,
      builder: (ctx) {
        return BlocProvider(
          create: (_) => HomeBloc(
            locationRepository: context.locationRepository,
          )
            ..add(const HomeAvailableMapsAppLoaded())
            ..add(const HomeLocationRequest()),
          child: const HomeView(),
        );
      },
    );
  }
}
