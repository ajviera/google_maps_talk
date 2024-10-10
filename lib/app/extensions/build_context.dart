import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_talk/home/home.dart';
import 'package:location_repository/location_repository.dart';

extension BuildContextX on BuildContext {
  HomeBloc get homeBloc => read<HomeBloc>();
  LocationRepository get locationRepository => read<LocationRepository>();
}
