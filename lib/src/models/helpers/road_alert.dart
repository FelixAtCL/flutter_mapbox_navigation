part of mapbox_navigation_flutter;

class RoadAlert {
  final RoadObject? roadObject;
  final double distanceTraveled;

  const RoadAlert._({required this.distanceTraveled, required this.roadObject});

  static RoadAlert? fromAndroid(Map<String, dynamic>? json) => json != null
      ? RoadAlert._(
          distanceTraveled: double.parse(json['distanceToStart'].toString()),
          roadObject: RoadObject.fromAndroid(
            json['roadObject'] as Map<String, dynamic>?,
          ),
        )
      : null;

  static RoadAlert? fromIOS(Map<String, dynamic>? json) => json != null
      ? RoadAlert._(
          distanceTraveled: double.parse(json['distanceToStart'].toString()),
          roadObject: RoadObject.fromIOS(
            json['roadObject'] as Map<String, dynamic>?,
          ),
        )
      : null;
}
