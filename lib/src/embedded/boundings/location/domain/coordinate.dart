part of mapbox_navigation_flutter;

class Coordinate {
  /// Creates a Coordinate object
  Coordinate({required this.latitude, required this.longitude});

  /// Creates a [Coordinate] object from a JSON object
  Coordinate.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'] as double;
    longitude = json['longitude'] as double;
  }

  late double latitude;
  late double longitude;
}
