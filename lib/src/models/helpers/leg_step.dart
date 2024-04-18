part of mapbox_navigation_flutter;

class LegStep {
  final double distance;
  final double duration;
  final double durationTypical;
  final String speedLimitUnit;
  final String speedLimitSign;
  final dynamic shape;
  final List<String> destinations;
  final DrivingSide drivingSide;
  final List<String> exitNames;

  /// Only applicable on iOS
  final List<String> exitCodes;

  /// Only applicable on iOS
  final List<String> codes;

  /// Only applicable on iOS
  final List<String> destinationCodes;
  final Maneuver? maneuver;

  const LegStep._({
    required this.distance,
    required this.duration,
    required this.durationTypical,
    required this.speedLimitUnit,
    required this.speedLimitSign,
    required this.shape,
    required this.destinations,
    required this.drivingSide,
    required this.exitNames,
    required this.exitCodes,
    required this.codes,
    required this.destinationCodes,
    required this.maneuver,
  });

  static LegStep? fromAndroid(Map<String, dynamic>? json) => json != null
      ? LegStep._(
          distance: double.parse(json['distance'].toString()),
          duration: double.parse(json['duration'].toString()),
          durationTypical: double.parse(json['durationTypical'].toString()),
          destinations: (json['destinations'] as String).split(','),
          drivingSide: DrivingSide.fromAndroid(json),
          exitNames: (json['exits'] as String).split(','),
          exitCodes: [],
          codes: [],
          destinationCodes: [],
          maneuver:
              Maneuver.fromAndroid(json['maneuver'] as Map<String, dynamic>?),
          shape: json['geometry'],
          speedLimitSign: json['speedLimitSign'] as String,
          speedLimitUnit: json['speedLimitUnit'] as String,
        )
      : null;

  static LegStep? fromIOS(Map<String, dynamic>? json) => json != null
      ? LegStep._(
          distance: double.parse(json['distance'].toString()),
          duration: double.parse(json['expectedTravelTime'].toString()),
          durationTypical: double.parse(json['typicalTravelTime'].toString()),
          destinations: (json['destinations'] as List).cast<String>(),
          drivingSide: DrivingSide.fromIOS(json),
          exitNames: (json['exitNames'] as List).cast<String>(),
          exitCodes: (json['exitCodes'] as List).cast<String>(),
          codes: (json['codes'] as List).cast<String>(),
          destinationCodes: (json['destinationCodes'] as List).cast<String>(),
          maneuver: Maneuver.fromIOS(json),
          shape: json['shape'],
          speedLimitSign: json['speedLimitSign'] as String,
          speedLimitUnit: json['speedLimitUnit'] as String,
        )
      : null;
}
