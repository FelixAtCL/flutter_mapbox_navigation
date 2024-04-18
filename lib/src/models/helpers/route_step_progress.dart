part of mapbox_navigation_flutter;

class RouteStepProgress {
  final LegStep? step;
  final double distanceTraveled;
  final double durationRemaining;
  final double fractionTraveled;
  final double distanceRemaining;
  final int intersectionIndex;
  final int instructionIndex;
  final Intersection? currentIntersection;
  final Intersection? upcomingIntersection;

  const RouteStepProgress._({
    required this.step,
    required this.distanceTraveled,
    required this.durationRemaining,
    required this.fractionTraveled,
    required this.distanceRemaining,
    required this.intersectionIndex,
    required this.instructionIndex,
    required this.currentIntersection,
    required this.upcomingIntersection,
  });

  static RouteStepProgress? fromAndroid(Map<String, dynamic>? json) => json !=
          null
      ? RouteStepProgress._(
          step: LegStep.fromAndroid(json['step'] as Map<String, dynamic>?),
          distanceRemaining: double.parse(json['distanceRemaining'].toString()),
          durationRemaining: double.parse(json['durationRemaining'].toString()),
          fractionTraveled: double.parse(json['fractionTraveled'].toString()),
          distanceTraveled: double.parse(json['distanceTraveled'].toString()),
          intersectionIndex: int.parse(json['intersectionIndex'].toString()),
          instructionIndex: int.parse(json['instructionIndex'].toString()),
          currentIntersection: Intersection.fromAndroid(
            json['currentIntersection'] as Map<String, dynamic>?,
          ),
          upcomingIntersection: Intersection.fromAndroid(
            json['upcomingIntersection'] as Map<String, dynamic>?,
          ),
        )
      : null;

  static RouteStepProgress? fromIOS(Map<String, dynamic>? json) => json != null
      ? RouteStepProgress._(
          step: LegStep.fromIOS(json['step'] as Map<String, dynamic>?),
          distanceRemaining: double.parse(json['distanceRemaining'].toString()),
          durationRemaining: double.parse(json['durationRemaining'].toString()),
          fractionTraveled: double.parse(json['fractionTraveled'].toString()),
          distanceTraveled: double.parse(json['distanceTraveled'].toString()),
          intersectionIndex: int.parse(json['intersectionIndex'].toString()),
          instructionIndex: int.parse(json['instructionIndex'].toString()),
          currentIntersection: Intersection.fromIOS(
            json['currentIntersection'] as Map<String, dynamic>?,
          ),
          upcomingIntersection: Intersection.fromIOS(
            json['upcomingIntersection'] as Map<String, dynamic>?,
          ),
        )
      : null;
}
