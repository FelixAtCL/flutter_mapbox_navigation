part of mapbox_navigation_flutter;

class Maneuver {
  final double headingBefore;
  final double headingAfter;
  final double latitude;
  final double longitude;
  final String type;
  final String instruction;

  const Maneuver._({
    required this.headingAfter,
    required this.headingBefore,
    required this.latitude,
    required this.longitude,
    required this.type,
    required this.instruction,
  });

  static Maneuver? fromAndroid(Map<String, dynamic>? json) => json != null
      ? Maneuver._(
          headingAfter: double.parse(json['bearingAfter'].toString()),
          headingBefore: double.parse(json['bearingAfter'].toString()),
          instruction: json['instruction'] as String,
          latitude: double.parse(
            ((json['location'] as Map<String, dynamic>)['coordinates'] as List)
                .skip(1)
                .first
                .toString(),
          ),
          longitude: double.parse(
            ((json['location'] as Map<String, dynamic>)['coordinates'] as List)
                .first
                .toString(),
          ),
          type: json['type'] as String,
        )
      : null;

  static Maneuver? fromIOS(Map<String, dynamic>? json) => json != null
      ? Maneuver._(
          headingAfter: double.parse(json['finalHeading'].toString()),
          headingBefore: double.parse(json['initialHeading'].toString()),
          latitude: double.parse(
            (json['maneuverLocation'] as Map<String, dynamic>)['latitude']
                .toString(),
          ),
          longitude: double.parse(
            (json['maneuverLocation'] as Map<String, dynamic>)['longitude']
                .toString(),
          ),
          type: json['maneuverType'] as String,
          instruction: json['instructionsSpokenAlongStep'] as String,
        )
      : null;
}
