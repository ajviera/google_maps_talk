import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_talk/home/home.dart';
import 'package:google_maps_talk/l10n/l10n.dart';
import 'package:google_maps_talk_ui/google_maps_talk_ui.dart';
import 'package:map_launcher/map_launcher.dart';

class MapsSheet extends StatelessWidget {
  const MapsSheet({
    required this.startingLatitude,
    required this.startingLongitude,
    required this.destinationLatitude,
    required this.destinationLongitude,
    required this.destinationTitle,
    super.key,
  });

  final double startingLatitude;
  final double startingLongitude;
  final double destinationLatitude;
  final double destinationLongitude;
  final String destinationTitle;

  static void show(
    BuildContext context, {
    required double startingLatitude,
    required double startingLongitude,
    required double destinationLatitude,
    required double destinationLongitude,
    required String destinationTitle,
  }) {
    GoogleMapsTalkBottomSheet.showModal<void>(
      context,
      title: context.l10n.availableMapApps,
      body: BlocProvider.value(
        value: context.read<HomeBloc>(),
        child: MapsSheet(
          startingLatitude: startingLatitude,
          startingLongitude: startingLongitude,
          destinationLatitude: destinationLatitude,
          destinationLongitude: destinationLongitude,
          destinationTitle: destinationTitle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final availableMaps = context.read<HomeBloc>().state.availableMapApps ?? [];
    const iconSize = 30.0;

    return Flexible(
      child: ListView.separated(
        itemCount: availableMaps.length,
        shrinkWrap: true,
        separatorBuilder: (context, index) {
          return const Divider();
        },
        itemBuilder: (context, index) {
          final map = availableMaps[index];
          return ListTile(
            onTap: () => onMapTap(map, context),
            title: Text(map.mapName),
            leading: SvgPicture.asset(
              map.icon,
              height: iconSize,
              width: iconSize,
            ),
          );
        },
      ),
    );
  }

  Future<void> onMapTap(AvailableMap map, BuildContext context) async {
    context.read<HomeBloc>().add(
          HomeNavigationCalled(
            mapApp: map,
            destinationTitle: destinationTitle,
            destinationLatitude: destinationLatitude,
            destinationLongitude: destinationLongitude,
          ),
        );
    context.pop();
  }
}
