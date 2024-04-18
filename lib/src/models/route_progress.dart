part of mapbox_navigation_flutter;

class RouteProgress {
  final int currentLegIndex;
  final double distanceTraveled;
  final double fractionTraveled;
  final double durationRemaining;
  final double distanceRemaining;
  final int remainingWaypointsCount;
  final List<Waypoint?> remainingWaypoints;
  final List<RoadAlert?> upcomingRoadAlerts;
  final RouteOptions? routeOptions;
  final RouteLeg? currentLeg;
  final RouteLegProgress? currentLegProgress;
  final RouteLeg? upcomingLeg;

  const RouteProgress._({
    required this.currentLeg,
    required this.currentLegIndex,
    required this.currentLegProgress,
    required this.distanceRemaining,
    required this.distanceTraveled,
    required this.durationRemaining,
    required this.fractionTraveled,
    required this.remainingWaypoints,
    required this.remainingWaypointsCount,
    required this.routeOptions,
    required this.upcomingLeg,
    required this.upcomingRoadAlerts,
  });

  static RouteProgress fromAndroid(Map<String, dynamic> json) =>
      RouteProgress._(
        currentLeg:
            RouteLeg.fromAndroid(json['currentLeg'] as Map<String, dynamic>?),
        currentLegIndex: int.parse(json['currentLegIndex'].toString()),
        currentLegProgress: RouteLegProgress.fromAndroid(
          json['currentLegProgress'] as Map<String, dynamic>?,
        ),
        distanceRemaining: double.parse(json['distanceRemaining'].toString()),
        durationRemaining: double.parse(json['durationRemaining'].toString()),
        distanceTraveled: double.parse(json['distanceTraveled'].toString()),
        fractionTraveled: double.parse(json['fractionTraveled'].toString()),
        remainingWaypoints: (json['remainingWaypoints'] as List)
            .map(
              (waypoint) =>
                  Waypoint.fromAndroid(waypoint as Map<String, dynamic>?),
            )
            .toList(),
        remainingWaypointsCount:
            int.parse(json['remainingWaypointsCount'].toString()),
        routeOptions: RouteOptions.fromAndroid(
          json['routeOptions'] as Map<String, dynamic>?,
        ),
        upcomingRoadAlerts: (json['upcomingRoadObjects'] as List)
            .map(
              (object) => RoadAlert.fromAndroid(object as Map<String, dynamic>),
            )
            .toList(),
        upcomingLeg:
            RouteLeg.fromAndroid(json['upcomingLeg'] as Map<String, dynamic>?),
      );

  static RouteProgress fromIOS(Map<String, dynamic> json) => RouteProgress._(
        currentLeg:
            RouteLeg.fromIOS(json['currentLeg'] as Map<String, dynamic>?),
        currentLegIndex: int.parse(json['legIndex'].toString()),
        currentLegProgress: RouteLegProgress.fromIOS(
          json['currentLegProgress'] as Map<String, dynamic>?,
        ),
        distanceRemaining: double.parse(json['distanceRemaining'].toString()),
        durationRemaining: double.parse(json['durationRemaining'].toString()),
        distanceTraveled: double.parse(json['distanceTraveled'].toString()),
        fractionTraveled: double.parse(json['fractionTraveled'].toString()),
        remainingWaypoints: (json['remainingWaypoints'] as List)
            .map(
              (waypoint) => Waypoint.fromIOS(waypoint as Map<String, dynamic>?),
            )
            .toList(),
        remainingWaypointsCount:
            int.parse(json['remainingWaypointsCount'].toString()),
        routeOptions: RouteOptions.fromIOS(
          json['routeOptions'] as Map<String, dynamic>?,
        ),
        upcomingRoadAlerts: (json['upcomingRouteAlerts'] as List)
            .map(
              (object) => RoadAlert.fromIOS(object as Map<String, dynamic>),
            )
            .toList(),
        upcomingLeg:
            RouteLeg.fromIOS(json['upcomingLeg'] as Map<String, dynamic>?),
      );
}
