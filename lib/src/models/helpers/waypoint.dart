part of mapbox_navigation_flutter;

class Waypoint {
  final String name;
  final double latitude;
  final double longitude;

  const Waypoint._({
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  static Waypoint? fromAndroid(Map<String, dynamic>? json) => json != null
      ? Waypoint._(
          name: json['name'] as String,
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
        )
      : null;

  static Waypoint? fromIOS(Map<String, dynamic>? json) => json != null
      ? Waypoint._(
          name: json['name'] as String,
          latitude: double.parse(
            (json['coordinate'] as Map<String, dynamic>)['latitude'].toString(),
          ),
          longitude: double.parse(
            (json['coordinate'] as Map<String, dynamic>)['longitude']
                .toString(),
          ),
        )
      : null;
}
