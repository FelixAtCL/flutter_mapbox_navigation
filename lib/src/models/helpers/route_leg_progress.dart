part of mapbox_navigation_flutter;

class RouteLegProgress {
  final RouteLeg? leg;
  final double distanceTraveled;
  final double fractionTraveled;
  final double durationRemaining;
  final double distanceRemaining;
  final int shapeIndex;
  final RouteStepProgress? routeStepProgress;
  final int currentSpeedLimit;

  RouteLegProgress._({
    required this.leg,
    required this.distanceRemaining,
    required this.currentSpeedLimit,
    required this.fractionTraveled,
    required this.distanceTraveled,
    required this.durationRemaining,
    required this.routeStepProgress,
    required this.shapeIndex,
  });

  static RouteLegProgress? fromAndroid(Map<String, dynamic>? json) => json !=
          null
      ? RouteLegProgress._(
          leg: RouteLeg.fromAndroid(json['routeLeg'] as Map<String, dynamic>),
          distanceRemaining: double.parse(json['distanceRemaining'].toString()),
          distanceTraveled: double.parse(json['distanceTraveled'].toString()),
          fractionTraveled: double.parse(json['fractionTraveled'].toString()),
          durationRemaining: double.parse(json['durationRemaining'].toString()),
          shapeIndex: int.parse(json['geometryIndex'].toString()),
          currentSpeedLimit: 0,
          routeStepProgress: RouteStepProgress.fromAndroid(
            json['currentStepProgress'] as Map<String, dynamic>?,
          ),
        )
      : null;

  static RouteLegProgress? fromIOS(Map<String, dynamic>? json) => json != null
      ? RouteLegProgress._(
          leg: RouteLeg.fromIOS(json['leg'] as Map<String, dynamic>),
          distanceRemaining: double.parse(json['distanceRemaining'].toString()),
          distanceTraveled: double.parse(json['distanceTraveled'].toString()),
          fractionTraveled: double.parse(json['fractionTraveled'].toString()),
          durationRemaining: double.parse(json['durationRemaining'].toString()),
          shapeIndex: int.parse(json['shapeIndex'].toString()),
          currentSpeedLimit:
              int.tryParse(json['currentSpeedLimit'].toString()) ?? -1,
          routeStepProgress: RouteStepProgress.fromIOS(
            json['currentStepProgress'] as Map<String, dynamic>?,
          ),
        )
      : null;
}
