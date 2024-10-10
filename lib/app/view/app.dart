import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_talk/app/app.dart';
import 'package:google_maps_talk/l10n/l10n.dart';
import 'package:location_repository/location_repository.dart';

class App extends StatelessWidget {
  App({
    required LocationRepository locationRepository,
    super.key,
  })  : _routerConfig = AppRouter.router(),
        _locationRepository = locationRepository;

  final GoRouter _routerConfig;
  final LocationRepository _locationRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _locationRepository),
      ],
      child: AppView(
        routerConfig: _routerConfig,
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({
    required GoRouter routerConfig,
    super.key,
  }) : _routerConfig = routerConfig;

  final GoRouter _routerConfig;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: _routerConfig,
      title: 'google_maps_talk',
    );
  }
}
