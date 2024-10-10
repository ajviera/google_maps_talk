// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Route _$RouteFromJson(Map<String, dynamic> json) => Route(
      distanceMeters: (json['distanceMeters'] as num?)?.toInt(),
      duration: json['duration'] as String?,
    );

Map<String, dynamic> _$RouteToJson(Route instance) => <String, dynamic>{
      'distanceMeters': instance.distanceMeters,
      'duration': instance.duration,
    };
