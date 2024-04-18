part of mapbox_navigation_flutter;

class RouteLeg {
  final String summary;
  final double distance;
  final double duration;
  final double durationTypical;
  final List<LegStep?> steps;

  const RouteLeg._({
    required this.summary,
    required this.distance,
    required this.duration,
    required this.durationTypical,
    required this.steps,
  });

  static RouteLeg? fromAndroid(Map<String, dynamic>? json) => json != null
      ? RouteLeg._(
          distance: double.parse(json['distance'].toString()),
          duration: double.parse(json['duration'].toString()),
          durationTypical: double.parse(json['durationTypical'].toString()),
          summary: json['summary'] as String,
          steps: (json['steps'] as List)
              .map((step) => LegStep.fromAndroid(step as Map<String, dynamic>?))
              .toList(),
        )
      : null;

  static RouteLeg? fromIOS(Map<String, dynamic>? json) => json != null
      ? RouteLeg._(
          distance: double.parse(json['distance'].toString()),
          duration: double.parse(json['typicalTravelTime'].toString()),
          durationTypical: double.parse(json['expectedTravelTime'].toString()),
          summary: json['name'] as String,
          steps: (json['steps'] as List)
              .map((step) => LegStep.fromIOS(step as Map<String, dynamic>?))
              .toList(),
        )
      : null;
}
